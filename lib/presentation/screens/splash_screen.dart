import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../business_logic/blocs/deal/deal_event.dart';
import '../../data/data_sources/deal_local_data_source.dart';
import '../../data/repositories/deal_repository.dart';
import '../../business_logic/blocs/deal/deal_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'deal_list_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DealBloc(
              DealRepository(DealLocalDataSource()),
            )..add(LoadDeals()),
            child: const DealListScreen(),
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Investor App",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}