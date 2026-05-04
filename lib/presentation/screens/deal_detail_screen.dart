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

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> saveInterest() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    if (!list.contains(widget.deal.id)) {
      list.add(widget.deal.id);
      await prefs.setStringList("interests", list);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to interests")),
      );
    }
  }

  String getRiskDescription(String risk) {
    switch (risk) {
      case "High":
        return "High risk investments may offer higher returns but involve volatility.";
      case "Medium":
        return "Balanced risk and growth potential.";
      default:
        return "Stable and low volatility investment.";
    }
  }

  Widget fadeSlide({required Widget child, int delay = 0}) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
    );
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
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A2540),
        title: Text(deal.companyName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HERO TITLE
            fadeSlide(
              child: Hero(
                tag: deal.id,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    deal.companyName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 FINANCIAL HIGHLIGHTS
            fadeSlide(
              delay: 100,
              child: glassCard(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    highlight("Investment", "₹${deal.investment}"),
                    highlight("ROI", "${deal.roi}%"),
                    highlight("Risk", deal.risk),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📈 CHART
            fadeSlide(
              delay: 200,
              child: glassCard(
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
            ),

            const SizedBox(height: 20),

            /// 🧾 OVERVIEW
            fadeSlide(
              delay: 300,
              child: glassCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Company Overview",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      deal.description ??
                          "This opportunity shows steady growth with a balanced risk-return profile.",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ⚠️ RISK
            fadeSlide(
              delay: 400,
              child: glassCard(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Risk Explanation",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      getRiskDescription(deal.risk),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ❤️ BUTTON
            fadeSlide(
              delay: 500,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF0A2540),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: saveInterest,
                  child: const Text(
                    "I'm Interested",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}