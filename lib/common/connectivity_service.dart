import 'package:http/http.dart' as http;

class ConnectivityService {
  // Singleton pattern for easy access
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Check if device is online
  Future<bool> isOnline() async {
    try {
      final response = await http
          .get(Uri.parse('https://supabase.com'))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
