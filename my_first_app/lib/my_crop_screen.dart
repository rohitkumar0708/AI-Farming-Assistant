import 'package:material_ui/material_ui.dart';

class MyCropScreen extends StatelessWidget {
  final bool hindi;
  final String? cropName;
  final Map<String, dynamic>? cropData;

  const MyCropScreen({
    super.key,
    required this.hindi,
    this.cropName,
    this.cropData,
  });

  @override
  Widget build(BuildContext context) {
    final hasCrop = cropName != null && cropData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'मेरी फसल' : 'My Crop'),
      ),
      body: hasCrop
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Icon(
                  Icons.agriculture,
                  size: 75,
                  color: Colors.green,
                ),
                const SizedBox(height: 15),
                Text(
                  cropName!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _info('Season', 'season'),
                _info('Soil', 'soil'),
                _info('Water', 'water'),
                _info('Fertilizer', 'fertilizer'),
                _info('Duration', 'duration'),
                _info('Harvesting', 'harvesting'),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.agriculture,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    hindi
                        ? 'अभी कोई फसल चुनी नहीं गई'
                        : 'No Crop Selected Yet',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hindi
                        ? 'AI Recommendations से फसल चुनें।'
                        : 'Select a crop from AI Recommendations.',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _info(String title, String key) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          cropData?[key]?.toString() ?? 'Not available',
        ),
      ),
    );
  }
}