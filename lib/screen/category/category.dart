// import 'package:flutter/material.dart';
// import 'package:recan/http/getproduct.dart';

// import '../../utils/url.dart';
// // import 'package:recan/model/productModel.dart';
// // import 'package:your_project_name/http/getproduct.dart';

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key});

//   @override
//   _CategoryPageState createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   List<String> categories = []; // Empty list initially

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     try {
//       final List<Productmodel> allProducts = await getproduct.getPost();

//       // Extract distinct categories from all products
//       categories =
//           allProducts.map((product) => product.catogery ?? '').toSet().toList();

//       // Update the state to trigger a rebuild
//       setState(() {});
//     } catch (error) {
//       print('Error fetching categories: $error');
//       // Handle the error gracefully based on your app's requirements
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories'),
//       ),
//       body: ListView.builder(
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(categories[index]),
//             onTap: () async {
//               String selectedCategory = categories[index];
//               List<Productmodel> products =
//                   await getproduct.getProductsByCategory(selectedCategory);

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProductListScreen(
//                       products: products, category: selectedCategory),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:recan/http/getproduct.dart';

import '../../utils/url.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<String> categories = [];
  List<Productmodel>? productss;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final List<Productmodel> allProducts = await getproduct.getPost();
      categories =
          allProducts.map((product) => product.catogery ?? '').toSet().toList();
      setState(() {});
    } catch (error) {
      print('Error fetching categories: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Categories'),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          // Productmodel productssx = productss![index];
          return GestureDetector(
            onTap: () async {
              String selectedCategory = categories[index];
              List<Productmodel> products =
                  await getproduct.getProductsByCategory(selectedCategory);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                      products: products, category: selectedCategory),
                ),
              );
              // ... (previous code)
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 150.0, // Adjust the height as needed
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_960_720.jpg"),
                          // NetworkImage('$baseUrl${productssx.image ?? ''}'),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          categories[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        // Add other details like price, date, etc.
                        // Example:
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Productmodel> products;
  final String category;

  const ProductListScreen({
    super.key,
    required this.products,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: $category'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          Productmodel product = products[index];

          // Calculate aspect ratio
          double aspectRatio = 4 / 3; // You can adjust this aspect ratio

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 3,
              child: Row(
                children: [
                  Container(
                    width: 100, // Fixed width
                    height: 80 *
                        aspectRatio, // Calculate height based on aspect ratio
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage('$baseUrl${product.image ?? ''}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            product.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text('Price:${product.price ?? 0}'),
                          Text('Date: ${product.date ?? ''}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
