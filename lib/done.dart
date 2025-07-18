import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vra_asset_track/main.dart';
import 'package:vra_asset_track/repository/gear.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  late Map<int, List<int>> activityIdToSelectedGearIdsMap;

  @override
  Widget build(BuildContext context) {
    // Get parameters given by caller
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    activityIdToSelectedGearIdsMap = arguments['selection'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gear usage ready to be saved'),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              _saveDataToApi(context);
              context.pushReplacement('/activity');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48), // Full-width button
              foregroundColor: Colors.white,
              backgroundColor: true ? Colors.blue : Colors.grey,
            ),
            child: const Text('Save now & go home'),
          ),
        ),
      ],
    );
  }

  // Function to make the API call
  Future<bool> _saveDataToApi(BuildContext context) async {
    try {
      GearRepository().saveGearUsage(activityIdToSelectedGearIdsMap);
      return true;
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }
}
