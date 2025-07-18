import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vra_asset_track/common/gear.dart';

class GearRepository {
  // Static instance variable to hold the single instance
  static final GearRepository _instance = GearRepository._internal();

  // Private constructor to prevent external instantiation
  GearRepository._internal();

  // Factory constructor to return the same instance
  factory GearRepository() {
    return _instance;
  }

  final SupabaseClient client = Supabase.instance.client;

  Future<List<Gear>> fetchByParent({int parentId = 0}) async {
    try {
      final response = await client
          .from('gear')
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
      ;
      return response.map((e) => Gear.fromData(e)).toList();
    } catch (error) {
      throw Exception('Error fetching gear: $error');
    }
  }

  Future<List<Gear>> fetchByParents(List<int> parentIds) async {
    try {
      final response = await client
          .from('gear')
          .select()
          .inFilter('parent_id', parentIds)
          .order('name', ascending: true);
      return response.map((e) => Gear.fromData(e)).toList();
    } catch (error) {
      throw Exception('Error fetching gear: $error');
    }
  }

  // Map<int, List<int>>
  Future<bool> saveGearUsage(Map<int, List<int>> activityIdToGearIdsMap) async {
    final List<Map<String, dynamic>>? dataToSave = activityIdToGearIdsMap
        .entries
        .expand(
          (entry) => entry.value.map(
            (gearId) =>
                {'activity_id': entry.key, 'gear_id': gearId, 'user_id': 0}
                    as Map<String, dynamic>,
          ),
        )
        .toList();

    try {
      final response = await client
          .from('gear_usage')
          .insert(dataToSave!)
          .select();
      print('Inserted records: $response');
      return true;
    } catch (error) {
      throw Exception('Error fetching gear: $error');
    }
  }
}
