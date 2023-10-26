import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const ForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 167, 164, 164),
      elevation: 10,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              temperature,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
