import 'dart:convert';
import 'package:http/http.dart' as http;
import 'item.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat item');
    }
  }

  Future<Item> createItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambah item');
    }
  }

  Future<Item> updateItem(int id, Item item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memperbarui item');
    }
  }

  Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus item');
    }
  }
}
