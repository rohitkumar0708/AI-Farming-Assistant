import 'package:material_ui/material_ui.dart';

class NewsScreen extends StatelessWidget {
  final bool hindi;

  const NewsScreen({
    super.key,
    required this.hindi,
  });

  Widget newsCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final message = hindi
        ? 'ताजा खबरें जल्द ही उपलब्ध होंगी।'
        : 'Latest news will be available soon.';

    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'कृषि समाचार' : 'Agriculture News'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hindi ? 'कृषि जगत की खबरें' : 'Agriculture Updates',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hindi
                  ? 'भारत और दुनिया की कृषि से जुड़ी खबरें।'
                  : 'Agriculture news from India and around the world.',
            ),

            const SizedBox(height: 20),

            newsCard(
              icon: Icons.flag,
              title: hindi ? 'राष्ट्रीय समाचार' : 'National News',
              subtitle: message,
            ),

            newsCard(
              icon: Icons.public,
              title: hindi ? 'अंतरराष्ट्रीय समाचार' : 'International News',
              subtitle: message,
            ),

            newsCard(
              icon: Icons.agriculture,
              title: hindi ? 'किसानों के लिए सरकारी अपडेट' : 'Government Updates',
              subtitle: message,
            ),

            newsCard(
              icon: Icons.currency_rupee,
              title: hindi ? 'कृषि बाजार अपडेट' : 'Agriculture Market Updates',
              subtitle: message,
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  hindi
                      ? 'खबरों के साथ उनका स्रोत और प्रकाशित होने की तारीख भी दिखाई जाएगी।'
                      : 'Every news item will include its source and publication date.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}