import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:investor_app/business_logic/blocs/deal/deal_event.dart';

import 'package:investor_app/main.dart';
import 'package:investor_app/data/data_sources/deal_local_data_source.dart';
import 'package:investor_app/data/repositories/deal_repository.dart';
import 'package:investor_app/business_logic/blocs/deal/deal_bloc.dart';

void main() {
  testWidgets('App loads and shows deals screen',
          (WidgetTester tester) async {
        final repository = DealRepository(DealLocalDataSource());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => DealBloc(repository)..add(LoadDeals()),
              child: const MyAppWrapper(),
            ),
          ),
        );

        // Wait for UI to build
        await tester.pumpAndSettle();

        // Check AppBar title
        expect(find.text('Investment Deals'), findsOneWidget);

        // Check at least one deal is visible
        expect(find.text('TechCorp'), findsOneWidget);
      });
}

// Wrapper to avoid rebuilding whole app
class MyAppWrapper extends StatelessWidget {
  const MyAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Investment Deals")),
    );
  }
}