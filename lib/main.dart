import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'config/routes.dart';
import 'data/local_storage_service.dart';
import 'state/dashboard_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

 
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF060912),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await LocalStorageService.init();

  runApp(const FluxDashApp());
}

class FluxDashApp extends StatelessWidget {
  const FluxDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'FluxDash',
        debugShowCheckedModeBanner: false,
        theme: FluxTheme.dark,
        darkTheme: FluxTheme.dark,
        themeMode: ThemeMode.dark,
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
