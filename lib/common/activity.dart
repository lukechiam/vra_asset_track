import 'package:vra_asset_track/common/gear.dart';

class Activity {
  final int id;
  final String name;
  final int parentId;
  final List<GearType> gearTypesRequired;
  final List<Activity> children;

  const Activity({
    required this.id,
    required this.name,
    required this.parentId,
    this.gearTypesRequired = const [],
    this.children = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Activity && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Activity.fromData(Map<String, dynamic> data) {
    List<Activity> children = [];
    if (data['children'] != null) {
      var childrenData = data['children'] as List<dynamic>;
      children = childrenData
          .map(
            (childJson) => Activity.fromData(childJson as Map<String, dynamic>),
          )
          .toList();
    }

    List<GearType> gearTypeRequiredList = [];
    if (data['gear_type_required'] != null) {
      var gearTypeRequiredData = data['gear_type_required'] as List<dynamic>;
      gearTypeRequiredList = gearTypeRequiredData
          .map((item) => GearType.fromString(item as String))
          .toList();
    }

    return Activity(
      id: data['id'] as int,
      name: data['name'] as String,
      parentId: data['parent_id'] as int,
      gearTypesRequired: gearTypeRequiredList,
      children: children,
    );
  }
}

class ActivityGearMapping extends Activity {
  final List<Gear> xxx;

  const ActivityGearMapping({
    required super.id,
    required super.name,
    required super.parentId,
    required this.xxx,
  });

  // Factory constructor
  factory ActivityGearMapping.fromActivity(
    Activity activity, {
    required List<Gear> xxx,
  }) {
    return ActivityGearMapping(
      id: activity.id,
      name: activity.name,
      parentId: activity.parentId,
      xxx: xxx,
    );
  }
}
