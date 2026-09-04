import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/LoginPage.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/RegisterPage.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/welcome_screen.dart';
import 'package:myfirstlove/src/features/blocProvider.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/HomePage.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        title: 'MediApp — Citas Médicas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.primaryLight,
            surface: AppColors.background,
          ),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'SansSerif',
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}


