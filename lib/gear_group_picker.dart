import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/extra_data.dart';
import 'package:vra_asset_track/common/gear.dart';
import 'package:vra_asset_track/repository/gear.dart';
import 'package:vra_asset_track/widget/vra_nav.dart';

class GearGroupSelection extends StatefulWidget {
  final GearRepository repo;
  final PageRecord? pageRecord;

  const GearGroupSelection(this.repo, this.pageRecord, {super.key});

  @override
  State<GearGroupSelection> createState() => _GearGroupSelectionState();
}

class ProfileRecord {}

class _GearGroupSelectionState extends State<GearGroupSelection> {
  bool _isLoading = true;
  String? _error;
  List<Gear>? topLevelGears;

  // Map of activities and its associated top-level gears (aka. gear containers)
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

  void _onButtonPressed() {
    final pageRecord = (
      selectedActivities: widget.pageRecord!.selectedActivities,
      index: 0,
      activityToContainersMap: activityToContainersMap,
      selection: null,
    );
    context.push('/gear', extra: pageRecord);
  }

  void _loadTopLevelGears() {
    _isLoading = true;

    widget.repo
        .fetchByParent()
        .then((data) {
          setState(() {
            topLevelGears = data;
            _isLoading = false;
          });
        })
        .catchError((e) {
          setState(() {
            _isLoading = false;
            _error = e.toString();
          });
        });
  }

  @override
  void initState() {
    super.initState();

    _loadTopLevelGears();
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
              _isLoading = true;
            },
            child: Text('OK'),
          ),
        ],
      );
    }

    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(2),
                  itemCount: widget.pageRecord!.selectedActivities!.length,
                  itemBuilder: (context, index) {
                    final Activity activity =
                        widget.pageRecord!.selectedActivities![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 18),
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
                        (topLevelGears == null)
                            ? AlertDialog(
                                title: Text('Something went wrong'),
                                content: Text(
                                  'Unexpectedly, no gear containers loaded. Please retry.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _loadTopLevelGears();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: topLevelGears!.length,
                                itemBuilder: (context, innerIndex) {
                                  final Gear topLevelGear =
                                      topLevelGears![innerIndex];
                                  return CheckboxListTile(
                                    title: Text(topLevelGear.name),
                                    value:
                                        activityToContainersMap[activity] !=
                                            null
                                        ? activityToContainersMap[activity]!
                                              .contains(topLevelGear)
                                        : false,
                                    onChanged: (bool? value) =>
                                        _handleCheckboxChange(
                                          activity,
                                          topLevelGear,
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

              VraNav(
                isNextReady: activityToContainersMap.isNotEmpty,
                isBackReady: context.canPop(),
                onNextPressed: _onButtonPressed,
                onBackPressed: () => context.pop(),
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
