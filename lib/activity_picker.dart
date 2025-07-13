import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/repository/activity.dart';
import 'package:vra_asset_track/widget/activity.dart';
import 'package:vra_asset_track/widget/vra-scaffold.dart';

class ActivitySelection extends StatefulWidget {
  final ActivityRepository repo;

  const ActivitySelection(this.repo, {super.key});

  @override
  State<ActivitySelection> createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {
  List<Activity> activityForDropdown = [];
  List<Activity>? activityForCheckbox;
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
    return VraScaffold(
      body: Column(
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
            (activityForCheckbox == null)
                ? Center(child: CircularProgressIndicator())
                : ActivityListSelector(
                    avavilableActivity: activityForCheckbox!,
                    onChanged: (value) {
                      setState(() {
                        // selectedTaskIds = value!;
                        selectedActivityTasks = value!;
                      });
                    },
                  ),
        ],
      ),

      onNextPressed: _onButtonPressed,
      isNextReady: _isButtonEnabled,
    );
  }

  @override
  void dispose() {
    // Clean up resources (e.g., controllers, listeners)
    super.dispose();
  }
}
