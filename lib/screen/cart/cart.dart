import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recan/screen/cart/usecasecart/shopinglogic.dart';
import 'package:recan/screen/paymentgatway/khalti.dart';

import '../../http/getproduct.dart';
import '../../utils/url.dart';

class Productmodel {
  String? id;
  String? title;
  String? catogery;
  String? description;
  String? image;
  String? date;
  int? price;
  int quantity;

  Productmodel({
    this.id,
    this.title,
    this.catogery,
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
      catogery: obj['catogery'],
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
      'catogery': catogery,
      'description': description,
      'image': image,
      'date': date,
      'price': price,
    };
  }
}

class ProductmodelAdapter extends TypeAdapter<Productmodel> {
  @override
  final typeId = 0; // Unique type id for your model

  @override
  Productmodel read(BinaryReader reader) {
    // Implement how to read the object from binary
    // You can use reader methods like readString, readInt, etc.
    return Productmodel(
      id: reader.read(),
      title: reader.read(),
      catogery: reader.read(),
      description: reader.read(),
      image: reader.read(),
      date: reader.read(),
      quantity: reader.read(),
      price: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Productmodel obj) {
    // Implement how to write the object to binary
    // You can use writer methods like writeString, writeInt, etc.
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.catogery);
    writer.write(obj.description);
    writer.write(obj.image);
    writer.write(obj.date);
    writer.write(obj.quantity);
    writer.write(obj.price);
  }
}

class ShoppingCart extends ChangeNotifier {
  Box<Productmodel>? cartBox;

  ShoppingCart() {
    openBox();
  }

  Future<void> openBox() async {
    cartBox ??= await Hive.openBox<Productmodel>('cart');
  }

  void addToCart(Productmodel product) {
    if (cartBox != null) {
      if (cartBox!.containsKey(product.id)) {
        var existingProduct = cartBox!.get(product.id)!;
        existingProduct.quantity += 1;
        cartBox!.put(product.id, existingProduct);
      } else {
        product.quantity = 1;
        cartBox!.put(product.id, product);
      }
    }
  }

  Map<dynamic, Productmodel> getCartItems() {
    return cartBox?.toMap() ?? {};
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Productmodel> postList = [];
  bool isLoading = false;
  ShoppingCart cart = ShoppingCart();
  // ShoppingCart cart = ShoppingCart._instance;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      var data = await getproduct.getPost();
      List<Productmodel> products = List<Productmodel>.from(
        data.map((productData) =>
            Productmodel.fromJson(productData as Map<String, dynamic>)),
      );

      setState(() {
        postList = products;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.shopping_cart),
                cart.getCartItems().isNotEmpty
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            cart.getCartItems().length.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: postList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(postList[index].title ?? ''),
                  subtitle: Text(postList[index].description ?? ''),
                  trailing: Text('Price: \$${postList[index].price ?? 0}'),
                  onTap: () {
                    // Provider.of<ShoppingCart>(context, listen: false).addToCart(productToAdd);
                    cart.addToCart(postList[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added to cart'),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final ShoppingCart cart;

  const CartScreen({super.key, required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String referenceId = "";
  @override
  Widget build(BuildContext context) {
    List<Productmodel> cartItems = widget.cart.getCartItems().values.toList();

    // ignore: avoid_types_as_parameter_names
    return Consumer<ShoppingCart>(builder: (context, ShoppingCart, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Shopping Cart'),
            ],
          ),
          backgroundColor: Colors.blue[400],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: widget.cart.getCartItems().isEmpty
            ? const Center(
                child: Text('Your shopping cart is empty.'),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        Productmodel product = cartItems[index];
                        debugPrint('Item: $product');
                        print(widget.cart.getCartItems());

                        print("he im cart");
                        print('Item: $product');

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: product.image != null
                                  ? NetworkImage("$baseurl/${product.image}")
                                  // ? NetworkImage(product.image!)
                                  : null,
                            ),
                            title: Text(
                              product.title ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              '\$${product.price ?? 0}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (product.quantity > 1) {
                                      setState(() {
                                        product.quantity -= 1;
                                      });
                                      widget.cart.cartBox!
                                          .put(product.id, product);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${product.quantity}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      product.quantity += 1;
                                    });
                                    widget.cart.cartBox!
                                        .put(product.id, product);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.cart.cartBox!.delete(product.id);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_shopping_cart,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Items in Cart: ${widget.cart.getCartItems().length}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Total Amount: \$${calculateTotalAmount(cartItems)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      payWithKhaltiInApp();
                      // Add your logic for proceeding to payment
                      // This can include navigation to the payment screen
                      // or any other necessary actions.
                    },
                    child: const Text('Proceed to Payment'),
                  ),
                ],
              ),
      );
    });
  }

  String calculateTotalAmount(List<Productmodel> cartItems) {
    int totalAmount = 0;
    for (Productmodel item in cartItems) {
      totalAmount += item.price! * item.quantity;
    }
    return totalAmount.toString();
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          actions: [
            SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                  });

                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }
}
