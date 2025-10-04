import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/router/router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    try {
      if (!dotenv.isInitialized) {
        await dotenv.load(fileName: 'tmdb_app_properties.env');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to load TMDB configuration: $error');
      }
    }

    final apiKey = dotenv.env['PERSONAL_TMDB_API_KEY'];
    final hasApiKey = apiKey != null && apiKey.isNotEmpty;
    final sessionId = dotenv.env['TMDB_SESSION_ID'] ?? '';
    final accessToken = dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';
    final isAuthenticated = sessionId.isNotEmpty || accessToken.isNotEmpty;

    if (!mounted) return;

    final router = context.router;

    if (!hasApiKey) {
      router.replaceAll([const RegisterRoute()]);
      return;
    }

    if (isAuthenticated) {
      router.replaceAll([const MainHomeRoute()]);
    } else {
      router.replaceAll([const SignInRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 64,
              width: 64,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 24),
            Text(
              'Preparing TMDB experience…',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
