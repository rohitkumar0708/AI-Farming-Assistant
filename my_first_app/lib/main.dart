import 'package:material_ui/material_ui.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'my_crop_screen.dart';
import 'news_screen.dart';
import 'ai_scanner_screen.dart';
import 'market_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'farmer_questionnaire.dart';
import 'ai_field_analysis.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String language = '';

  void changeLanguage(String value) {
    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Farming',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: language.isEmpty
          ? LanguageScreen(onSelect: changeLanguage)
          : HomeScreen(
              language: language,
              onLanguageChange: () {
                setState(() {
                  language = '';
                });
              },
            ),
    );
  }
}

// LANGUAGE SCREEN

class LanguageScreen extends StatelessWidget {
  final Function(String) onSelect;

  const LanguageScreen({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(
                Icons.agriculture,
                size: 75,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Smart Farming',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Choose your preferred language'),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSelect('en'),
                  child: const Text('English'),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onSelect('hi'),
                  child: const Text('हिंदी'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// HOME SCREEN

class HomeScreen extends StatefulWidget {
  final String language;
  final VoidCallback onLanguageChange;

  const HomeScreen({
    super.key,
    required this.language,
    required this.onLanguageChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  String? selectedCropName;
  Map<String, dynamic>? selectedCropData;
  String currentLocation = '';

  bool get hindi => widget.language == 'hi';
  Map<String, dynamic>? weatherData;
  bool weatherLoading = false;
  String weatherError = '';
  final ImagePicker soilPicker = ImagePicker();

  Uint8List? soilImageBytes;
  bool soilImageLoading = false;

  Future<void> fetchWeather(double latitude, double longitude) async {
  setState(() {
    weatherLoading = true;
    weatherError = '';
  });

  try {
    final uri = Uri.https(
      'api.open-meteo.com',
      '/v1/forecast',
      {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': 'temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        'daily': 'precipitation_probability_max',
        'timezone': 'auto',
        'forecast_days': '1',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (!mounted) return;

      setState(() {
        weatherData = data;
      });
    } else {
      throw Exception('Weather service unavailable');
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      weatherError = hindi
          ? 'मौसम की जानकारी उपलब्ध नहीं है।'
          : 'Weather information unavailable.';
    });
  } finally {
    if (mounted) {
      setState(() {
        weatherLoading = false;
      });
    }
  }
}
Future<void> pickSoilImage(ImageSource source) async {
  try {
    setState(() {
      soilImageLoading = true;
    });

    final XFile? image = await soilPicker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    if (!mounted) return;

    setState(() {
      soilImageBytes = bytes;
    });
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hindi
              ? 'फोटो चुनने में समस्या हुई।'
              : 'Unable to select image.',
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        soilImageLoading = false;
      });
    }
  }
}

void removeSoilImage() {
  setState(() {
    soilImageBytes = null;
  });
}
   void showSoilImageOptions() {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green),
              title: Text(hindi ? 'कैमरा खोलें' : 'Take Photo'),
              onTap: () {
                Navigator.pop(context);
                pickSoilImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: Text(hindi ? 'गैलरी से चुनें' : 'Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickSoilImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      );
    },
  );
}

  final List<IconData> icons = [
    Icons.home,
    Icons.store,
    Icons.camera_alt,
    Icons.newspaper,
    Icons.grass,
  ];

  List<String> get labels => hindi
      ? ['होम', 'बाजार', 'AI स्कैनर', 'समाचार', 'मेरी फसल']
      : ['Home', 'Market', 'AI Scanner', 'News', 'My Crop'];

  // OPEN LOCATION SCREEN

  Future<void> openLocationScreen() async {
  final result = await Navigator.push<String>(
    context,
    MaterialPageRoute(
      builder: (context) => LocationScreen(hindi: hindi),
    ),
  );

  if (!mounted) return;

  if (result != null && result.isNotEmpty) {
    String displayLocation = result;
    String coordinatesText = '';

    if (result.startsWith('GPS:')) {
      coordinatesText = result.replaceFirst('GPS:', '');
    } else if (result.startsWith('MANUAL:')) {
      final parts = result.replaceFirst('MANUAL:', '').split('|');

      if (parts.length == 2) {
        displayLocation = parts[0];
        coordinatesText = parts[1];
      }
    }

    setState(() {
      currentLocation = displayLocation;
      weatherData = null;
    });

    if (coordinatesText.isNotEmpty) {
      final coordinates = coordinatesText.split(',');

      if (coordinates.length == 2) {
        final latitude = double.tryParse(coordinates[0].trim());
        final longitude = double.tryParse(coordinates[1].trim());

        if (latitude != null && longitude != null) {
          await fetchWeather(latitude, longitude);
        }
      }
    }
  }
}

  // HOME SCREEN CONTENT

  Widget buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            hindi ? 'नमस्ते किसान! 🌱' : 'Welcome, Farmer! 🌱',
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            hindi
                ? 'आज अपनी खेती को बेहतर बनाएं।'
                : 'Make smarter farming decisions today.',
          ),

          const SizedBox(height: 20),

          // LOCATION CARD

          Card(
            child: ListTile(
              onTap: openLocationScreen,
              leading: const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              title: Text(
                hindi ? 'आपका स्थान' : 'Your Location',
              ),
              subtitle: Text(
                currentLocation.isEmpty
                    ? (hindi
                        ? 'स्थान सेट करने के लिए टैप करें'
                        : 'Tap to set your location')
                    : currentLocation,
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          const SizedBox(height: 15),

          // WEATHER CARD

          Card(
  color: Colors.green.shade50,
  child: Padding(
    padding: const EdgeInsets.all(18),
    child: weatherLoading
        ? const Center(child: CircularProgressIndicator())
        : weatherError.isNotEmpty
            ? Text(weatherError)
            : weatherData == null
                ? Text(
                    hindi
                        ? 'मौसम देखने के लिए GPS स्थान सेट करें।'
                        : 'Set GPS location to view weather.',
                  )
                : Builder(
                    builder: (context) {
                      final current = weatherData!['current'];
                      final daily = weatherData!['daily'];

                      return Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            hindi ? 'मौसम की जानकारी' : 'Live Weather',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            '${current['temperature_2m']} °C',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${hindi ? 'आर्द्रता' : 'Humidity'}: '
                            '${current['relative_humidity_2m']}%',
                          ),
                          Text(
                            '${hindi ? 'बारिश की संभावना' : 'Rain Probability'}: '
                            '${daily['precipitation_probability_max'][0]}%',
                          ),
                          Text(
                            '${hindi ? 'हवा की गति' : 'Wind Speed'}: '
                            '${current['wind_speed_10m']} km/h',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${hindi ? 'अपडेट' : 'Updated'}: '
                            '${current['time']}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      );
                    },
                  ),
  ),
),
          const SizedBox(height: 25),
          // SOIL PHOTO UPLOAD

Text(
  hindi ? 'मिट्टी की फोटो' : 'Soil Photo Upload',
  style: const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: .stretch,
      children: [
        Text(
          hindi
              ? 'बेहतर फसल सुझाव के लिए मिट्टी की फोटो अपलोड करें।'
              : 'Upload a soil photo for preliminary visual assessment.',
        ),

        const SizedBox(height: 15),

        if (soilImageLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (soilImageBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              soilImageBytes!,
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        else
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.landscape,
              size: 65,
              color: Colors.green,
            ),
          ),

        const SizedBox(height: 15),

        ElevatedButton.icon(
          onPressed: soilImageLoading
              ? null
              : showSoilImageOptions,
          icon: const Icon(Icons.add_a_photo),
          label: Text(
            soilImageBytes == null
                ? (hindi ? 'फोटो अपलोड करें' : 'Upload Soil Photo')
                : (hindi ? 'फोटो बदलें' : 'Change Photo'),
          ),
        ),
if (soilImageBytes != null) ...[
  TextButton.icon(
    onPressed: removeSoilImage,
    icon: const Icon(Icons.delete_outline),
    label: Text(
      hindi ? 'फोटो हटाएं' : 'Remove Photo',
    ),
  ),

  ElevatedButton(
    onPressed: () async {
      final result = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => FarmerQuestionnaire(
            hindi: hindi,
          ),
        ),
      );

      if (!mounted || result == null) return;

      Navigator.push(
        context,
        MaterialPageRoute(
         builder: (context) => AIFieldAnalysisScreen(
           hindi: hindi,
           farmerData: result,
           soilImageBytes: soilImageBytes,
           currentLocation: currentLocation,
           weatherData: weatherData,
          
           onCropSelected: (name, data) {
            setState(() {
             selectedCropName = name;
           selectedCropData = data;
            });
           },
          ),
        ),
      );
    },

    child: Text(
      hindi ? 'आगे बढ़ें' : 'Continue',
    ),
  ),
],
      ],
    ),
  ),
),

const SizedBox(height: 25),

