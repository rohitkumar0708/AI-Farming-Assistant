import 'package:material_ui/material_ui.dart';

class MarketScreen extends StatelessWidget {
  final bool hindi;

  const MarketScreen({
    super.key,
    required this.hindi,
  });

  Widget marketCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unavailable = hindi
        ? 'डेटा कनेक्शन जल्द उपलब्ध होगा'
        : 'Data connection coming soon';

    return Scaffold(
      appBar: AppBar(
        title: Text(hindi ? 'कृषि बाजार' : 'Agriculture Market'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              hindi
                  ? 'फसल बाजार की जानकारी'
                  : 'Crop Market Information',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              hindi
                  ? 'भारत और अंतरराष्ट्रीय बाजार की जानकारी'
                  : 'Indian and international market updates',
            ),

            const SizedBox(height: 20),

            marketCard(
              icon: Icons.store,
              title: hindi ? 'भारतीय मंडी भाव' : 'Indian Mandi Prices',
              subtitle: unavailable,
            ),

            marketCard(
              icon: Icons.public,
              title: hindi ? 'ग्लोबल फसल भाव' : 'Global Crop Prices',
              subtitle: unavailable,
            ),

            marketCard(
              icon: Icons.trending_up,
              title: hindi ? 'निर्यात की मांग' : 'Export Demand',
              subtitle: unavailable,
            ),

            marketCard(
              icon: Icons.account_balance,
              title: hindi ? 'न्यूनतम समर्थन मूल्य (MSP)' : 'Minimum Support Price (MSP)',
              subtitle: unavailable,
            ),

            marketCard(
              icon: Icons.show_chart,
              title: hindi ? 'बाजार का रुझान' : 'Market Trends',
              subtitle: unavailable,
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hindi
                            ? 'बाजार भाव और MSP की जानकारी आधिकारिक स्रोतों से जोड़ी जाएगी।'
                            : 'Market prices and MSP information will be connected to official sources.',
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