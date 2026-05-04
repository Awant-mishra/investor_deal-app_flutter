import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/blocs/deal/deal_bloc.dart';
import '../../business_logic/blocs/deal/deal_state.dart';
import '../../data/models/deal_model.dart';
import 'deal_detail_screen.dart';

class MyInterestsScreen extends StatefulWidget {
  const MyInterestsScreen({super.key});

  @override
  State<MyInterestsScreen> createState() => _MyInterestsScreenState();
}

class _MyInterestsScreenState extends State<MyInterestsScreen> {
  List<String> interestIds = [];

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  /// 📥 Load saved interests
  Future<void> loadInterests() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      interestIds = prefs.getStringList("interests") ?? [];
    });
  }

  /// ❌ Remove interest
  Future<void> removeInterest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    list.remove(id);
    await prefs.setStringList("interests", list);

    setState(() {
      interestIds = list;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Removed from interests")),
    );
  }

  /// ⚠️ Confirm dialog
  void showRemoveDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text("Remove Interest"),
        content: const Text(
          "Are you sure you want to remove this deal?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              removeInterest(id);
            },
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Interests"),
      ),
      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {
          /// 🔄 Loading
          if (state is DealLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ Error
          if (state is DealError) {
            return Center(child: Text(state.message));
          }

          /// ✅ Loaded
          if (state is DealLoaded) {
            /// 🔍 Match saved IDs with full deals
            final List<Deal> deals = state.allDeals
                .where((deal) => interestIds.contains(deal.id))
                .toList();

            /// 📭 Empty state
            if (deals.isEmpty) {
              return const Center(
                child: Text("No interests yet"),
              );
            }

            /// 📋 List
            return ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      deal.companyName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "₹${deal.investment} • ${deal.roi}% • ${deal.risk}",
                    ),

                    /// 👉 Open detail
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DealDetailScreen(deal: deal),
                        ),
                      );
                    },

                    /// ❌ Remove with confirmation
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => showRemoveDialog(deal.id),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}