import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.min = 1,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final int min;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Button(
          icon: Icons.remove_rounded,
          onTap: value <= min ? null : onDecrement,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            '$value',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ),
        _Button(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F0EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF4B3935)),
      ),
    );
  }
}
