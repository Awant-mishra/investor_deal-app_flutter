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

class _DealDetailScreenState extends State<DealDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveInterest() async {
    setState(() => isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    if (!list.contains(widget.deal.id)) {
      list.add(widget.deal.id);
      await prefs.setStringList("interests", list);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to interests")),
        );
      }
    }

    setState(() => isSaving = false);
  }

  String getRiskDescription(String risk) {
    switch (risk.toLowerCase()) {
      case "high":
        return "High risk investments may offer higher returns but involve volatility.";
      case "medium":
        return "Balanced risk and growth potential.";
      case "low":
        return "Stable and low volatility investment.";
      default:
        return "Risk information not available.";
    }
  }

  Widget glassCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: child,
    );
  }

  Widget highlight(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      /// 🌈 APP BAR
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A2540), Color(0xFF2A76C8)],
            ),
          ),
        ),
        title: Text(deal.companyName),
      ),

      /// 📄 BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            Text(
              deal.companyName,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 SUMMARY
            glassCard(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  highlight("Investment", "₹${deal.investment}"),
                  highlight("ROI", "${deal.roi}%"),
                  highlight("Risk", deal.risk),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 📈 CHART
            glassCard(
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C896), Color(0xFF0A2540)],
                        ),
                        barWidth: 4,
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
            ),

            const SizedBox(height: 20),

            /// 🧾 DESCRIPTION
            glassCard(
              Text(
                deal.description ??
                    "This opportunity shows steady growth with balanced risk.",
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            /// ❤️ BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF2A76C8),
                ),
                onPressed: isSaving ? null : saveInterest,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("I'm Interested"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}