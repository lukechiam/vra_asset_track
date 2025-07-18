import 'package:flutter/material.dart';

class VraNav extends StatelessWidget {
  final VoidCallback? onNextPressed;
  final VoidCallback? onBackPressed;
  final bool isNextReady;
  final bool isBackReady;

  const VraNav({
    super.key,
    this.onNextPressed,
    this.onBackPressed,
    required this.isNextReady,
    required this.isBackReady,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: (isBackReady) ? onBackPressed : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // Full-width button
                foregroundColor: Colors.white,
                backgroundColor: (isBackReady) ? Colors.brown : Colors.grey,
              ),
              child: const Text('< Back'),
            ),
          ),

          const SizedBox(width: 16.0),

          Expanded(
            child: ElevatedButton(
              onPressed: (isNextReady) ? onNextPressed : null,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // Full-width button
                foregroundColor: Colors.white,
                backgroundColor: (isNextReady) ? Colors.blue : Colors.grey,
              ),
              child: const Text('Next >'),
            ),
          ),
        ],
      ),
    );
  }
}
