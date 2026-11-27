
import 'package:material_ui/material_ui.dart';

class CropDetailsScreen extends StatelessWidget {
  final bool hindi;
  final String cropName;
  final Map<String, dynamic> cropData;

  const CropDetailsScreen({
    super.key,
    required this.hindi,
    required this.cropName,
    required this.cropData,
  });

  Widget detailCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 28),
        title: Text(title),
        subtitle: Text(
          value.isEmpty ? (hindi ? 'उपलब्ध नहीं' : 'Not available') : value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'फसल की जानकारी' : 'Crop Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.agriculture,
              color: Colors.green,
              size: 70,
            ),

            const SizedBox(height: 12),

            Text(
              cropName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            detailCard(
              hindi ? 'फसल का मौसम' : 'Growing Season',
              cropData['season']?.toString() ?? '',
              Icons.calendar_month,
            ),

            detailCard(
              hindi ? 'मिट्टी की आवश्यकता' : 'Soil Requirements',
              cropData['soil']?.toString() ?? '',
              Icons.landscape,
            ),

            detailCard(
              hindi ? 'पानी की आवश्यकता' : 'Water Requirements',
              cropData['water']?.toString() ?? '',
              Icons.water_drop,
            ),

            detailCard(
              hindi ? 'खाद की जानकारी' : 'Fertilizer Information',
              cropData['fertilizer']?.toString() ?? '',
              Icons.grass,
            ),

            detailCard(
              hindi ? 'फसल की अवधि' : 'Growing Duration',
              cropData['duration']?.toString() ?? '',
              Icons.timelapse,
            ),

            detailCard(
              hindi ? 'कटाई की जानकारी' : 'Harvesting Information',
              cropData['harvesting']?.toString() ?? '',
              Icons.agriculture,
            ),
          ],
        ),
      ),
    );
  }
}
