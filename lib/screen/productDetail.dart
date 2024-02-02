// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, void_checks, unused_local_variable

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:recan/http/httpProductComment.dart';
import 'package:recan/http/httpProductlike.dart';
import 'package:recan/http/productOrder.dart';
import 'package:recan/main.dart';
import 'package:recan/screen/cart/cart.dart';
// import 'package:recan/screen/cart/usecasecart/shopinglogic.dart';
import 'package:recan/screen/myOrderPage.dart';
import 'package:recan/utils/url.dart';
import '../utilities/token.dart';
import 'cart/usecasecart/shopinglogic.dart';

class ProductDetailPage extends StatefulWidget {
  final data;
  const ProductDetailPage({super.key, @required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final storage = const FlutterSecureStorage();

// delete product
  Future deteleProduct(String productid) async {
    print(productid);
    final response =
        await http.delete(Uri.parse("${baseurl}product/delete/$productid"));
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      // print(data);
      return response;
    } else {
      print('err');
    }
  }

  //  like
  Future<bool> likeProduct(String productid) {
    var res = HttpProductlike().like(productid);
    return res;
  }

  //notification
  void notify() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'Item Added to Cart Page',
          body: 'Pasell For You',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture:
              'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
    );
  }

  Future unlikeProduct(String likeid) async {
    var token = await storage.read(key: 'token');
    print(likeid);
    final response = await http.delete(
        Uri.parse("${baseurl}product/unlike/$likeid"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 201) {
      print(data);
      return response;
    } else {
      print('err');
    }
  }

// /likproducte/count
  bool likes = false;
  Future getLike() async {
    var productid = widget.data['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse('${baseurl}product/like/count/$productid'), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    likes = true;
    print(likes);
    return jData;
  }

// product like filter
  Future filterLike() async {
    var productid = widget.data['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse('${baseurl}product/like/filter/$productid'), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    print(jData);
    return jData;
  }

  // comment
  String comment = '';
  final formkey = GlobalKey<FormState>();
  //
  Future<bool> commentPost(String comment, String product) async {
    var res = HttpProductcomment().comment(comment, product);
    return res;
  }

  // order subscribe
  Future<bool> order(String orderingid) {
    var res = Httporder().order(orderingid);
    return res;
  }

  // unsubscribe
  Future unsubscribe(String orderid) async {
    var token = await storage.read(key: 'token');
    final response = await http.delete(
        Uri.parse(baseurl + "unorder/product/$orderid"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body) as Map;
    if (response.statusCode == 200) {
      return response;
    } else {
      print('err');
    }
  }

  // subscribe
  Future filterSubscribe() async {
    var orderingid = widget.data['user']['_id'];
    var token = await storage.read(key: 'token');
    final response = await http
        .get(Uri.parse(baseurl + 'filter/orders/' + orderingid), headers: {
      'Authorization': 'Bearer $token',
    });
    var jData = jsonDecode(response.body);
    print(jData);
    return jData;
  }

  // get comment

  getComment() async {
    var product = widget.data['_id'];
    var res = await http.get(Uri.parse("${baseurl}show/comment/$product"));
    print(res);
    var data = jsonDecode(res.body);

    return data;
  }

  // delete comment
  Future deteleComment(String commentid) async {
    var token = await storage.read(key: 'token');
    print(commentid);
    final response = await http.delete(
        Uri.parse("${baseurl}delete/comment/$commentid"),
        headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      print(data);
      return response;
    } else {
      print('err');
    }
  }

  var id;
  Future token() async {
    final userData = await parseToken();
    id = userData['userId'];
    print("Userid" + id);
    return id;
  }

  @override
  void initState() {
    super.initState();
    getComment().then((responce) {
      setState(() {
        return responce;
      });
    });
    token().then((responce) {
      setState(() {
        return responce;
      });
    });
    getLike().then((responce) {
      setState(() {
        return responce;
      });
    });
    filterLike().then((responce) {
      setState(() {
        return responce;
      });
    });
    filterSubscribe().then((responce) {
      setState(() {
        return responce;
      });
    });
  }

// ------------------------------------------------------------------

  ShoppingCart cart = ShoppingCart();
  // ShoppingCart cart = ShoppingCart.instance;

  @override
  Widget build(BuildContext context) {
    print("Data" + widget.data['user']['_id']);
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "${widget.data['title']}",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Handle share button press
                },
                color: Colors.white, // Adjust the color as needed
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: double.infinity,
              ),
              child: Column(
                // height: MediaQuery.of(context).size.height,
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    constraints: BoxConstraints.expand(
                      width: MediaQuery.of(context).size.width *
                          0.9, // Adjust the percentage as needed
                      height: MediaQuery.of(context).size.width *
                          0.7, // Adjust the percentage as needed
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage("$baseurl/${widget.data['image']}"),
                        fit: BoxFit
                            .cover, // Choose an appropriate fit based on your requirement
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          constraints: BoxConstraints.expand(
                            width: MediaQuery.of(context).size.width *
                                0.1, // Adjust the percentage as needed
                            height: MediaQuery.of(context).size.width *
                                0.1, // Adjust the percentage as needed
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "$baseurl/${widget.data['image']}"),
                              fit: BoxFit
                                  .cover, // Choose an appropriate fit based on your requirement
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          constraints: BoxConstraints.expand(
                            width: MediaQuery.of(context).size.width *
                                0.1, // Adjust the percentage as needed
                            height: MediaQuery.of(context).size.width *
                                0.1, // Adjust the percentage as needed
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "$baseurl/${widget.data['image']}"),
                              fit: BoxFit
                                  .cover, // Choose an appropriate fit based on your requirement
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rs.${widget.data['price']}",
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              // Add other text widgets as needed
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 234, 224, 224),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: const Color.fromARGB(255, 250, 249, 249),
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10),
                              child: widget.data['user']['image'] != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "$baseurl/${widget.data['user']['image']}"),
                                      radius: 20,
                                    )
                                  : const CircleAvatar(
                                      backgroundImage:
                                          AssetImage("images/icon.png"),
                                      radius: 40,
                                    )),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User's image with the same logic as provided

                                Text(
                                  "${widget.data['user']['username']}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Date: ${widget.data['date']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Rs.${widget.data['price']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Rs.${widget.data['catogery']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 234, 224, 224),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          // ignore: avoid_unnecessary_containers
                          child: Container(
                            child: Text(
                              "${widget.data['title']}",
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Color.fromARGB(255, 7, 7, 7),
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      // like product
                      // likes == false ?
                      FutureBuilder(
                          future: filterLike(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return snapshot.hasData
                                ?
                                //  snapshot.data['user'] == id?
                                Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await unlikeProduct(
                                              snapshot.data['_id']);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.star,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                      FutureBuilder(
                                          future: getLike(),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            return snapshot.hasData
                                                ? Text(
                                                    '${snapshot.data.length}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  )
                                                : const Text(
                                                    '0',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  );
                                          })
                                    ],
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await likeProduct(widget.data['_id']);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.star_border,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  );
                          })
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "${widget.data['description']}",
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                  // image

                  // user detail and product
                  // user image

                  // edit and delete product

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                              minimumSize: const Size(170, 52),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            onPressed: () async {
                              // Create a Productmodel instance using the data from widget.data
                              Productmodel productToAdd = Productmodel(
                                id: widget.data['_id'],
                                title: widget.data['title'],
                                catogery: widget.data['catogery'],
                                description: widget.data['description'],
                                image: widget.data['image'],
                                date: widget.data['date'],
                                price: widget.data['price'],
                              );

                              // Add the product to the cart
                              cart.addToCart(productToAdd);
                              // Provider.of<ShoppingCart>(context, listen: false)
                              //     .addToCart(productToAdd);

                              // Show a notification or any other feedback to the user
                              notify();

                              // Navigate to the CartScreen
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRightWithFade,
                                  child: CartScreen(cart: cart),
                                ),
                              );
                            },
                            child: const Text(
                              " Add to Cart",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          widget.data['user']['_id'] == id
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              : FutureBuilder(
                                  future: filterSubscribe(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    return snapshot.hasData
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size(170, 52),
                                                backgroundColor:
                                                    Colors.blue[400]),
                                            onPressed: () {
                                              setState(() {
                                                unsubscribe(
                                                    snapshot.data['_id']);
                                              });
                                            },
                                            child: const Text('UnSubscribe'))
                                        : ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                order(
                                                    widget.data['user']['_id']);
                                              });
                                            },
                                            child: const Text('Subscribe'));
                                  }),
                        ],
                      ),
                    ),
                  ),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 40),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                    ]),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Product Comments",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Form(
                        key: formkey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: TextFormField(
                            onSaved: (val) {
                              comment = val!;
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Empty comment cannot be posted';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Comment here",
                              border: const OutlineInputBorder(),
                              // Add IconButton inside the prefixIcon
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.comment),
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    formkey.currentState!.save();

                                    var res = await commentPost(
                                        comment, widget.data['_id']);
                                    if (res) {
                                      MotionToast.success(
                                              description: const Text(
                                                  "Product Comments"))
                                          .show(context);
                                    } else {
                                      MotionToast.error(
                                              description: const Text(
                                                  "Something went wrong"))
                                          .show(context);
                                    }
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Text(
                        "All comments",
                        style: TextStyle(fontSize: 20),
                      ),
                      // Show comments
                      Container(
                          height: 400,
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          child: FutureBuilder(
                            future: getComment(),
                            builder: (context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      19.0),
                                                  child: snapshot.data[index]
                                                                  ['user']
                                                              ['image'] !=
                                                          null
                                                      ? CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  'http://$baseUrl/${snapshot.data[index]['user']['image']}'),
                                                        )
                                                      : const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'images/assets/icon.jpg')),
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    '${snapshot.data[index]['comment']}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                snapshot.data[index]['user']
                                                            ['_id'] ==
                                                        id
                                                    ? IconButton(
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          deteleComment(snapshot
                                                                  .data[index]
                                                              ['_id']);
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete))
                                                    : const Text('')
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : const CircularProgressIndicator();
                            },
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
