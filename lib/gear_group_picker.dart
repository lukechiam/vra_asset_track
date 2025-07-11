import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/gear.dart';
import 'package:vra_asset_track/repository/gear.dart';

class GearGroupSelection extends StatefulWidget {
  final GearRepository repo;

  const GearGroupSelection(this.repo, {super.key});

  @override
  State<GearGroupSelection> createState() => _GearGroupSelectionState();
}

class _GearGroupSelectionState extends State<GearGroupSelection> {
  List<Gear> gearContainers = [];
  late List<Activity> selectedActivities;

  // Map of activities and its associated gear containers
  final Map<Activity, List<Gear>> activityToContainersMap = {};

  void _handleCheckboxChange(Activity activity, Gear gear, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        if (!activityToContainersMap.containsKey(activity)) {
          activityToContainersMap[activity] = [];
        }
        activityToContainersMap[activity]!.add(gear);
      } else {
        activityToContainersMap[activity]!.remove(gear);
        if (activityToContainersMap[activity]!.isEmpty) {
          activityToContainersMap.remove(activity);
        }
      }
    });
  }

  bool get _isButtonEnabled => activityToContainersMap.isNotEmpty;

  void _onButtonPressed() {
    Navigator.pushNamed(
      context,
      '/set_usage',
      arguments: {
        'activities': selectedActivities,
        'activityContainerMap': activityToContainersMap,
      },
    );
  }

  @override
  void initState() {
    super.initState();

    widget.repo.fetchByParent().then((data) {
      setState(() {
        gearContainers = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    selectedActivities = arguments['activities'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select gear container'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: selectedActivities.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      itemCount: selectedActivities.length,
                      itemBuilder: (context, index) {
                        final Activity activity = selectedActivities[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                children: [
                                  TextSpan(text: 'For ${activity.name}\n'),
                                  TextSpan(
                                    text:
                                        'Select the container (eg. bag) of the gear used',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Loop for all top level gear (aka. gear container)
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: gearContainers.length,
                              itemBuilder: (context, innerIndex) {
                                final Gear innerItem =
                                    gearContainers[innerIndex];
                                return CheckboxListTile(
                                  title: Text(innerItem.name),
                                  // value: _selectedIds.contains(innerItem.id),
                                  // value: _selectionMap[activity.id] != null
                                  //     ? _selectionMap[activity.id]!.contains(
                                  //         innerItem.id,
                                  //       )
                                  //     : false,
                                  value:
                                      activityToContainersMap[activity] != null
                                      ? activityToContainersMap[activity]!
                                            .contains(innerItem)
                                      : false,
                                  onChanged: (bool? value) =>
                                      _handleCheckboxChange(
                                        activity,
                                        innerItem,
                                        value,
                                      ),
                                  visualDensity: VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Next button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _onButtonPressed : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          double.infinity,
                          48,
                        ), // Full-width button
                        foregroundColor: Colors.white,
                        backgroundColor: _isButtonEnabled
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    // Clean up resources (e.g., controllers, listeners)
    super.dispose();
  }
}
