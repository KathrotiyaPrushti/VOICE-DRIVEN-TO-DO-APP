import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_exam/providers/task_provider.dart';
import 'package:project_exam/screens/home_screen.dart';
import 'package:project_exam/services/voice_service.dart';
import 'package:project_exam/services/auth_service.dart';
import 'package:project_exam/screens/login_screen.dart';
import 'package:project_exam/screens/signup_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map>('tasks');
  await Hive.openBox('auth');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => VoiceService()),
      ],
      child: MaterialApp(
        title: 'Voice-Driven To-Do',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFFB5EAD7), // Pastel mint
            secondary: const Color(0xFFFFDAC1), // Pastel peach
            surface: const Color(0xFFFFF5E6), // Light cream
            background: const Color(0xFFFFF9F0), // Very light cream
            error: const Color(0xFFFFB7B2), // Pastel red
            onPrimary: const Color(0xFF2D3436), // Dark gray
            onSecondary: const Color(0xFF2D3436), // Dark gray
            onSurface: const Color(0xFF2D3436), // Dark gray
            onBackground: const Color(0xFF2D3436), // Dark gray
            onError: const Color(0xFF2D3436), // Dark gray
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF9F0), // Very light cream
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFB5EAD7), // Pastel mint
            foregroundColor: Color(0xFF2D3436), // Dark gray
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFFFFFFFF), // White
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFFB5EAD7), // Pastel mint
            foregroundColor: const Color(0xFF2D3436), // Dark gray
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF2D3436)), // Dark gray
            bodyMedium: TextStyle(color: Color(0xFF2D3436)), // Dark gray
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: const Color(0xFF7FB3D5), // Darker pastel blue
            secondary: const Color(0xFFD4A5A5), // Darker pastel pink
            surface: const Color(0xFF2D3436), // Dark gray
            background: const Color(0xFF1E1E1E), // Very dark gray
            error: const Color(0xFFE57373), // Darker pastel red
            onPrimary: const Color(0xFFFFFFFF), // White
            onSecondary: const Color(0xFFFFFFFF), // White
            onSurface: const Color(0xFFFFFFFF), // White
            onBackground: const Color(0xFFFFFFFF), // White
            onError: const Color(0xFFFFFFFF), // White
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Very dark gray
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2D3436), // Dark gray
            foregroundColor: Color(0xFFFFFFFF), // White
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF2D3436), // Dark gray
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF7FB3D5), // Darker pastel blue
            foregroundColor: Color(0xFFFFFFFF), // White
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFFFFFFFF)), // White
            bodyMedium: TextStyle(color: Color(0xFFFFFFFF)), // White
          ),
        ),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) {
            final authService = context.watch<AuthService>();
            return authService.isLoggedIn ? const HomeScreen() : const LoginScreen();
          },
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
        },
      ),
    );
  }
}

