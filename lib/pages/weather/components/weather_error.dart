import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({super.key, this.errorMessage, this.onPressed});

  final String? errorMessage;
  final VoidCallback? onPressed;

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
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: onPressed,
          label: Text('Retry'),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
