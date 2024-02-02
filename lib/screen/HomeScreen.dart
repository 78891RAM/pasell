import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recan/http/getproduct.dart';
import 'package:recan/screen/cart/cart.dart';
// import 'package:recan/screen/cart/usecasecart/shopinglogic.dart';
import 'package:recan/screen/cart/cart.dart';
import 'package:recan/screen/myOrderPage.dart';
import 'package:recan/screen/navigation_screen/custom_animated_bottom_bar.dart';
import 'package:recan/screen/product.dart';
import 'package:recan/screen/recanProfile.dart';
import 'package:recan/widgets/recandrawer.dart';
import '../constants.dart';
import 'category/category.dart';
import 'navigation_screen/payment.dart';
import 'navigation_screen/servicepage.dart';
import 'paymentgatway/khalti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  int _currentIndex = 0;
  final _inactiveColor = Colors.grey;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShoppingCart(),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: getBody(),
        drawer: recandrawer(context),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  AppBar homeAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[400],
      elevation: 20,
      // title: const Text("Recan App"),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
            icon: const Icon(Icons.search))
      ],
    );
  }

  Widget _buildBottomBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.white,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const Icon(Icons.apps, color: Color.fromARGB(255, 183, 17, 69)),
          title: const Text('Home'),
          activeColor: const Color.fromARGB(237, 49, 49, 49),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.category,
              color: Color.fromARGB(255, 15, 152, 54)),
          title: const Text('category'),
          activeColor: const Color.fromARGB(237, 49, 49, 49),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.shopping_cart,
              color: Color.fromARGB(255, 204, 179, 17)),
          title: const Text(
            'Cart ',
          ),
          activeColor: const Color.fromARGB(237, 49, 49, 49),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const Icon(
            Icons.person,
            color: Color.fromARGB(255, 152, 97, 15),
          ),
          title: const Text('Profile'),
          activeColor: const Color.fromARGB(237, 49, 49, 49),
          inactiveColor: _inactiveColor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = [
      const ProductPage(),
      const CategoryPage(),
      Consumer<ShoppingCart>(
        builder: (context, cart, child) => CartScreen(cart: cart),
      ),
      const ProfilePage(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
