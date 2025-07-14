import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/connectivity_service.dart';

class VraScaffold extends StatelessWidget {
  final Widget body;
  final VoidCallback? onNextPressed;
  final VoidCallback? onBackPressed;
  final bool isNextReady;
  final bool isBackReady;

  const VraScaffold({
    super.key,
    required this.body,
    this.onNextPressed,
    this.onBackPressed,
    this.isNextReady = false,
    this.isBackReady = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('VRA'),
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
      ),
      drawer: Drawer(
        // Common drawer for all screens
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu')),
            ListTile(title: Text('Option 1')),
            ListTile(title: Text('Option 2')),
          ],
        ),
      ),
      body: Column(
        children: [
          // Offline mode indicator
          FutureBuilder<bool>(
            future: ConnectivityService().isOnline(),
            builder: (context, snapshot) {
              final isOnline = snapshot.data ?? false;
              return isOnline
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity, // Takes full width of parent
                      color: Colors.red, // Red background
                      child: Text(
                        'Offline Mode',
                        style: const TextStyle(
                          color: Colors.white, // White text for contrast
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
            },
          ),

          Expanded(
            child: Padding(padding: const EdgeInsets.all(16.0), child: body),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (isBackReady) ? onBackPressed : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        48,
                      ), // Full-width button
                      foregroundColor: Colors.white,
                      backgroundColor: (isBackReady)
                          ? Colors.brown
                          : Colors.grey,
                    ),
                    child: const Text('< Back'),
                  ),
                ),

                const SizedBox(width: 16.0),

                Expanded(
                  child: ElevatedButton(
                    onPressed: (isNextReady) ? onNextPressed : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        double.infinity,
                        48,
                      ), // Full-width button
                      foregroundColor: Colors.white,
                      backgroundColor: (isNextReady)
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: const Text('Next >'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        // Common bottom navigation
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
