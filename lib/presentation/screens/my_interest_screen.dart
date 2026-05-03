import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyInterestScreen extends StatefulWidget {
  const MyInterestScreen({super.key});

  @override
  State<MyInterestScreen> createState() => _MyInterestScreenState();
}

class _MyInterestScreenState extends State<MyInterestScreen> {
  List<String> interests = [];

  @override
  void initState() {
    super.initState();
    loadInterests();
  }

  Future<void> loadInterests() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      interests = prefs.getStringList("interests") ?? [];
    });
  }

  Future<void> removeInterest(String id) async {
    final prefs = await SharedPreferences.getInstance();
    interests.remove(id);
    await prefs.setStringList("interests", interests);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Interests")),
      body: interests.isEmpty
          ? const Center(child: Text("No interests yet"))
          : ListView.builder(
        itemCount: interests.length,
        itemBuilder: (context, index) {
          final id = interests[index];

          return ListTile(
            title: Text("Deal ID: $id"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => removeInterest(id),
            ),
          );
        },
      ),
    );
  }
}