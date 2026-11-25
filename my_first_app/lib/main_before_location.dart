import 'package:material_ui/material_ui.dart';

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
              const Text(
                'Choose your preferred language',
                style: TextStyle(fontSize: 16),
              ),
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

  bool get hindi => widget.language == 'hi';

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

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 30,
              ),
              title: Text(hindi ? 'आपका स्थान' : 'Your Location'),
              subtitle: Text(
                hindi
                    ? 'स्थान अभी सेट नहीं किया गया'
                    : 'Location not set yet',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          const SizedBox(height: 15),

          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(
                    Icons.cloud_outlined,
                    size: 45,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          hindi ? 'मौसम की जानकारी' : 'Weather Update',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          hindi
                              ? 'मौसम डेटा जल्द उपलब्ध होगा'
                              : 'Weather data will appear here',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          Text(
            hindi ? 'आपके लिए Top 5 फसलें' : 'Top 5 Crop Recommendations',
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
              title: Text(hindi ? 'फसल सुझाव' : 'Crop Suggestions'),
              subtitle: Text(
                hindi
                    ? 'आपकी फसलें यहाँ दिखाई देंगी।'
                    : 'Your recommended crops will appear here.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ),

          const SizedBox(height: 25),

          Text(
            hindi ? 'खेती के छोटे तथ्य' : 'Quick Farming Facts',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.orange),
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
            Icon(icons[selectedIndex], size: 65, color: Colors.green),
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
            tooltip: hindi ? 'भाषा बदलें' : 'Change language',
            onPressed: widget.onLanguageChange,
            icon: const Icon(Icons.language),
          ),
        ],
      ),

      body: selectedIndex == 0 ? buildHome() : buildOtherSection(),

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