import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/deal_model.dart';
import '../screens/deal_detail_screen.dart';

class DealCard extends StatelessWidget {
  final Deal deal;

  const DealCard({super.key, required this.deal});

  Color getRiskColor() {
    switch (deal.risk) {
      case "High":
        return AppColors.highRisk;
      case "Medium":
        return AppColors.mediumRisk;
      default:
        return AppColors.lowRisk;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DealDetailScreen(deal: deal),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔥 HERO ADDED HERE
              Hero(
                tag: deal.id,
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    deal.companyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                deal.industry,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("₹${deal.investment}"),
                  Text("${deal.roi}% ROI"),
                ],
              ),

              const SizedBox(height: 10),

              Chip(
                label: Text(deal.risk),
                backgroundColor: getRiskColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}