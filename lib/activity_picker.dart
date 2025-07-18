import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/repository/activity.dart';
import 'package:vra_asset_track/widget/activity.dart';
import 'package:vra_asset_track/widget/vra_nav.dart';

class ActivitySelection extends StatefulWidget {
  const ActivitySelection({super.key});

  @override
  State<ActivitySelection> createState() => _ActivitySelectionState();
}

class _ActivitySelectionState extends State<ActivitySelection> {
  bool _isTopLevelActivityLoading = true;
  bool _isActivityTaskLoading = true;
  String? _error;
  List<Activity>? _topLevelActivities;
  List<Activity>? activityForCheckbox;
  int? selectedTopLevelActivityId;
  List<Activity> selectedActivityTasks = [];

  void _onButtonPressed() {
    final pageRecord = (
      selectedActivities: selectedActivityTasks,
      index: 0,
      activityToContainersMap: null,
      selection: null,
    );

    context.push('/container', extra: pageRecord);
  }

  void _loadTopLevelActivities() {
    _isTopLevelActivityLoading = true;
    activityForCheckbox = null;
    selectedTopLevelActivityId = null;
    ActivityRepository()
        .fetchActivities()
        .then((data) {
          setState(() {
            _topLevelActivities = data;
            _isTopLevelActivityLoading = false;
            _error = null;
          });
        })
        .catchError((e) {
          setState(() {
            _isTopLevelActivityLoading = false;
            _error = e.toString();
          });
        });
  }

  void _loadActivityTasks() {
    _isActivityTaskLoading = true;
    if (selectedTopLevelActivityId != null) {
      ActivityRepository()
          .fetchActivities(parentId: selectedTopLevelActivityId!)
          .then((data) {
            setState(() {
              activityForCheckbox = data;
              _isActivityTaskLoading = false;
              _error = null;
            });
          })
          .catchError((e) {
            setState(() {
              _isActivityTaskLoading = false;
              _error = e.toString();
            });
          });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTopLevelActivities();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return AlertDialog(
        title: Text('Something went wrong'),
        content: Text(_error!),
        actions: [
          TextButton(
            onPressed: () {
              _loadTopLevelActivities();
            },
            child: Text('OK'),
          ),
        ],
      );
    }

    return (_isTopLevelActivityLoading)
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityDropdown(
                activities: _topLevelActivities!,
                label: 'Activity?',
                hint: 'Click to select',
                onChanged: (activity) {
                  setState(() {
                    selectedTopLevelActivityId = activity?.id ?? null;
                    selectedActivityTasks.clear();
                  });

                  // Load activity-tasks
                  if (selectedTopLevelActivityId != null) {
                    _loadActivityTasks();
                  }
                },
              ),

              const SizedBox(height: 16),

              if (selectedTopLevelActivityId != null)
                (_isActivityTaskLoading)
                    ? Center(child: CircularProgressIndicator())
                    : ActivityListSelector(
                        avavilableActivity: activityForCheckbox!,
                        onChanged: (value) {
                          setState(() {
                            selectedActivityTasks = value!;
                          });
                        },
                      ),

              VraNav(
                isNextReady: selectedActivityTasks.isNotEmpty,
                isBackReady: false,
                onNextPressed: _onButtonPressed,
                onBackPressed: null,
              ),
            ],
          );
  }

  @override
  void dispose() {
    // Clean up resources (e.g., controllers, listeners)
    super.dispose();
  }
}
