import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exceptios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final url =
        'https://flutter-online-store-628f8-default-rtdb.firebaseio.com/products/$id.json';
    final oldIsFavorite = isFavorite;
    final newIsFavorite = !isFavorite;
    isFavorite = newIsFavorite;
    notifyListeners();

    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': newIsFavorite}),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Changing favorite status failed');
      }
    } catch (error) {
      isFavorite = oldIsFavorite;
      notifyListeners();
      throw error;
    }
  }
}
