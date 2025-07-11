import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/gear.dart';
import 'package:vra_asset_track/repository/gear.dart';

import 'package:vra_asset_track/widget/gear.dart';

class GearSelection extends StatefulWidget {
  const GearSelection({super.key});

  @override
  State<GearSelection> createState() => _GearSelectionState();
}

class _GearSelectionState extends State<GearSelection> {
  final Map<int, List<int>> activityIdToGearIdsMap = {};
  late Map<int, List<int>> activityIdToSelectedGearIdsMap;
  bool _isLastActivity = true;
  bool _isLoading = true;
  late int index;
  late Activity indexedActivity;
  List<Gear> containerList = [];
  Map<int, List<Gear>> containerIdToGearsMap = {};
  late Map<Activity, List<Gear>> activityToContainersMap;

  bool get _isButtonEnabled => activityIdToGearIdsMap.isNotEmpty;

  @override
  void initState() {
    super.initState();

    // Read parameters passed in by caller and make API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Activity> activityList;

      // Get parameters given by caller
      final Map<String, dynamic> arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      activityToContainersMap = arguments['activityContainerMap'] ?? {};
      activityIdToSelectedGearIdsMap = arguments['selection'] ?? {};
      index = arguments['index'] ?? 0;

      // Page handles 1 activity at a time; get an activity with the given index
      // and associated containers. Map.keys output is defined by insertion order
      activityList = activityToContainersMap.keys.toList();
      _isLastActivity = index + 1 >= activityList.length;
      indexedActivity = activityList[index];
      containerList = activityToContainersMap[indexedActivity]!;

      // Get gear objects in containers associated with activity
      GearRepository()
          .fetchByParents(containerList.map((item) => item.id).toList())
          .then((data) {
            setState(() {
              containerIdToGearsMap = data
                  // Select only track usage gear
                  .where((item) => item.trackUsage)
                  // Map gears to container id
                  .fold(<int, List<Gear>>{}, (map, item) {
                    map.putIfAbsent(item.parentId, () => []).add(item);
                    return map;
                  });

              // Pre-select gears of types defined in activity, if it hasn't been done
              if (!activityIdToSelectedGearIdsMap.containsKey(
                indexedActivity.id,
              )) {
                // Flatten gears in map that match activity's required gear types to the list
                final List<int> gearIds = containerIdToGearsMap.values
                    .expand(
                      (itemList) => itemList
                          .where(
                            (item) => indexedActivity.gearTypesRequired
                                .contains(item.type),
                          )
                          .map((item) => item.id),
                    )
                    .toList();

                activityIdToSelectedGearIdsMap[indexedActivity.id] = gearIds;
              }
            });
          });
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select gear used'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        TextSpan(text: 'For ${indexedActivity.name}\n'),
                        TextSpan(
                          text:
                              '(Items are preselected for convenience, deselect if not used)',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    // Loop thru all activity's containers
                    child: ListView.builder(
                      padding: const EdgeInsets.all(2),
                      itemCount: containerList!.length,
                      itemBuilder: (context, index) {
                        final Gear aContainer = containerList[index];
                        final List<Gear> containerGearList =
                            containerIdToGearsMap.containsKey(aContainer.id)
                            ? containerIdToGearsMap[aContainer.id]!.toList()
                            : [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(text: '${aContainer.name}\n'),
                                ],
                              ),
                            ),

                            // List all the geat in the container
                            GearSelector(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gearList: containerGearList,
                              preSelectedIds:
                                  activityIdToSelectedGearIdsMap[indexedActivity
                                      .id],
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Next button
                  if (!_isLastActivity)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/set_usage',
                            arguments: {
                              'index': index + 1,
                              'activityContainerMap': activityToContainersMap,
                              'selection': activityIdToSelectedGearIdsMap,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            double.infinity,
                            48,
                          ), // Full-width button
                          foregroundColor: Colors.white,
                          backgroundColor: true ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Next'),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/complete',
                            arguments: {
                              'selection': activityIdToSelectedGearIdsMap,
                            },
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            double.infinity,
                            48,
                          ), // Full-width button
                          foregroundColor: Colors.white,
                          backgroundColor: true ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Done'),
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
