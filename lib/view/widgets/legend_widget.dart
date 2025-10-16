import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    super.key,
    required this.legendItems,
    required this.serviceColors,
    this.filterable = false,
    required this.selectedLegends,
    required this.onLegendToggled,
  });

  final List<String> legendItems;
  final List<Map<String, Color>> serviceColors;
  final bool filterable;
  final List<String> selectedLegends;
  final Function(String) onLegendToggled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 10,
        spacing: 20,
        children:
            legendItems.map((e) {
              return _buildLegendItem(
                e,
                serviceColors.firstWhere(
                  (element) => element.containsKey(e),
                )[e]!,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        filterable
            ? Checkbox(
              activeColor: color,
              side: BorderSide(color: color),
              value: selectedLegends.contains(label),
              onChanged: (value) => onLegendToggled(label),
            )
            : Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

        if (!filterable) const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }
}
