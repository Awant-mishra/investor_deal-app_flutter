import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/deal/deal_bloc.dart';
import '../../business_logic/blocs/deal/deal_event.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  String? selectedRisk;
  String? selectedIndustry;
  RangeValues roiRange = const RangeValues(0, 30);

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildChip(String label, String? selected, Function(String) onTap) {
    final isSelected = selected == label;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dealBloc = BlocProvider.of<DealBloc>(context);

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filters",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// 🎯 RISK FILTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ["Low", "Medium", "High"]
                  .map(
                    (e) => buildChip(e, selectedRisk, (val) {
                  setState(() => selectedRisk = val);
                }),
              )
                  .toList(),
            ),

            const SizedBox(height: 20),

            /// 🏭 INDUSTRY FILTER
            Wrap(
              spacing: 10,
              children: ["Technology", "Healthcare", "Finance", "Agriculture"]
                  .map(
                    (e) => buildChip(e, selectedIndustry, (val) {
                  setState(() => selectedIndustry = val);
                }),
              )
                  .toList(),
            ),

            const SizedBox(height: 20),

            /// 📊 ROI SLIDER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("ROI Range"),
                RangeSlider(
                  values: roiRange,
                  min: 0,
                  max: 30,
                  divisions: 6,
                  labels: RangeLabels(
                    roiRange.start.toStringAsFixed(0),
                    roiRange.end.toStringAsFixed(0),
                  ),
                  onChanged: (values) {
                    setState(() => roiRange = values);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// 🔘 BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      dealBloc.add(ClearFilters());
                      Navigator.pop(context);
                    },
                    child: const Text("Clear"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      dealBloc.add(
                        FilterDeals(
                          risk: selectedRisk,
                          industry: selectedIndustry,
                          minRoi: roiRange.start,
                          maxRoi: roiRange.end,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}