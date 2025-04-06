import 'package:chanakya/chatbot_page.dart';
import 'package:chanakya/login_page.dart';
import 'package:chanakya/pest_detection.dart';
import 'package:chanakya/plant_disease_detection.dart';
import 'package:chanakya/soil_health.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import 'irrigation.dart';

class HomeScreen extends StatefulWidget {
  final PersistentTabController controller; // Add this line
  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _images = [
    'https://t3.ftcdn.net/jpg/04/32/15/18/360_F_432151892_oQ3YQDo2LYZPILlEMnlo55PjjgiUwnQb.jpg',
    'https://t4.ftcdn.net/jpg/05/95/55/89/360_F_595558921_z1JnF4ieH75XlWoDPuh1Os97QkPnb4dx.jpg',
    'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202202/Budget-Health-%26-Agriculture-Fe.jpg?size=690:388',
  ];

  final String name = "Vijai";
  final String phoneNumber = "+91 63XXXXXX20";
  final String email = "admin@gmail.com";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10),
          // Hero Section with Images

          Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Green color for the header
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Mr. $name',
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87, // Darker text color for contrast
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Phone Number: $phoneNumber',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors
                          .grey[700], // Slightly muted color for info text
                    ),
                  ),
                  Text(
                    'Email: $email',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double
                        .infinity, // Ensures the button stretches full width
                    child: ElevatedButton(
                      onPressed: () async {
                        const url = 'https://example.com/farmer-manual'; // Replace with your manual URL
                        if (await canLaunchUrl(Uri.parse(url))) {
                          await launchUrl(
                            Uri.parse(url),
                            mode: LaunchMode.externalApplication, // Opens in the default browser
                          );
                        } else {
                          print('Could not launch $url');
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.green, // Button in green theme
                        foregroundColor:
                            Colors.white, // White text on the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        '🌾 Farmer Guide',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Logout functionality
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                            // remove isLoggedIn key from shared preferences
                            await prefs.remove('isLoggedIn');
                            print('Logged out');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            ); // Index for GAI Bot in _navBarItems
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            backgroundColor: Colors.red, // Red color for logout
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.controller.jumpToTab(
                                1); // Index for GAI Bot in _navBarItems
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            backgroundColor:
                                Colors.blue, // Blue for chat functionality
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Chat with GAI Bot',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Card Sections
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Features',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildFeatureCard(
                      title: 'Plant Disease Detection',
                      icon: Icons.eco,
                      color: Colors.lightGreen,
                      onPressed: () => widget.controller.jumpToTab(
                          2), // Index for Plant Disease Detection in _navBarItems
                    ),
                    _buildFeatureCard(
                      title: 'Pest Detection',
                      icon: Icons.bug_report,
                      color: Colors.orange,
                      onPressed: () => widget.controller.jumpToTab(
                          2), // Index for Pest Detection in _navBarItems
                    ),
                    _buildFeatureCard(
                      title: 'Personalized Recommendations',
                      icon: Icons.recommend,
                      color: Colors.blue,
                      onPressed: () => widget.controller.jumpToTab(
                          3) // Index for Irrigation Management in _navBarItems
                    ),
                    _buildFeatureCard(
                      title: 'Soil Health Analysis',
                      icon: Icons.terrain,
                      color: Colors.brown,
                      onPressed: () => widget.controller.jumpToTab(
                          4) // Index for Soil Health Analysis in _navBarItems
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Our Testimonials',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Matches the agriculture theme
                  ),
                ),
              ),
              Container(
                height: 200,
                child: PageView.builder(
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(_images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green[
                  50], // Light green background for an agricultural theme
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Crafted with ❤ by MIT Students',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Green for an aesthetic look
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Department of Computer Technology',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[800], // Muted dark color for contrast
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Colors.green, // A decorative green line
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: color,
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
