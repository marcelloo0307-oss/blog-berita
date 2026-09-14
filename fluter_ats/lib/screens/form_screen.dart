import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class FormScreen extends StatefulWidget {
  final PostModel? post; // Jika null = Tambah, jika ada isinya = Edit

  FormScreen({this.post});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final ApiService api = ApiService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  List<CategoryModel> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    loadCategories();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
      // Catatan: Karena backend getPosts tidak mengembalikan id_categories,
      // kita set null dulu, user harus pilih ulang saat edit. 
      // (Untuk perfect-nya, API GET /posts harusnya select juga id_categories nya)
    }
  }

  void loadCategories() async {
    try {
      var data = await api.getCategories();
      setState(() {
        categories = data;
        // Default pilih kategori pertama jika tambah baru
        if (categories.isNotEmpty && widget.post == null) {
          selectedCategoryId = categories.first.id;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void simpan() async {
    if (selectedCategoryId == null) return;
    
    bool success;
    if (widget.post == null) {
      // Create
      success = await api.createPost(selectedCategoryId!, _titleController.text, _contentController.text);
    } else {
      // Update
      success = await api.updatePost(widget.post!.id, selectedCategoryId!, _titleController.text, _contentController.text);
    }

    if (success) {
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post == null ? 'Tambah Artikel' : 'Edit Artikel')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedCategoryId,
              hint: Text('Pilih Kategori'),
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat.id,
                  child: Text(cat.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedCategoryId = val),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul', border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Isi Artikel', border: OutlineInputBorder()),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: simpan,
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            )
          ],
        ),
      ),
    );
  }
}