          // CROP RECOMMENDATIONS

          Text(
            hindi
                ? 'आपके लिए Top 5 फसलें'
                : 'Top 5 Crop Recommendations',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.eco,
                color: Colors.green,
                size: 32,
              ),
              title: Text(
                hindi ? 'फसल सुझाव' : 'Crop Suggestions',
              ),
              subtitle: Text(
                hindi
                    ? 'आपकी फसलें यहाँ दिखाई देंगी।'
                    : 'Your recommended crops will appear here.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          const SizedBox(height: 25),

          // FARMING FACTS

          Text(
            hindi ? 'खेती के छोटे तथ्य' : 'Quick Farming Facts',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.lightbulb,
                color: Colors.orange,
              ),
              title: Text(
                hindi
                    ? 'फसल चुनने से पहले मिट्टी और मौसम की जानकारी देखें।'
                    : 'Check soil and weather conditions before choosing a crop.',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOtherSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              icons[selectedIndex],
              size: 65,
              color: Colors.green,
            ),
            const SizedBox(height: 15),
            Text(
              labels[selectedIndex],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hindi
                  ? 'यह सेक्शन अगले चरण में तैयार किया जाएगा।'
                  : 'This section will be developed in the next steps.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Farming 🌱',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: widget.onLanguageChange,
            icon: const Icon(Icons.language),
          ),
        ],
      ),

    body: selectedIndex == 0
    ? buildHome()
    : selectedIndex == 1
        ? MarketScreen(hindi: hindi)
        : selectedIndex == 2
            ? AIScannerScreen(hindi: hindi)
            : selectedIndex == 3
                ? NewsScreen(hindi: hindi)
                : MyCropScreen(
                    hindi: hindi,
                    cropName: selectedCropName,
                    cropData: selectedCropData,
                   ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: List.generate(
          5,
          (index) => BottomNavigationBarItem(
            icon: Icon(icons[index]),
            label: labels[index],
          ),
        ),
      ),
    );
  }
}

