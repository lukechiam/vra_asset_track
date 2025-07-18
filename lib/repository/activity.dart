import 'dart:async';

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
          .eq('parent_id', parentId)
          .timeout(
            Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                'API request for data timed out after 5 seconds',
              );
            },
          );
      return response.map((e) => Activity.fromData(e)).toList();
    } catch (error) {
      throw Exception('Error fetching activities: $error');
    }
  }
}
