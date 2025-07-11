import 'package:flutter/material.dart';

class GearGroupScreen extends StatefulWidget {
  const GearGroupScreen({super.key});

  @override
  State<GearGroupScreen> createState() => _GearGroupScreen();
}

class _GearGroupScreen extends State<GearGroupScreen> {
  String? selectedActivity;
  String? selectedSubCategory;

  final List<DropdownMenuEntry<String>> entries = [
    const DropdownMenuEntry(value: 'Operation', label: 'Operation'),
    const DropdownMenuEntry(value: 'Training', label: 'Training'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Gear used')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownMenu<String>(
              initialSelection: null,
              controller: null,
              requestFocusOnTap: true,
              onSelected: (String? activity) {
                setState(() {
                  selectedActivity = activity;
                });
              },
              label: const Text('Select an activity'),
              dropdownMenuEntries: entries,
              width: 300,
            ),
            const SizedBox(height: 16),
            // Next button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // final selectedTasks = _tasks.entries
                  //     .where((entry) => entry.value)
                  //     .map((entry) => entry.key)
                  //     .toList();
                  if (selectedActivity == 'Training')
                    Navigator.pushNamed(
                      context,
                      '/training',
                      arguments: {'categories': null, 'tasks': null},
                    );
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