// LOCATION SCREEN

class LocationScreen extends StatefulWidget {
  final bool hindi;

  const LocationScreen({
    super.key,
    required this.hindi,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final villageController = TextEditingController();

  bool loading = false;

  bool get hindi => widget.hindi;

  // GPS LOCATION

  Future<void> getCurrentLocation() async {
    setState(() {
      loading = true;
    });

    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          hindi
              ? 'कृपया फोन की Location/GPS चालू करें।'
              : 'Please enable GPS on your device.',
        );
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          hindi
              ? 'Location permission नहीं मिली।'
              : 'Location permission denied.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          hindi
              ? 'App Settings में Location permission चालू करें।'
              : 'Enable location permission in App Settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        'GPS: ${position.latitude.toStringAsFixed(4)}, '
        '${position.longitude.toStringAsFixed(4)}',
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // MANUAL LOCATION

  Future<void> saveManualLocation() async {
  final state = stateController.text.trim();
  final district = districtController.text.trim();
  final village = villageController.text.trim();

  if (state.isEmpty || district.isEmpty || village.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hindi
              ? 'कृपया सभी जानकारी भरें।'
              : 'Please fill all location fields.',
        ),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    final uri = Uri.https(
      'geocoding-api.open-meteo.com',
      '/v1/search',
      {
        'name': village,
        'count': '10',
        'language': 'en',
        'format': 'json',
      },
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Location search failed');
    }

    final data = jsonDecode(response.body);
    final results = data['results'] as List?;

    if (results == null || results.isEmpty) {
      throw Exception('Location not found');
    }

     final matches = results.where((item) {
     final country = item['country_code']?.toString() ?? '';
     final apiState = item['admin1']?.toString().toLowerCase() ?? '';

      return country == 'IN' &&
      apiState.contains(state.toLowerCase());
     }).toList();

    if (matches.isEmpty) {
      throw Exception('Matching location not found');
    }

    final latitude = matches.first['latitude'];
    final longitude = matches.first['longitude'];

    if (latitude == null || longitude == null) {
      throw Exception('Coordinates unavailable');
    }

    if (!mounted) return;

    Navigator.pop(
      context,
      'MANUAL:$village, $district, $state|$latitude,$longitude',
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hindi
              ? 'स्थान नहीं मिला। कृपया जानकारी जाँचें।'
              : 'Location not found. Please check your details.',
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}

  @override
  void dispose() {
    stateController.dispose();
    districtController.dispose();
    villageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hindi ? 'अपना स्थान चुनें' : 'Select Your Location',
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Icon(
              Icons.location_on,
              size: 65,
              color: Colors.green,
            ),

            const SizedBox(height: 15),

            Text(
              hindi
                  ? 'अपना स्थान सेट करें'
                  : 'Set Your Location',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // GPS BUTTON

            ElevatedButton.icon(
              onPressed: loading ? null : getCurrentLocation,
              icon: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
              label: Text(
                loading
                    ? (hindi ? 'स्थान खोज रहे हैं...' : 'Getting location...')
                    : (hindi
                        ? 'वर्तमान स्थान का उपयोग करें'
                        : 'Use Current Location'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 25),

            const Divider(),

            const SizedBox(height: 15),

            Text(
              hindi
                  ? 'या स्थान मैन्युअली दर्ज करें'
                  : 'Or Enter Location Manually',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: stateController,
              decoration: InputDecoration(
                labelText: hindi ? 'राज्य' : 'State',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.map),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: districtController,
              decoration: InputDecoration(
                labelText: hindi ? 'जिला' : 'District',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_city),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: villageController,
              decoration: InputDecoration(
                labelText: hindi ? 'गाँव / शहर' : 'Village / City',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.home),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveManualLocation,
              child: Text(
                hindi ? 'स्थान सेव करें' : 'Save Location',
              ),
            ),
          ],
        ),
      ),
    );
  }
}