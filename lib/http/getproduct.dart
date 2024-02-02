// import 'dart:convert';

// // import 'package:recan/model/productModel.dart';
// // import 'package:recan/screen/category/category.dart';
// // import 'package:recan/screen/cart/cart.dart';
// import 'package:recan/model/productModel.dart';
// import 'package:recan/utils/url.dart';
// import 'package:http/http.dart' as http;

// class Getproduct {
//   bool isLoding = false;
//   Future getPost() async {
//     var res = await http.get(Uri.parse('${baseUrl}get/allproduct'));
//     var data = jsonDecode(res.body);
//     // print(data.length);
//     isLoding = true;
//     return data;
//   }

//   Future<List<Productmodel>> getProductsByCategory(String catogery) async {
//     try {
//       var allProducts = await getPost();

//       print("improduct");
//       print('All Products: $allProducts');

//       // Filter products by category
//       List<Productmodel> filteredProducts = allProducts
//           .where((product) =>
//               product.catogery.toLowerCase() == catogery.toLowerCase())
//           .toList();
//       print("impfiltr-----roduct");
//       print('Filtered Products: $filteredProducts');

//       return filteredProducts;
//     } catch (error) {
//       print('Error fetching products by category: $error');
//       throw Exception('Error: $error');
//     }
//   }
// }

// Getproduct getproduct = Getproduct();

import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/url.dart';
import 'package:http/http.dart' as http;

class Getproduct {
  bool isLoading = false;

  Future<List<Productmodel>> getPost() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}get/allproduct'));
      final data = jsonDecode(response.body);

      if (data is List) {
        return List<Productmodel>.from(
            data.map((item) => Productmodel.fromJson(item)));
      } else {
        throw Exception('Invalid response format. Expected a List.');
      }
    } catch (error) {
      print('Error fetching all products: $error');
      throw Exception('Error: $error');
    }
  }

  Future<List<Productmodel>> getProductsByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl}get/allproduct?category=$category'));

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Debug print to show the data being fetched
        print('Fetched data for category $category: $data');

        List<Productmodel> filteredProducts = data
            .where((item) => item['catogery'] == category)
            .map((item) => Productmodel.fromJson(item)
              ..date = item['date'] as String?
              ..price = item['price'] as int?)
            .toList();

        print("i m here filtered data");
        print(filteredProducts);

        return filteredProducts;
      } else {
        throw Exception(
            'Failed to fetch products. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products by category: $error');
      throw Exception('Error: $error');
    }
  }
}

Getproduct getproduct = Getproduct();

// Product model class
class Productmodel {
  String? id;
  String? title;
  String? catogery; // Fix the typo here
  String? description;
  String? image;
  String? date;
  int? price;
  int quantity;

  Productmodel({
    this.id,
    this.title,
    this.catogery, // Fix the typo here
    this.description,
    this.image,
    this.date,
    this.quantity = 0,
    this.price,
  });

  factory Productmodel.fromJson(Map<String, dynamic> obj) {
    return Productmodel(
      id: obj['_id'],
      title: obj['title'],
      catogery: obj['catogery'], // Fix the typo here
      description: obj['description'],
      image: obj['image'],
      date: obj['date'],
      price: obj['price'],
    );
  }

  // Add toJson method if needed
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'catogery': catogery, // Fix the typo here
      'description': description,
      'image': image,
      'date': date,
      'price': price,
    };
  }
}
