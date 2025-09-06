import 'package:flutter/material.dart';
import 'package:openauth/shared/widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo.extraLarge(),
                  const SizedBox(height: 24),
                  Text(
                    'OpenAuth',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
  }
}