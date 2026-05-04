import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';

// ✅ IMPORTS
import 'business_logic/blocs/deal/deal_bloc.dart';
import 'business_logic/blocs/deal/deal_event.dart';
import 'data/repositories/deal_repository.dart';
import 'data/data_sources/deal_local_data_source.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DealBloc(
            DealRepository(
              DealLocalDataSource(), // ✅ THIS WAS MISSING
            ),
          )..add(LoadDeals()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}