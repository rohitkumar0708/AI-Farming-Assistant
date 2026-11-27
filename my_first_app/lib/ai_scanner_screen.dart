import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AIScannerScreen extends StatefulWidget {
  final bool hindi;

  const AIScannerScreen({
    super.key,
    required this.hindi,
  });

  @override
  State<AIScannerScreen> createState() => _AIScannerScreenState();
}

class _AIScannerScreenState extends State<AIScannerScreen> {
  final ImagePicker picker = ImagePicker();

  Uint8List? imageBytes;

  Future<void> pickImage(ImageSource source) async {
    final image = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        imageBytes = bytes;
      });
    }
  }

  void showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(widget.hindi ? 'कैमरा' : 'Camera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(widget.hindi ? 'गैलरी' : 'Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hindi = widget.hindi;

    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'AI फसल स्कैनर' : 'AI Crop Scanner'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.document_scanner,
              size: 70,
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            Text(
              hindi
                  ? 'फसल की बीमारी पहचानें'
                  : 'Identify Crop Diseases',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hindi
                  ? 'प्रभावित पौधे की साफ फोटो अपलोड करें।'
                  : 'Upload a clear photo of the affected plant.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green),
              ),
              child: imageBytes == null
                  ? const Icon(
                      Icons.add_a_photo,
                      size: 65,
                      color: Colors.green,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: showImageOptions,
              icon: const Icon(Icons.upload),
              label: Text(
                imageBytes == null
                    ? (hindi ? 'फोटो अपलोड करें' : 'Upload Photo')
                    : (hindi ? 'फोटो बदलें' : 'Change Photo'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            if (imageBytes != null) ...[
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  setState(() {
                    imageBytes = null;
                  });
                },
                child: Text(hindi ? 'फोटो हटाएं' : 'Remove Photo'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        hindi
                            ? 'AI बीमारी पहचानने की सुविधा जोड़ना बाकी है।'
                            : 'AI disease detection integration is pending.',
                      ),
                    ),
                  );
                },
                child: Text(
                  hindi ? 'बीमारी पहचानें' : 'Detect Disease',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}