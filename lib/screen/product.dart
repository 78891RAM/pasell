// ignore_for_file: library_private_types_in_public_api, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, unnecessary_getters_setters

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
// import 'package:recan/model/productModel.dart';
import 'package:recan/screen/Entry/loginScreen.dart';
import 'package:recan/screen/Entry/registerScreen.dart';
import 'package:recan/screen/category/category.dart';
import 'package:recan/screen/productDetail.dart';
import 'package:recan/utils/url.dart';
import 'package:recan/widgets/dawer.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import 'package:shake/shake.dart';

import '../widgets/crouselslider.dart';
import 'cart/cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  // late ShakeDetector detector;
  var user = '';

  var _onCardClick;

  get onCardClick => _onCardClick;

  set onCardClick(onCardClick) {
    _onCardClick = onCardClick;
  }

  // carousel image
  // ignore: prefer_typing_uninitialized_variables
  // ignore: non_constant_identifier_names
  final carousel_image = [
    "https://cdn.pixabay.com/photo/2017/05/09/03/46/alberta-2297204_960_720.jpg",
    "https://cdn.pixabay.com/photo/2018/10/05/14/39/sunset-3726030_960_720.jpg",
    "https://scontent.fktm3-1.fna.fbcdn.net/v/t1.6435-9/s1080x2048/163010005_1372219383115867_5653984754757638142_n.jpg?_nc_cat=107&ccb=1-5&_nc_sid=e3f864&_nc_ohc=dEkZ8_tpjHQAX9xfYvL&_nc_ht=scontent.fktm3-1.fna&oh=00_AT_HLZZKLLI3OxqbgRiCW7hKyl_C6kz3b0cMU5hhlXdHUQ&oe=61E057FD",
    "https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/07/24/19/57/tiger-2535888_960_720.jpg"
  ];

// carousel class
  Widget carouselImages(String carousel, int index) => Container(
        height: 250,
        width: 350,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Image.network(
          carousel,
          fit: BoxFit.cover,
        ),
      );

  // get all products
  List<Productmodel> postList = [];
  // ShoppingCart cart = ShoppingCart._instance;
  ShoppingCart cart = ShoppingCart();
  // ShoppingCart cart = ShoppingCart.instance;

  bool isLoding = false;
  Future getPost() async {
    var res = await http.get(Uri.parse('${baseUrl}get/allproduct'));
    var data = jsonDecode(res.body);
    // print(data.length);
    isLoding = true;
    return data;
  }

  final storage = const FlutterSecureStorage();
  //
  // // proximity sensor start here
  // bool _isNear = false;
  // late StreamSubscription<dynamic> _streamSubscription;
  // @override
  // void dispose() {
  //   super.dispose();
  //   _streamSubscription.cancel();
  // }

  // Future<void> listenSensor() async {
  //   FlutterError.onError = (FlutterErrorDetails details) {
  //     if (foundation.kDebugMode) {
  //       FlutterError.dumpErrorToConsole(details);
  //     }
  //   };
  //   _streamSubscription = ProximitySensor.events.listen((int event) {
  //     setState(() {
  //       _isNear = (event > 0) ? true : false;
  //       // print('check proximity sensor');
  //       if (_isNear == true) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const RegisterPage(key: null),
  //           ),
  //         );
  //       }
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   detector = ShakeDetector.autoStart(
  //     onPhoneShake: () {
  //       setState(() {
  //         Navigator.pushNamed(context, "/Login");
  //       });
  //     },
  //   );
  //   @override
  //   void dispose() {
  //     detector.stopListening();
  //     super.dispose();
  //   }

  //   super.initState();
  //   getPost().then((value) {
  //     setState(() {
  //       // ignore: void_checks
  //       return value;
  //     });
  //   });
  //   listenSensor().then((value) {
  //     setState(() {
  //       return value;
  //     });
  //   });
  //   //
  //   _streamSubscriptions.add(
  //     accelerometerEvents.listen(
  //       (AccelerometerEvent event) async {
  //         if (event.y > 10 && event.y < 15) {
  //           await storage.delete(key: 'token');
  //           // ignore: use_build_context_synchronously
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => const Login()));
  //         }
  //       },
  //     ),
  //   );
  // }
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const Drawer(child: recandrawer()),
      drawer: recandrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pasell", style: TextStyle(fontSize: 25)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MyCarousel(),
                const Divider(),
                const Text(
                  "Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const Divider(),
                FutureBuilder(
                  future: getPost(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        // ignore: avoid_unnecessary_containers
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 1.3,
                            width: MediaQuery.of(context).size.width * 3,
                            child: GridView.builder(
                              itemCount: snapshot.data!.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 2.5,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: ProductDetailPage(
                                                data: snapshot.data[index])));
                                    // onCardClick!();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    // height: 50,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          const Color.fromARGB(
                                                  255, 246, 244, 244)
                                              .withOpacity(0.1),
                                          const Color.fromARGB(0, 244, 243, 243)
                                        ],
                                      ),
                                    ),
                                    // padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          isLoding == true
                                              ? snapshot.data[index]['image'] !=
                                                      null
                                                  ? Hero(
                                                      tag: snapshot.data[index]
                                                          ['_id'],
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8),
                                                                topRight: Radius
                                                                    .circular(
                                                                        8)),
                                                        child: Image(
                                                          image: NetworkImage(
                                                              "$baseUrl${snapshot.data[index]['image']}"),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      "images/logo.png")
                                              : const CircularProgressIndicator(),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Text(
                                                  '${snapshot.data[index]['title']}',
                                                  style: const TextStyle(
                                                      fontSize: 19,
                                                      color: Color.fromARGB(
                                                          255, 5, 5, 5),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 6),
                                                child: Text(
                                                  "Rs."
                                                  '${snapshot.data[index]['price']}',
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// searching data method
class DataSearch extends SearchDelegate<String> {
  var title;
  Future getPost() async {
    var res = await http.get(Uri.parse('${baseUrl}get/allproduct'));
    var data = jsonDecode(res.body);
    // title = data[1]['title'];
    return data;
  }

  final data = [
    "Nepal",
    "laptop",
    "mobile",
    "bike",
    "Watch",
    "Heater",
    "Scooter",
    "Computer",
    "Tablet",
  ];
  final recentData = ["Recan", "Nepal", "Laptop", "Mobile"];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // action for the search
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear_outlined))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //leading item for the app bar
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    // show the result based on the selection
    return FutureBuilder(
        future: getPost(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return query == snapshot.data[index]['title']
                        ? ListTile(
                            leading: const Icon(Icons.photo),
                            title: Text(query),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ProductDetailPage(
                                          data: snapshot.data[index])));
                            },
                          )
                        : const Text('');
                  })
              : const CircularProgressIndicator();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print(getPost());
    // show suggestion when someone search for the product
    // final suggestion = data;
    return FutureBuilder(
        future: getPost(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) =>
                      //  query.isEmpty ?
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: Text(snapshot.data[index]['title']),
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: ProductDetailPage(
                                      data: snapshot.data[index])));
                        },
                      ))
              : const Center(child: Text('No thing to show'));
        });
  }
}
