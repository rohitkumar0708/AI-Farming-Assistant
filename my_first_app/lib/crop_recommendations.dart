import 'package:material_ui/material_ui.dart';
import 'crop_details.dart';

class CropRecommendationsScreen extends StatelessWidget {
  
  final bool hindi;
  final List<Map<String, dynamic>> crops;
  final Function(String, Map<String, dynamic>) onCropSelected;
  


  const CropRecommendationsScreen({
    super.key,
    required this.hindi,
    required this.crops,
    required this.onCropSelected,
   
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hindi ? 'फसल की सिफारिशें' : 'Crop Recommendations',
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.agriculture,
              size: 65,
              color: Colors.green,
            ),
            const SizedBox(height: 15),
            Text(
              hindi
                  ? 'आपके खेत के लिए AI सुझाव'
                  : 'AI Recommendations for Your Farm',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            ...crops.asMap().entries.map((entry) {
              final index = entry.key;
              final crop = entry.value;

              final name = crop['name']?.toString() ?? 'Crop';
              final reason = crop['reason']?.toString() ?? '';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(reason),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    onCropSelected(name, crop);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailsScreen(
                          hindi: hindi,
                          cropName: name,
                          cropData: crop,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(hindi ? 'वापस जाएं' : 'Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}