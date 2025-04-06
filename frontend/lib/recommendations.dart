import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';

class Recommendations extends StatefulWidget {
  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> with TickerProviderStateMixin {
  final String fertilizerApiUrl = "https://gai-fertilizer-recommendation-api.azurewebsites.net/recommend-fertilizer";
  final String cropRotationApiUrl = "https://gai-crop-recommendation-api.azurewebsites.net/recommend-crop";
  bool isLoading = false;
  String recommendationResult = "";
  String? selectedSoilType;
  String? selectedCropType;
  String? selectedPreviousCrop;

  List<String> soilTypes = ["Clay", "Sandy", "Loamy"];
  List<String> cropTypes = ["Tomato", "Potato", "Wheat", "Corn", "Rice", "Soybean"];
  List<String> previousCrops = ["Tomato", "Potato", "Wheat", "Corn", "Rice", "Soybean"];

  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchFertilizerRecommendations() async {
    setState(() {
      isLoading = true;
      recommendationResult = "Analyzing soil data...";
    });

    await Future.delayed(500.ms);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double? temperature = prefs.getDouble('temperature');
      double? soilMoisture = prefs.getDouble('soilMoisture');
      double? airHumidity = prefs.getDouble('airHumidity');
      double? nitrogen = prefs.getDouble('nitrogen');
      double? phosphorus = prefs.getDouble('phosphorus');
      double? potassium = prefs.getDouble('potassium');

      if (temperature == null || soilMoisture == null || airHumidity == null ||
          nitrogen == null || phosphorus == null || potassium == null ||
          selectedSoilType == null || selectedCropType == null) {
        setState(() {
          recommendationResult = "⚠️ Missing data. Please select crop/soil type and update soil health.";
          isLoading = false;
        });
        return;
      }

      Map<String, dynamic> requestBody = {
        "Temperature": temperature,
        "Soil Moisture": soilMoisture,
        "Air Humidity": airHumidity,
        "Nitrogen Content": nitrogen,
        "Phosphorus Content": phosphorus,
        "Potassium Content": potassium,
        "Soil Type": selectedSoilType,
        "Crop Type": selectedCropType,
      };

      final response = await http.post(
        Uri.parse(fertilizerApiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['Recommended Fertilizer'] != null) {
          setState(() {
            recommendationResult = "🌟 Recommended Fertilizer:\n${responseData['Recommended Fertilizer']}";
          });
        } else {
          setState(() {
            recommendationResult = "No specific recommendation available.\nConsult an agricultural expert.";
          });
        }
      } else {
        setState(() {
          recommendationResult = "🌟 Recommended Fertilizer: Urea, NPK-25";
        });
      }
    } catch (e) {
      setState(() {
        recommendationResult = "⚠️ Network error.\nPlease check your connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCropRotationRecommendations() async {
    setState(() {
      isLoading = true;
      recommendationResult = "Analyzing crop rotation patterns...";
    });

    await Future.delayed(500.ms);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      double? soilMoisture = prefs.getDouble('soilMoisture');
      double? nitrogen = prefs.getDouble('nitrogen');
      double? phosphorus = prefs.getDouble('phosphorus');
      double? potassium = prefs.getDouble('potassium');

      if (soilMoisture == null || nitrogen == null || phosphorus == null ||
          potassium == null || selectedSoilType == null || selectedPreviousCrop == null) {
        setState(() {
          recommendationResult = "⚠️ Missing data. Please select previous crop/soil type and update soil health.";
          isLoading = false;
        });
        return;
      }

      Map<String, dynamic> requestBody = {
        "Soil Type": selectedSoilType,
        "Previous Crop": selectedPreviousCrop,
        "Moisture Level": soilMoisture,
        "Nitrogen (N)": nitrogen,
        "Phosphorus (P)": phosphorus,
        "Potassium (K)": potassium,
      };

      final response = await http.post(
        Uri.parse(cropRotationApiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null && responseData['Recommended Crop'] != null) {
          setState(() {
            recommendationResult = "🌱 Recommended Next Crop:\n${responseData['Recommended Crop']}";
          });
        } else {
          setState(() {
            recommendationResult = "No specific recommendation available.\nConsider soil resting period.";
          });
        }
      } else {
        setState(() {
          recommendationResult = "🌱 Recommended Next Crop: Paddy, Groundnut or Onion";
        });
      }
    } catch (e) {
      setState(() {
        recommendationResult = "⚠️ Network error.\nPlease check your connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE1F5FE),
              Color(0xFFB3E5FC),
              Color(0xFF81D4FA),
            ],
          ),
        ),
        child: Column(
          children: [
            // Static Header
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4CAF50),
                    Color(0xFF2E7D32),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco,
                      size: 28,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Smart Farming Advisor",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tab Bar with better background
            Container(
              height: 50,
              color: Color(0xFF37474F), // Dark blue-grey that works well with white icons
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: [
                  Tab(icon: Icon(Icons.grass), text: "Fertilizer"),
                  Tab(icon: Icon(Icons.autorenew), text: "Rotation"),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFertilizerTab(),
                  _buildRotationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFertilizerTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("Soil Analysis"),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDataTile("Temperature", "°C", Icons.thermostat, Colors.redAccent),
                _buildDataTile("Soil Moisture", "%", Icons.water_drop, Colors.blueAccent),
                _buildDataTile("Air Humidity", "%", Icons.cloud, Colors.lightBlue),
                _buildDataTile("Nitrogen", "mg/L", Icons.science, Colors.green),
                _buildDataTile("Phosphorus", "mg/L", Icons.science, Colors.orange),
                _buildDataTile("Potassium", "mg/L", Icons.science, Colors.purple),
              ],
            ),
            SizedBox(height: 24),
            _buildSectionHeader("Crop Details"),
            SizedBox(height: 16),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildGlassDropdown("Soil Type", soilTypes, selectedSoilType, (value) {
                    setState(() => selectedSoilType = value);
                  }, Icons.landscape),
                  SizedBox(height: 16),
                  _buildGlassDropdown("Crop Type", cropTypes, selectedCropType, (value) {
                    setState(() => selectedCropType = value);
                  }, Icons.grass),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildRecommendationButton(
              onPressed: fetchFertilizerRecommendations,
              icon: Icons.eco,
              label: "Analyze & Recommend Fertilizer",
            ),
            SizedBox(height: 16),
            _buildRecommendationResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildRotationTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionHeader("Soil Analysis"),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildDataTile("Soil Moisture", "%", Icons.water_drop, Colors.blueAccent),
                _buildDataTile("Nitrogen", "mg/L", Icons.science, Colors.green),
                _buildDataTile("Phosphorus", "mg/L", Icons.science, Colors.orange),
                _buildDataTile("Potassium", "mg/L", Icons.science, Colors.purple),
              ],
            ),
            SizedBox(height: 24),
            _buildSectionHeader("Rotation Details"),
            SizedBox(height: 16),
            _buildGlassCard(
              child: Column(
                children: [
                  _buildGlassDropdown("Soil Type", soilTypes, selectedSoilType, (value) {
                    setState(() => selectedSoilType = value);
                  }, Icons.landscape),
                  SizedBox(height: 16),
                  _buildGlassDropdown("Previous Crop", previousCrops, selectedPreviousCrop, (value) {
                    setState(() => selectedPreviousCrop = value);
                  }, Icons.history),
                ],
              ),
            ),
            SizedBox(height: 24),
            _buildRecommendationButton(
              onPressed: fetchCropRotationRecommendations,
              icon: Icons.autorenew,
              label: "Analyze & Recommend Next Crop",
            ),
            SizedBox(height: 16),
            _buildRecommendationResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal.shade800,
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
    );
  }

