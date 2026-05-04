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
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    prefs = await SharedPreferences.getInstance();
    loadInterests();
  }

  void loadInterests() {
    setState(() {
      interestIds = prefs?.getStringList("interests") ?? [];
    });
  }

  Future<void> removeInterest(String id) async {
    List<String> list = prefs?.getStringList("interests") ?? [];

    list.remove(id);
    await prefs?.setStringList("interests", list);

    setState(() {
      interestIds = list;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from interests")),
      );
    }
  }

  void showRemoveDialog(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Remove Interest"),
        content: const Text("Are you sure?"),
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

          if (state is DealLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DealError) {
            return Center(child: Text(state.message));
          }

          if (state is DealLoaded) {

            final deals = state.filteredDeals
                .where((deal) => interestIds.contains(deal.id))
                .toList();

            if (deals.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 60, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      "No interests yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];

                return Card(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(
                      deal.companyName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "₹${deal.investment} • ${deal.roi}% • ${deal.risk}",
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DealDetailScreen(deal: deal),
                        ),
                      );
                    },

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