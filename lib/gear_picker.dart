import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/extra_data.dart';
import 'package:vra_asset_track/common/gear.dart';
import 'package:vra_asset_track/repository/gear.dart';
import 'package:vra_asset_track/widget/gear.dart';
import 'package:vra_asset_track/widget/vra_nav.dart';

class GearSelection extends StatefulWidget {
  final PageRecord? pageRecord;

  const GearSelection(this.pageRecord, {super.key});

  @override
  State<GearSelection> createState() => _GearSelectionState();
}

class _GearSelectionState extends State<GearSelection> {
  bool _isLoading = true;
  String? _error;
  final Map<int, List<int>> activityIdToGearIdsMap = {};
  Map<int, List<int>> activityIdToSelectedGearIdsMap = {};
  bool _isLastActivity = true;
  Activity? indexedActivity;
  List<Gear> containerList = [];
  Map<int, List<Gear>> containerIdToGearsMap = {};
  late Map<Activity, List<Gear>> activityToContainersMap;

  // Get gears in top-level gear (aka. gear container) associated with activity
  // and pre-select gears matching activity's gear type need.
  void _loadChildrenOfTopLevelGear() {
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
              indexedActivity!.id,
            )) {
              // Flatten gears in map that match activity's required gear types to the list
              final List<int> gearIds = containerIdToGearsMap.values
                  .expand(
                    (itemList) => itemList
                        .where(
                          (item) => indexedActivity!.gearTypesRequired.contains(
                            item.type,
                          ),
                        )
                        .map((item) => item.id),
                  )
                  .toList();

              activityIdToSelectedGearIdsMap[indexedActivity!.id] = gearIds;
            }
          });
        })
        .catchError((e) {
          setState(() {
            _isLoading = false;
            _error = e.toString();
          });
        });
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();

    // Read parameters passed in by caller and make API call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<Activity> activityList;

      activityToContainersMap =
          widget.pageRecord!.activityToContainersMap ?? {};
      activityIdToSelectedGearIdsMap = widget.pageRecord!.selection ?? {};

      // Page handles 1 activity at a time; get an activity with the given index
      // and associated containers. Map.keys output is defined by insertion order
      activityList = widget.pageRecord!.activityToContainersMap!.keys.toList();
      _isLastActivity = widget.pageRecord!.index + 1 >= activityList.length;
      indexedActivity = activityList[widget.pageRecord!.index];
      containerList =
          widget.pageRecord!.activityToContainersMap![indexedActivity]!;

      _loadChildrenOfTopLevelGear();
    });
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
              _loadChildrenOfTopLevelGear();
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
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  children: [
                    TextSpan(text: 'For ${indexedActivity!.name}\n'),
                    TextSpan(
                      text:
                          '(Items are pre-selected for convenience, deselect if not used)',
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [TextSpan(text: '${aContainer.name}\n')],
                          ),
                        ),

                        // List all the geat in the container
                        GearSelector(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gearList: containerGearList,
                          preSelectedIds:
                              activityIdToSelectedGearIdsMap[indexedActivity!
                                  .id],
                        ),
                      ],
                    );
                  },
                ),
              ),

              VraNav(
                isNextReady: activityIdToSelectedGearIdsMap.isNotEmpty,
                isBackReady: context.canPop(),
                onNextPressed: () {
                  if (!_isLastActivity) {
                    final pageRecord = (
                      selectedActivities: widget.pageRecord!.selectedActivities,
                      index: widget.pageRecord!.index + 1,
                      activityToContainersMap: activityToContainersMap,
                      selection: activityIdToSelectedGearIdsMap,
                    );
                    context.push('/gear', extra: pageRecord);
                  } else {
                    final pageRecord = (
                      selectedActivities: widget.pageRecord!.selectedActivities,
                      index: widget.pageRecord!.index,
                      activityToContainersMap: activityToContainersMap,
                      selection: activityIdToSelectedGearIdsMap,
                    );
                    context.push('/complete', extra: pageRecord);
                  }
                },
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
