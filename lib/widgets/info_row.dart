import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  final int calories;
  final double protein;
  final double fat;
  final double carbs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _InfoCard(title: 'Ккал', value: '$calories'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoCard(
            title: 'Белки',
            value: '${protein.toStringAsFixed(1)} г',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoCard(title: 'Жиры', value: '${fat.toStringAsFixed(1)} г'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _InfoCard(
            title: 'Углеводы',
            value: '${carbs.toStringAsFixed(1)} г',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E7EA)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF7A6E69),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4B3935),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
