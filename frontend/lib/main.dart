import 'package:chanakya/screens/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'plant_disease_detection.dart';
import 'pest_detection.dart';
import 'recommendations.dart';
import 'soil_health.dart';
import 'chatbot_page.dart';
import 'SplashScreen.dart';
import 'home.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Background message received: ${message.notification?.title}, ${message.notification?.body}');
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // // Subscribe to the plant_alert topic
    // FirebaseMessaging.instance.subscribeToTopic("plant_alert");
    //
    // // Listen for messages when the app is in the foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     String? imageUrl = message.notification?.android?.imageUrl;
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: Text(message.notification!.title ?? ""),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             if (imageUrl != null)
    //               Image.network(imageUrl), // Display the image
    //             Text(message.notification!.body ?? ""),
    //           ],
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(),
    //             child: Text("OK"),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GreenGuard AI',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.6),
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        elevation: 0,
        toolbarHeight: 35.0,
        centerTitle: true,
      ),

      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(controller: _controller, maincontext: context),
      ChatbotPage(),
      PestDetection(),
      Recommendations(),
      SoilHealth(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: ("GAI Bot"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.camera_alt),
        title: ("Scan"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.water_drop),
        title: ("Irrigation"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.terrain),
        title: ("Soil Health"),
        activeColorPrimary: Colors.green,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}


