import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/deal_model.dart';

class DealDetailScreen extends StatelessWidget {
  final Deal deal;

  const DealDetailScreen({super.key, required this.deal});

  Future<void> saveInterest(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    if (!list.contains(deal.id)) {
      list.add(deal.id);
      await prefs.setStringList("interests", list);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to interests")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Already added")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: deal.id,
          child: Material(
            color: Colors.transparent,
            child: Text(
              deal.companyName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HERO TITLE (MAIN)
            Hero(
              tag: deal.id,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  deal.companyName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 INFO ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ROI: ${deal.roi}%",
                    style: const TextStyle(fontSize: 16)),
                Text("Risk: ${deal.risk}",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 20),

            /// 📈 CHART
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, deal.roi - 5),
                        FlSpot(1, deal.roi - 2),
                        FlSpot(2, deal.roi),
                        FlSpot(3, deal.roi + 2),
                      ],
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🧾 DESCRIPTION
            const Text(
              "This investment opportunity shows consistent growth with a balanced risk profile. Suitable for medium to long-term investors.",
              style: TextStyle(color: Colors.grey),
            ),

            const Spacer(),

            /// ❤️ BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => saveInterest(context),
                child: const Text("I'm Interested"),
              ),
            )
          ],
        ),
      ),
    );
  }
}