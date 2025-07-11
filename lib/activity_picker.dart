import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/repository/activity.dart';
import 'package:vra_asset_track/widget/activity.dart';

class ActivitySelection extends StatefulWidget {
  final ActivityRepository repo;

  const ActivitySelection(this.repo, {super.key});

  @override
  State<ActivitySelection> createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {
  List<Activity> activityForDropdown = [];
  List<Activity> activityForCheckbox = [];
  Activity? selectedActivity;
  List<Activity> selectedActivityTasks = [];

  bool get _isButtonEnabled => selectedActivityTasks.isNotEmpty;

  void _onButtonPressed() {
    Navigator.pushNamed(
      context,
      '/gear_select',
      arguments: {'activities': selectedActivityTasks},
    );
  }

  @override
  void initState() {
    super.initState();

    widget.repo.fetchActivities().then((data) {
      setState(() {
        activityForDropdown = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What did you do?'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: activityForDropdown.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActivityDropdown(
                    avavilableActivity: activityForDropdown,
                    label: 'Activity?',
                    hint: 'Click to select',
                    onChanged: (activity) {
                      setState(() {
                        selectedActivity = activity;
                        selectedActivityTasks.clear();
                      });

                      // Load children activities
                      if (selectedActivity != null) {
                        widget.repo
                            .fetchActivities(parentId: selectedActivity!.id)
                            .then((data) {
                              setState(() {
                                activityForCheckbox = data;
                              });
                            });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  if (selectedActivity != null)
                    ActivityListSelector(
                      avavilableActivity: activityForCheckbox,
                      onChanged: (value) {
                        setState(() {
                          // selectedTaskIds = value!;
                          selectedActivityTasks = value!;
                        });
                      },
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
