import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vra_asset_track/activity_picker.dart';
import 'package:vra_asset_track/common/extra_data.dart';
import 'package:vra_asset_track/done.dart';
import 'package:vra_asset_track/gear_group_picker.dart';
import 'package:vra_asset_track/gear_picker.dart';
import 'package:vra_asset_track/repository/gear.dart';

// Define a const AppBar to prevent rebuilds
final myAppBar = AppBar(
  actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
  backgroundColor: Color(0xFF006838),
  elevation: 8,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/banner.png'),
        fit: BoxFit.fitHeight,
        alignment: Alignment.centerRight,
      ),
    ),
  ),
);

// Router configuration with ShellRoute
final GoRouter _router = GoRouter(
  initialLocation: '/activity',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/activity',
          builder: (context, state) => ActivitySelection(),
        ),
        GoRoute(
          path: '/container',
          builder: (context, state) =>
              GearGroupSelection(GearRepository(), state.extra as PageRecord?),
        ),
        GoRoute(
          path: '/gear',
          builder: (context, state) =>
              GearSelection(state.extra as PageRecord?),
        ),
        GoRoute(path: '/complete', builder: (context, state) => DonePage()),
      ],
    ),
  ],
);

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  // int _currentIndex s= 0;

  @override
  Widget build(BuildContext context) {
    // Map routes to indices
    // final String currentPath = GoRouterState.of(context).matchedLocation;
    // _currentIndex = switch (currentPath) {
    //   '/activity' => 0,
    //   '/container' => 1,
    //   '/gear' => 2,
    //   '/complete' => 3,
    //   _ => 0,
    // };

    return Scaffold(
      appBar: myAppBar, // Reuse const AppBar
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: widget.child,
            ),
          ),
        ],
      ), // Display the current route's page
    );
  }
}
