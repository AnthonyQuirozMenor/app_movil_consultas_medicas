import 'package:flutter/material.dart';
import 'package:myfirstlove/src/common_widgets/app_logo.dart';
import 'package:myfirstlove/src/common_widgets/primary_button.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class WelcomeScreen extends StatelessWidget{

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_hospital_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'MediApp',
                style: TextStyle(
                  fontFamily: 'SansSerif',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Citas Médicas al Instante',
                style: TextStyle(
                  fontFamily: 'SansSerif',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Conecta con médicos especialistas, agenda tus consultas y gestiona tu historial de salud en un solo lugar.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Comenzar',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Tu salud en las mejores manos',
                style: AppTextStyles.caption.copyWith(fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}


