import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recan/screen/Entry/loginScreen.dart';
import 'package:recan/screen/Entry/registerScreen.dart';
import 'package:recan/screen/HomeScreen.dart';
import 'package:recan/screen/cart/cart.dart';
import 'package:recan/screen/splashScreen.dart';
import 'package:recan/sensors/GyroscopeEvent.dart';
import 'screen/navigation_screen/servicepage.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductmodelAdapter());
  await Hive.openBox<Productmodel>('cart');
  AwesomeNotifications().initialize('resource://drawable/launcher', [
    NotificationChannel(
        channelKey: 'key1',
        channelName: 'jems khanal',
        channelDescription: "Pasell Notify You",
        defaultColor: const Color(0XFF9050DD),
        ledColor: const Color.fromARGB(255, 14, 120, 241),
        playSound: true,
        enableLights: true,
        importance: NotificationImportance.High,
        enableVibration: true)
  ]);
  runApp(const mainApp());
}

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  // var id;
  token() async {
    const storage = FlutterSecureStorage();
    var tok = await storage.read(key: 'token');
    if (tok != null) {
      // id = tok;
      print("i m  the token");
      print(tok);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingCart()),
      ],
      child: FutureBuilder(
          future: token(),
          builder: (context, AsyncSnapshot snapshot) {
            // print(snapshot.data);
            return KhaltiScope(
                publicKey: "test_public_key_d5d9f63743584dc38753056b0cc737d5",
                enabledDebugging: true,
                builder: (context, navkey) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    initialRoute: '/',
                    routes: {
                      '/': (context) => const SplashScreen(),
                      '/Login': (context) => const Login(),
                      // '/': (context) => const WLogin(),
                      '/RegisterPage': (context) => const RegisterPage(),
                      // '/Home': (context) => const recandrawer(),
                      '/GyrosensorPage': (context) =>
                          const GyrosensorPage(title: 'sensor'),
                      // '/GoogleMapScreen': (context) => const GoogleMapScreen(),
                      '/servicepage': (context) => const Servicepage(),
                      '/home': (context) => const HomeScreen(),
                    },
                    navigatorKey: navkey,
                    localizationsDelegates: const [
                      KhaltiLocalizations.delegate,
                    ],
                  );
                });
          }),
    );
  }
}




// class mainApp extends StatelessWidget {
//   const mainApp({super.key});

//   // var id;
//   Future<bool> token() async {
//     const storage = FlutterSecureStorage();
//     var tok = await storage.read(key: 'token');
//     if (tok != null) {
//       // id = tok;
//       print("i m  the token");
//       print(tok);
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ShoppingCart()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Builder(
//           builder: (context) {
//             return FutureBuilder(
//               future: token(),
//               builder: (context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   // If token is available, navigate to the home page,
//                   // otherwise, navigate to the login page.
//                   final initialRoute =
//                       snapshot.data == true ? '/home' : '/Login';
//                   return MaterialApp(
//                     initialRoute: initialRoute,
//                     routes: {
//                       '/': (context) => const SplashScreen(),
//                       '/Login': (context) => const Login(),
//                       '/RegisterPage': (context) => const RegisterPage(),
//                       '/GyrosensorPage': (context) =>
//                           const GyrosensorPage(title: 'sensor'),
//                       '/servicepage': (context) => const Servicepage(),
//                       '/home': (context) => const HomeScreen(),
//                     },
//                   );
//                 } else {
//                   return const SplashScreen(); // or a loading screen
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
