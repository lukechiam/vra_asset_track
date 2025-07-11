import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vra_asset_track/common/activity.dart';

class ActivityRepository {
  // Static instance variable to hold the single instance
  static final ActivityRepository _instance = ActivityRepository._internal();

  // Private constructor to prevent external instantiation
  ActivityRepository._internal();

  // Factory constructor to return the same instance
  factory ActivityRepository() {
    return _instance;
  }

  final SupabaseClient client = Supabase.instance.client;

  Future<List<Activity>> fetchActivities({int parentId = 0}) async {
    try {
      final response = await client
          .from('activity')
          .select()
          .eq('parent_id', parentId);
      return response.map((e) => Activity.fromData(e)).toList();
    } catch (error) {
      return [];
      // throw Exception('Error fetching activities: $error');
    }
  }
}
