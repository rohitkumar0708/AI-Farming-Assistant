import 'package:material_ui/material_ui.dart';
import 'crop_recommendations.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'package:http/http.dart' as http;

const String apiUrl =
    'https://ai-farming-assistant-n3s7.onrender.com/analyze';

class AIFieldAnalysisScreen extends StatelessWidget {
  final bool hindi;
  final Function(String, Map<String, dynamic>) onCropSelected;
  final Map<String, dynamic> farmerData;
  final Uint8List? soilImageBytes;
  final String currentLocation;
  final Map<String, dynamic>? weatherData;

  const AIFieldAnalysisScreen({
    super.key,
    required this.onCropSelected,
    required this.hindi,
    required this.farmerData,
    this.soilImageBytes,
    this.currentLocation = '',
    this.weatherData,
  });
  Widget infoCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 28),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? 'Not Provided' : value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> analyzeField(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
           body: jsonEncode({
              'language': hindi ? 'Hindi' : 'English',
              'farmerData': farmerData,
              'currentLocation': currentLocation,
              'weatherData': weatherData,

              'soilImage': soilImageBytes != null
              ? base64Encode(soilImageBytes!)
              : null,

              'soilImageMimeType': 'image/jpeg',
          }),
      );
        print("API STATUS: ${response.statusCode}");
        print("API RESPONSE: ${response.body}");
        print("API URL: $apiUrl");
      if (!context.mounted) return;
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
           final List<Map<String, dynamic>> crops =
            (result['crops'] as List)
              .map((crop) => Map<String, dynamic>.from(crop))
              .toList();

              Navigator.push(
              context,
              MaterialPageRoute(
             builder: (context) => CropRecommendationsScreen(
             hindi: hindi,
             crops: crops,
             onCropSelected: onCropSelected,
           ),
              
         ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'AI analysis failed')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Connection error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'खेत का विश्लेषण' : 'AI Field Analysis'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.analytics, size: 75, color: Colors.green),

            const SizedBox(height: 15),

            Text(
              hindi ? 'आपके खेत की जानकारी' : 'Your Field Information',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              hindi
                  ? 'आपके द्वारा दी गई जानकारी का विवरण'
                  : 'Details based on your submitted information',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            infoCard(
              hindi ? 'पिछली फसल' : 'Previous Crop',
              farmerData['previousCrop']?.toString() ?? '',
              Icons.grass,
            ),
            // Soil Photo Preview
            if (soilImageBytes != null) ...[
              Text(
                hindi ? 'मिट्टी की फोटो' : 'Soil Photo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  soilImageBytes!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 15),
            ],

            // Location Details
            infoCard(
              hindi ? 'खेत का स्थान' : 'Field Location',
              currentLocation,
              Icons.location_on,
            ),

            const SizedBox(height: 10),
            // Weather Details
            if (weatherData != null) ...[
              const SizedBox(height: 15),

              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(
                    builder: (context) {
                      final current = weatherData!['current'];
                      final daily = weatherData!['daily'];

                      final rain = daily?['precipitation_probability_max'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hindi ? 'मौसम की जानकारी' : 'Weather Details',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            '🌡️ Temperature: ${current?['temperature_2m'] ?? '--'} °C',
                          ),

                          Text(
                            '💧 Humidity: ${current?['relative_humidity_2m'] ?? '--'}%',
                          ),

                          Text(
                            '🌧️ Rain Probability: '
                            '${rain is List && rain.isNotEmpty ? rain[0] : '--'}%',
                          ),

                          Text(
                            '💨 Wind Speed: ${current?['wind_speed_10m'] ?? '--'} km/h',
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],

            infoCard(
              hindi ? 'फसल की अवधि' : 'Crop Duration',
              farmerData['cropDuration']?.toString() ?? '',
              Icons.calendar_month,
            ),

            infoCard(
              hindi ? 'सिंचाई का प्रकार' : 'Irrigation Type',
              farmerData['irrigationType']?.toString() ?? '',
              Icons.water_drop,
            ),

            infoCard(
              hindi ? 'खेत का क्षेत्रफल' : 'Land Area',
              farmerData['landArea']?.toString() ?? '',
              Icons.landscape,
            ),

            infoCard(
              hindi ? 'खेती का बजट' : 'Farming Budget',
              farmerData['budget']?.toString() ?? '',
              Icons.currency_rupee,
            ),

            const SizedBox(height: 25),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    const Icon(Icons.smart_toy, color: Colors.green, size: 40),

                    const SizedBox(height: 10),

                    Text(
                      hindi ? 'AI विश्लेषण' : 'AI Analysis',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      hindi
                          ? 'आपके खेत और मिट्टी की जानकारी के आधार पर फसल का सुझाव तैयार किया जाएगा।'
                          : 'Crop recommendations will be generated based on your field and soil information.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: () {
                        analyzeField(context);
                      },

                      icon: const Icon(Icons.auto_awesome),

                      label: Text(
                        hindi ? 'विश्लेषण शुरू करें' : 'Start AI Analysis',
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
