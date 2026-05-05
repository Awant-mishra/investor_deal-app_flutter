import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:investor_app/data/data_sources/deal_local_data_source.dart';
import 'package:investor_app/data/repositories/deal_repository.dart';
import 'package:investor_app/business_logic/blocs/deal/deal_bloc.dart';
import 'package:investor_app/business_logic/blocs/deal/deal_event.dart';
import 'package:investor_app/presentation/screens/deal_list_screen.dart';
import 'package:investor_deal_app/business_logic/blocs/deal/deal_bloc.dart';
import 'package:investor_deal_app/business_logic/blocs/deal/deal_event.dart';
import 'package:investor_deal_app/data/data_sources/deal_local_data_source.dart';
import 'package:investor_deal_app/data/repositories/deal_repository.dart';
import 'package:investor_deal_app/presentation/screens/deal_list_screen.dart';

void main() {
  testWidgets('Deal list loads and displays data',
          (WidgetTester tester) async {
        final repository = DealRepository(DealLocalDataSource());

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => DealBloc(repository)..add(LoadDeals()),
              child: const DealListScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Investor Deals'), findsOneWidget);

        expect(find.text('TechCorp'), findsOneWidget);
      });
}