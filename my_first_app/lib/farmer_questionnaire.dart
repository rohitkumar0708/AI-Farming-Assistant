
import 'package:material_ui/material_ui.dart';

class FarmerQuestionnaire extends StatefulWidget {
  final bool hindi;

  const FarmerQuestionnaire({
    super.key,
    required this.hindi,
  });

  @override
  State<FarmerQuestionnaire> createState() =>
      _FarmerQuestionnaireState();
}

class _FarmerQuestionnaireState
    extends State<FarmerQuestionnaire> {
  String? previousCrop;
  String? cropDuration;
  String? irrigationType;

  final landController = TextEditingController();
  final budgetController = TextEditingController();

  bool get hindi => widget.hindi;

  final List<String> crops = [
    'Wheat',
    'Rice',
    'Potato',
    'Mustard',
    'Maize',
    'Sugarcane',
    'Other',
  ];

  final List<String> durations = [
    '2-3 months',
    '3-6 months',
    '6+ months',
  ];

  final List<String> irrigationOptions = [
    'Rainfed',
    'Canal',
    'Borewell',
    'Drip Irrigation',
    'Other',
  ];

  @override
  void dispose() {
    landController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  Widget buildDropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void continueQuestionnaire() {
    Navigator.pop(context, {
      'previousCrop': previousCrop,
      'cropDuration': cropDuration,
      'irrigationType': irrigationType,
      'landArea': landController.text.trim(),
      'budget': budgetController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hindi ? 'किसान की जानकारी' : 'Farmer Information',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                  ? 'अपनी खेती के बारे में बताएं'
                  : 'Tell us about your farming',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hindi
                  ? 'सभी जानकारी वैकल्पिक है।'
                  : 'All information is optional.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            buildDropdown(
              hindi ? 'पिछली फसल' : 'Previous Crop',
              previousCrop,
              crops,
              (value) {
                setState(() => previousCrop = value);
              },
            ),

            const SizedBox(height: 18),

            buildDropdown(
              hindi ? 'फसल की अवधि' : 'Crop Duration',
              cropDuration,
              durations,
              (value) {
                setState(() => cropDuration = value);
              },
            ),

            const SizedBox(height: 18),

            buildDropdown(
              hindi ? 'सिंचाई का प्रकार' : 'Irrigation Type',
              irrigationType,
              irrigationOptions,
              (value) {
                setState(() => irrigationType = value);
              },
            ),

            const SizedBox(height: 18),

            TextField(
              controller: landController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: hindi
                    ? 'खेत का क्षेत्रफल (एकड़)'
                    : 'Land Area (Acres)',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: hindi
                    ? 'खेती का बजट (₹)'
                    : 'Farming Budget (₹)',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: continueQuestionnaire,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: Text(
                hindi ? 'आगे बढ़ें' : 'Continue',
              ),
            ),

            TextButton(
              onPressed: continueQuestionnaire,
              child: Text(
                hindi ? 'अभी छोड़ें' : 'Skip for Now',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
