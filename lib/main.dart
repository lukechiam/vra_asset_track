import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vra_asset_track/activity_picker.dart';
import 'package:vra_asset_track/common/activity.dart';
import 'package:vra_asset_track/done.dart';
import 'package:vra_asset_track/gear_group_picker.dart';
import 'package:vra_asset_track/gear_picker.dart';
import 'package:vra_asset_track/repository/activity.dart';
import 'package:vra_asset_track/repository/gear.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bqfgsiporwltimtxuiuu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxZmdzaXBvcndsdGltdHh1aXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE5NDc5MDgsImV4cCI6MjA2NzUyMzkwOH0.xH2aIkdW5DyT_3nTCJKbF7ctJVCSWwP8ljDwOTgy1p8',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.debug,
    ),
    storageOptions: const StorageClientOptions(retryAttempts: 10),
  );

  runApp(const SimpleFlutterApp());
}

class SimpleFlutterApp extends StatelessWidget {
  const SimpleFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      routes: {
        '/gear_select': (context) => GearGroupSelection(GearRepository()),
        '/set_usage': (context) => const GearSelection(),
        '/complete': (context) => const DonePage(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  List<Activity> activityTasks = [];
  Activity? selectedActivity;
  List<int>? selectedTaskIds;

  final List<DropdownMenuEntry<String>> entries = [
    const DropdownMenuEntry(value: 'Operation', label: 'Operation'),
    const DropdownMenuEntry(value: 'Training', label: 'Training'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActivitySelection(ActivityRepository());
  }
}
