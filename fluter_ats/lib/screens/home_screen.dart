import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService api = ApiService();
  late Future<List<PostModel>> futurePosts;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    setState(() {
      futurePosts = api.getPosts();
    });
  }

  void hapusArtikel(int id) async {
    bool success = await api.deletePost(id); 

    if (success) {
      loadData(); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Artikel berhasil dihapus dari database'),
          backgroundColor: const Color(0xFF0284C7),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengeksekusi penghapusan'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Color _resolveCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'e-sport':
        return const Color(0xFFEC4899);
      case 'politik':
        return const Color(0xFF14B8A6);
      case 'cuaca':
        return const Color(0xFF3B82F6);
      case 'dunia':
        return const Color(0xFFF59E0B);
      case 'kriminal':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'BLOG APP KELAS', 
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontSize: 16,
            color: Color(0xFFF8FAFC),
          ),
        ),
        centerTitle: false,
        titleSpacing: 24,
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF334155),
            height: 1,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormScreen()),
          );
          loadData(); 
        },
        backgroundColor: const Color(0xFF38BDF8),
        foregroundColor: const Color(0xFF0F172A),
        elevation: 4,
        icon: const Icon(Icons.add_task_rounded, weight: 700),
        label: const Text(
          "New Post",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ),
      body: FutureBuilder<List<PostModel>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
            );
          } 
          else if (snapshot.hasError) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 40),
                    const SizedBox(height: 12),
                    const Text(
                      'Koneksi Terputus',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pastikan backend node.js aktif di port 8000.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          } 
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.code_off_rounded, size: 64, color: Color(0xFF475569)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada record data di database.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var post = snapshot.data![index];
                  Color categoryColor = _resolveCategoryColor(post.categoryName);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: categoryColor.withOpacity(0.4)),
                                ),
                                child: Text(
                                  post.categoryName.toUpperCase(),
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FormScreen(post: post)),
                                      );
                                      loadData();
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.edit_outlined, size: 20, color: Color(0xFF94A3B8)),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: const Color(0xFF1E293B),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            side: const BorderSide(color: Color(0xFF334155)),
                                          ),
                                          title: const Text('Hapus Record?', style: TextStyle(color: Colors.white)),
                                          content: Text('Tindakan ini akan menghapus "${post.title}" secara permanen.', style: const TextStyle(color: Color(0xFF94A3B8))),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Batal', style: TextStyle(color: Color(0xFF94A3B8))),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFEF4444),
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                hapusArtikel(post.id);
                                              },
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFEF4444)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            post.title,
                            style: const TextStyle(
                              color: Color(0xFFF8FAFC),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            post.content,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 14.5,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}