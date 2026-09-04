import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Role.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/RolesItem.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/bloc/RolesBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/bloc/RolesEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/bloc/RolesState.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RolesBloc>().add(const GetRolesList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Seleccionar Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state.roles != null && state.roles!.isNotEmpty) {
            if (state.roles!.length == 1) {
              final role = state.roles!.first;
              final roleId = role?.id.toUpperCase() ?? '';
              String targetRoute = AppRoutes.homeClient;
              if (roleId == 'ADMIN' || roleId == 'ADMINISTRADOR') {
                targetRoute = AppRoutes.homeAdmin;
              } else if (roleId == 'MEDICO' || roleId == 'DOCTOR') {
                targetRoute = AppRoutes.homeDoctor;
              } else {
                targetRoute = AppRoutes.homeClient;
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, targetRoute);
              });
              return const Center(child: CircularProgressIndicator());
            }
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.supervised_user_circle,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('¿Cómo deseas ingresar?', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona el rol con el que deseas acceder a MediApp hoy.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (state.roles != null)
                    ...state.roles!.where((r) => r != null).map((Role? role) {
                      return RolesItem(role!);
                    }).toList()
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}