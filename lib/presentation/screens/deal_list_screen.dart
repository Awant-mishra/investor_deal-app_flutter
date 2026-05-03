import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/blocs/deal/deal_bloc.dart';
import '../../business_logic/blocs/deal/deal_event.dart';
import '../../business_logic/blocs/deal/deal_state.dart';
import '../widgets/deal_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/filter_widget.dart';
import '../widgets/search_bar.dart';
import 'my_interest_screen.dart';
import 'login_screen.dart';

class DealListScreen extends StatelessWidget {
  const DealListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Investment Deals"),
        centerTitle: true,
        actions: [
          /// ❤️ Favorites
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyInterestScreen(),
                ),
              );
            },
          ),

          /// 🚪 Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool("isLoggedIn", false);

              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      /// 🔽 Filter Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFilterBottomSheet(context);
        },
        child: const Icon(Icons.filter_list),
      ),

      /// 📱 Body
      body: Column(
        children: [
          const SearchBarWidget(),
          const FilterWidget(),

          Expanded(
            child: BlocBuilder<DealBloc, DealState>(
              builder: (context, state) {
                /// ⏳ Loading
                if (state is DealLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                /// ✅ Loaded
                if (state is DealLoaded) {
                  if (state.filteredDeals.isEmpty) {
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

                  return ListView.builder(
                    itemCount: state.filteredDeals.length,
                    itemBuilder: (context, index) {
                      final deal = state.filteredDeals[index];

                      /// ✨ Animation
                      return TweenAnimationBuilder(
                        duration:
                        Duration(milliseconds: 300 + (index * 50)),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: DealCard(deal: deal),
                      );
                    },
                  );
                }

                /// ❌ Error
                return const Center(
                  child: Text("Something went wrong"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}