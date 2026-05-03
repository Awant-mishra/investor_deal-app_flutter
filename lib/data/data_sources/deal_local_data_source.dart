import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/deal_model.dart';

class DealLocalDataSource {
  Future<List<Deal>> getDeals() async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Load JSON file
      final String jsonString =
      await rootBundle.loadString('assets/deals.json');

      // Decode JSON
      final List<dynamic> jsonList = json.decode(jsonString);

      // Convert to List<Deal>
      return jsonList.map((json) => Deal.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Error loading deals: $e");
    }
  }
}