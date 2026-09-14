import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/category_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  // --- GET SEMUA ARTIKEL ---
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data'];
        return data.map((e) => PostModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat artikel: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Server tidak dapat dihubungi. Pastikan backend menyala.\nError: $e');
    }
  }

  // --- GET SEMUA KATEGORI ---
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data'];
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat kategori');
      }
    } catch (e) {
      throw Exception('Gagal koneksi ke server: $e');
    }
  }

  // --- POST TAMBAH ARTIKEL ---
  Future<bool> createPost(int categoryId, String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_categories': categoryId,
          'title': title,
          'content': content,
        }),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('Error Create: $e');
      return false;
    }
  }

  // --- PUT UPDATE ARTIKEL ---
  Future<bool> updatePost(int id, int categoryId, String title, String content) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_categories': categoryId,
          'title': title,
          'content': content,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error Update: $e');
      return false;
    }
  }

  // --- DELETE ARTIKEL ---
  Future<bool> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Error Delete: $e');
      return false;
    }
  }
}