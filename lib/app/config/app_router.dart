import 'package:go_router/go_router.dart';
import 'package:qro5de/app/features/generate_qr/screens/generate_qr_screen.dart';
import 'package:qro5de/app/features/history/screens/history_screen.dart';
import 'package:qro5de/app/features/qr_scanner/screens/qr_scanner_screen.dart';
import 'package:qro5de/app/features/settings/screens/settings_screen.dart';
import 'package:qro5de/app/features/splash/splash_screen.dart';
import 'package:qro5de/app/features/icon_generator/icon_generator_screen.dart';

class AppRouter {
  GoRouter get router => GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const GenerateQRScreen(),
      ),
      GoRoute(
        path: '/scanner',
        name: 'scanner',
        builder: (context, state) => const QRScannerScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/icon_generator',
        name: 'icon_generator',
        builder: (context, state) => const IconGeneratorScreen(),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
