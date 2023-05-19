import 'package:flutter/material.dart';
import 'package:versionary/src/app.dart';

/// ErrorView is a simple page that displays the supplied error message.
class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, required this.error}) : super(key: key);

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        error == null ? 'Boom! Something bad happened' : error.toString();
    return Scaffold(
      appBar: const VersionaryAppBar(title: 'Error'),
      body: Center(
        child: Text(errorMessage),
      ),
    );
  }
}
