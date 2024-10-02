import 'package:flutter/material.dart';

import 'package:bu_pulse/helpers/functions.dart';

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({ super.key, required this.error });

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return Center(child: Text(error));
  }
}
