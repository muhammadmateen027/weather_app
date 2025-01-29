import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('😒', style: TextStyle(fontSize: 64)),
        Text(
          errorMessage ?? 'Something went wrong!',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}
