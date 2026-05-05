import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/deal_model.dart';

class DealDetailScreen extends StatefulWidget {
  final Deal deal;

  const DealDetailScreen({super.key, required this.deal});

  @override
  State<DealDetailScreen> createState() => _DealDetailScreenState();
}

class _DealDetailScreenState extends State<DealDetailScreen> {
  bool isSaving = false;
  bool isInterested = false;

  @override
  void initState() {
    super.initState();
    loadInterestStatus();
  }

  Future<void> loadInterestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    if (!mounted) return;

    setState(() {
      isInterested = list.contains(widget.deal.id);
    });
  }

  Future<void> toggleInterest() async {
    setState(() => isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    if (list.contains(widget.deal.id)) {
      list.remove(widget.deal.id);
    } else {
      list.add(widget.deal.id);
    }

    await prefs.setStringList("interests", list);

    setState(() {
      isInterested = !isInterested;
      isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isInterested
              ? "Added to interests ❤️"
              : "Removed from interests",
        ),
      ),
    );
  }

  String getRiskDescription(String risk) {
    switch (risk.toLowerCase()) {
      case "high":
        return "High risk investments may deliver higher returns but are volatile.";
      case "medium":
        return "Moderate risk with balanced returns and stability.";
      case "low":
        return "Low risk with stable but smaller returns.";
      default:
        return "No risk data available.";
    }
  }

  Widget sectionCard(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(deal.companyName),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ///  COMPANY OVERVIEW
            sectionCard(
              "Company Overview",
              Text(
                "${deal.companyName} operates in the ${deal.industry} sector. "
                    "This opportunity allows investors to participate in growth with a projected ROI of ${deal.roi}%.",
              ),
            ),

            /// FINANCIAL HIGHLIGHTS
            sectionCard(
              "Financial Highlights",
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text("Investment"),
                      Text("₹${deal.investment}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("ROI"),
                      Text("${deal.roi}%",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Risk"),
                      Text(deal.risk,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            ///  ROI GRAPH
            sectionCard(
              "ROI Projection",
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        barWidth: 3,
                        spots: [
                          FlSpot(0, (deal.roi - 5).clamp(0, 100)),
                          FlSpot(1, deal.roi),
                          FlSpot(2, (deal.roi + 3).clamp(0, 100)),
                          FlSpot(3, (deal.roi + 5).clamp(0, 100)),
                        ],
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ///  RISK EXPLANATION
            sectionCard(
              "Risk Explanation",
              Text(getRiskDescription(deal.risk)),
            ),

            const SizedBox(height: 20),

            ///  INTEREST BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : toggleInterest,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isInterested ? Colors.red : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: isInterested
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                label: Text(
                  isInterested
                      ? "Interested"
                      : "I'm Interested",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}