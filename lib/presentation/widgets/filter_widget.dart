import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/deal/deal_bloc.dart';
import '../../business_logic/blocs/deal/deal_event.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedRisk;
  String? selectedIndustry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          DropdownButton<String>(
            hint: const Text("Risk"),
            value: selectedRisk,
            items: ["Low", "Medium", "High"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() => selectedRisk = value);
              context.read<DealBloc>().add(FilterDeals(risk: value));
            },
          ),
          const SizedBox(width: 20),
          DropdownButton<String>(
            hint: const Text("Industry"),
            value: selectedIndustry,
            items: ["Technology", "Healthcare", "Finance", "Agriculture"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() => selectedIndustry = value);
              context.read<DealBloc>().add(FilterDeals(industry: value));
            },
          ),
        ],
      ),
    );
  }
}