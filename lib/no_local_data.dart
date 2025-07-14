import 'package:flutter/material.dart';

class NoLocalData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'No local data available to run in offline mode. You will need to run the app with internet access once to populate local data.',
    );
  }
}
