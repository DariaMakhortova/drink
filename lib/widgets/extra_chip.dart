import 'package:flutter/material.dart';

class ExtraChip extends StatelessWidget {
  const ExtraChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.priceLabel,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? priceLabel;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: priceLabel != null ? Text('$label · $priceLabel') : Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
