import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/gear.dart';
import 'dart:convert';

class GearSelection extends StatefulWidget {
  const GearSelection({super.key});

  @override
  State<GearSelection> createState() => _GearSelectionState();
}

class _GearSelectionState extends State<GearSelection> {
  List<Gear> _gearList = [];
  late List<Map<String, dynamic>> gearListMap;
  // late List<Gear> gearSelectionList;

  // // Deserialize from JSON
  // factory Gear.fromJson(Map<String, dynamic> json) => Gear(
  //   id: json['id'],
  //   type: GearType.values.firstWhere(
  //     (e) => e.name == json['type'],
  //     orElse: () => GearType.misc, // Default fallback
  //   ),
  //   name: json['name'] as String,
  // );

  @override
  void initState() {
    super.initState();

    _loadJsonData();
    // gearListMap = getMapX();
  }

  List<Map<String, dynamic>> getMapX([int id = 0]) {
    return _gearList
        .where((e) => e.parentId == id && e.trackUsage)
        .map((e) => {'label': e.name, 'object': e, 'isChecked': false})
        .toList();
  }

  Future<void> _loadJsonData() async {
    // Load JSON file from assets
    final String response = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/data/gear_tree.json');
    // Parse JSON
    final data = jsonDecode(response);
    setState(() {
      _gearList = (data as List<dynamic>)
          .map((e) => Gear.fromData(e as Map<String, dynamic>))
          .toList();
      gearListMap = getMapX(10000);
    });
  }

  // List<Gear> getGearAndChildren(List<int> ids) {
  //   _loadJsonData();
  //   return [];
  // }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<Gear> groupings = arguments['groupings'] ?? [];
    final List<Activity> activities = arguments['activities'] ?? [];
    final int index = arguments['index'] ?? 0;
    // List<Gear> gearList =

    return Scaffold(
      appBar: AppBar(title: const Text('Select gear used')),
      body: _gearList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: groupings.length,
              itemBuilder: (context, groupIndex) {
                return Column(
                  children: [
                    Text('For ${activities[index].name}'),

                    Text('In ${groupings[groupIndex].name}'),
                    ListView.builder(
                      itemCount: gearListMap.length,
                      itemBuilder: (context, index) {
                        return Text('In ${gearListMap.length}');
                      },
                    ),
                    // ListView.builder(
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    //   padding: const EdgeInsets.all(2),
                    //   itemCount: gearListMap.length,
                    //   itemBuilder: (context, index) {
                    //     return CheckboxListTile(
                    //       title: Text(gearListMap[index]['label']),
                    //       value: gearListMap[index]['isChecked'],
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           gearListMap[index]['isChecked'] =
                    //               value ?? false;
                    //         });
                    //       },
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 16),
                    // Next button
                    if (index + 1 < activities.length)
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/set_usage',
                              arguments: {
                                'index': index + 1,
                                'groupings': gearListMap
                                    .where((e) => e['isChecked'] == true)
                                    .map((e) => e['object'] as Gear)
                                    .toList(),
                                'activities': activities,
                              },
                            );
                          },
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
                              '/',
                              (route) => false,
                            );
                          },
                          child: const Text('Done'),
                        ),
                      ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
    );
  }

  @override
  void dispose() {
    // Clean up resources (e.g., controllers, listeners)
    super.dispose();
  }
}