  Widget _buildDataTile(String title, String unit, IconData icon, Color color) {
    return _buildGlassCard(
      width: 150,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Icon(icon, size: 28, color: color),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          "25.5$unit",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).scale();
  }

  Widget _buildGlassCard({required Widget child, double? width}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGlassDropdown(String label, List<String> options, String? value, Function(String?) onChanged, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal.shade800),
          SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration.collapsed(hintText: ''),
              hint: Text("Select $label", style: TextStyle(color: Colors.teal.shade800)),
              dropdownColor: Colors.teal.shade50,
              icon: Icon(Icons.arrow_drop_down, color: Colors.teal.shade800),
              style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w500),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationButton({required VoidCallback onPressed, required IconData icon, required String label}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.teal.shade700,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        shadowColor: Colors.teal.shade200,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().scale(delay: 200.ms);
  }

  Widget _buildRecommendationResult() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isLoading
          ? _buildLoadingIndicator()
          : recommendationResult.isNotEmpty
          ? _buildResultCard()
          : SizedBox.shrink(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.teal.shade700),
            strokeWidth: 6,
          ),
          SizedBox(height: 16),
          Text(
            "Analyzing your farm data...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return _buildGlassCard(
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          children: [
            Icon(
              recommendationResult.startsWith("⚠️") ? Icons.warning :
              recommendationResult.startsWith("🌟") ? Icons.eco : Icons.spa,
              size: 40,
              color: recommendationResult.startsWith("⚠️") ? Colors.orange : Colors.teal.shade700,
            ),
            SizedBox(height: 12),
            Text(
              recommendationResult,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade900,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.5);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color? backgroundColor; // Add this
  _SliverAppBarDelegate(this.tabBar, {this.backgroundColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Color(0xFF2E7D32),
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}