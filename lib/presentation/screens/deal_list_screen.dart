import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/blocs/deal/deal_bloc.dart';
import '../../business_logic/blocs/deal/deal_state.dart';
import '../../data/models/deal_model.dart';
import '../widgets/deal_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/deal_skeleton.dart';
import 'login_screen.dart';
import 'my_interest_screen.dart';

class DealListScreen extends StatelessWidget {
  const DealListScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  ///  FIXED: Proper Bloc passing to bottom sheet
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: context.read<DealBloc>(),
          child: const FilterBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      ///  APPBAR
      appBar: AppBar(
        title: const Text(""),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<DealBloc>(),
                    child: const MyInterestsScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => logout(context),
          ),
        ],
      ),
      ///  FLOATING FILTER BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFilterBottomSheet(context),
        child: const Icon(Icons.filter_list),
      ),

      ///  BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///  HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Image.asset("assets/logo.png", height: 40),
                const SizedBox(width: 10),
                const Text(
                  "Welcome Ankit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ///  LIST AREA
          Expanded(
            child: BlocBuilder<DealBloc, DealState>(
              builder: (context, state) {

                ///  LOADING
                if (state is DealLoading) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, _) => const DealSkeleton(),
                  );
                }

                ///  ERROR
                if (state is DealError) {
                  return Center(child: Text(state.message));
                }

                ///  LOADED
                if (state is DealLoaded) {
                  final List<Deal> deals = state.filteredDeals;

                  ///  EMPTY STATE
                  if (deals.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 60, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("No deals found"),
                        ],
                      ),
                    );
                  }

                  ///  LIST
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final deal = deals[index];

                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 300 + (index * 80)),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 30 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: DealCard(deal: deal),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}