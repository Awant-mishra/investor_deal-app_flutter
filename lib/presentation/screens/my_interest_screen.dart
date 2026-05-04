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
  State<MyInterestsScreen> createState() =>
      _MyInterestsScreenState();
}

class _MyInterestsScreenState
    extends State<MyInterestsScreen> {
  List<String> interestIds = [];

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  Future<void> loadInterests() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      interestIds = prefs.getStringList("interests") ?? [];
    });
  }

  Future<void> removeInterest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("interests") ?? [];

    list.remove(id);
    await prefs.setStringList("interests", list);

    setState(() {
      interestIds = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Interests")),

      body: BlocBuilder<DealBloc, DealState>(
        builder: (context, state) {

          if (state is DealLoading) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (state is DealLoaded) {

            final deals = state.allDeals
                .where((d) => interestIds.contains(d.id))
                .toList();

            if (deals.isEmpty) {
              return const Center(
                child: Text("No interests yet"),
              );
            }

            return ListView.builder(
              itemCount: deals.length,
              itemBuilder: (context, index) {
                final deal = deals[index];

                return ListTile(
                  title: Text(deal.companyName),
                  subtitle: Text("₹${deal.investment}"),

                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DealDetailScreen(deal: deal),
                      ),
                    );

                    loadInterests(); // 🔄 refresh
                  },

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () =>
                        removeInterest(deal.id),
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