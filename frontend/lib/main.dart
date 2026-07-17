import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/auth_provider.dart';
import 'models/user.dart';
import 'screens/login_screen.dart';
import 'screens/adherent/adherent_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'app_router.dart';

void main() {
  runApp(const ProviderScope(child: AnomalixApp()));
}

class AnomalixApp extends ConsumerWidget {
  const AnomalixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return MaterialApp(
      title: 'Anomalix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E40AF)),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: _resolveHome(user),
    );
  }

  Widget _resolveHome(User? user) {
    if (user == null) return const LoginScreen();
    if (user.isAdmin) return const DashboardScreen();
    return const AdherentScreen();
  }
}