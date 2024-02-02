// import 'package:hive/hive.dart';
// import 'package:recan/screen/cart/cart.dart';

// class ShoppingCart {
//   Box<Productmodel>? cartBox;

//   ShoppingCart() {
//     openBox();
//   }

//   Future<void> openBox() async {
//     cartBox ??= await Hive.openBox<Productmodel>('cart');
//   }

//   void addToCart(Productmodel product) {
//     if (cartBox != null && cartBox!.containsKey(product.id)) {
//       var existingProduct = cartBox!.get(product.id)!;
//       existingProduct.quantity += 1;
//       cartBox!.put(product.id, existingProduct);
//     } else {
//       product.quantity = 1;
//       cartBox!.put(product.id, product);
//     }
//   }

//   Map<dynamic, Productmodel> getCartItems() {
//     return cartBox?.toMap() ?? {};
//   }
// }
import 'package:hive/hive.dart';
import 'package:recan/screen/cart/cart.dart';

// class ShoppingCart {
//   // Private constructor to prevent instantiation from outside
//   ShoppingCart._privateConstructor();

//   // Singleton instance
//   static final ShoppingCart _instance = ShoppingCart._privateConstructor();

//   // Factory method to provide the same instance
//   factory ShoppingCart() {
//     return _instance;
//   }

//   Box<Productmodel>? cartBox;

//   Future<void> openBox() async {
//     cartBox ??= await Hive.openBox<Productmodel>('cart');
//   }

//   void addToCart(Productmodel product) {
//     if (cartBox != null && cartBox!.containsKey(product.id)) {
//       var existingProduct = cartBox!.get(product.id)!;
//       existingProduct.quantity += 1;
//       cartBox!.put(product.id, existingProduct);
//     } else {
//       product.quantity = 1;
//       cartBox!.put(product.id, product);
//     }
//   }

//   Map<dynamic, Productmodel> getCartItems() {
//     return cartBox?.toMap() ?? {};
//   }
// }
