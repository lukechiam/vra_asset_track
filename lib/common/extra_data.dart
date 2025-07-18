import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/common/gear.dart';

typedef PageRecord = ({
  List<Activity>? selectedActivities,
  int index,
  Map<Activity, List<Gear>>? activityToContainersMap,
  Map<int, List<int>>? selection,
});
