import 'package:flutter/material.dart';

class IrrigationManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Irrigation Management'),
        backgroundColor: Colors.blue, // Change color as needed
      ),
      body: SingleChildScrollView(  // Added SingleChildScrollView for scrolling
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Soil Nutrients (NPK)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildNutrientCard('Nitrogen (N)', '45 kg/ha', Colors.green),
            _buildNutrientCard('Phosphorus (P)', '30 kg/ha', Colors.orange),
            _buildNutrientCard('Potassium (K)', '25 kg/ha', Colors.red),
            SizedBox(height: 40),
            Text(
              'Irrigation Requirements for Next Week',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildWaterRequirementCard('Total Water Needed', '500 Liters', Colors.blue),
            _buildWaterRequirementCard('Irrigation Frequency', '3 times', Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String nutrient, String amount, Color color) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nutrient,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              amount,
              style: TextStyle(fontSize: 20, color: color),
            ),
          ],
        ),
      ),
    );
}

  Widget _buildWaterRequirementCard(String requirement, String amount, Color color) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              requirement,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              amount,
              style: TextStyle(fontSize: 20, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
