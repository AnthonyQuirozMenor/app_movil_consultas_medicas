import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/models/Role.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/bloc/LoginBloc.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/bloc/LoginEvent.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/bloc/LoginState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';
import 'package:myfirstlove/src/common_widgets/custom_text_field.dart';
import 'package:myfirstlove/src/common_widgets/primary_button.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class LoginContent extends StatelessWidget {
  final LoginBloc? bloc;
  final LoginState state;

  const LoginContent(this.bloc, this.state, {super.key});

  Future<void> _quickLoginAs({
    required BuildContext context,
    required String roleId,
    required String roleName,
    required String targetRoute,
    required String userName,
    required String userLastname,
    required String email,
    String? cmp,
    String? specialty,
  }) async {
    final now = DateTime.now();
    final role = Role(
      id: roleId,
      name: roleName,
      image: '',
      route: targetRoute,
      createdAt: now,
      updatedAt: now,
    );

    final user = User(
      id: roleId == 'MEDICO' ? 2 : (roleId == 'ADMINISTRADOR' ? 99 : 1),
      name: userName,
      lastname: userLastname,
      email: email,
      phone: '+51 987 654 321',
      roles: [role],
      cmp: cmp,
      specialty: specialty,
      dni: '74829103',
    );

    final authResponse = AuthResponse(
      user: user,
      token: 'demo_token_${roleId.toLowerCase()}',
    );

    final authUseCases = locator<AuthUseCases>();
    await authUseCases.saveUserSessionUseCase.run(authResponse);

    Fluttertoast.showToast(
      msg: 'Sesión iniciada como $roleName ($userName)',
      toastLength: Toast.LENGTH_SHORT,
    );

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, targetRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: state.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo Médico
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_hospital_rounded,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'MediApp',
                  style: TextStyle(
                    fontFamily: 'SansSerif',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Citas y Consultas Médicas',
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo Email
                CustomTextField(
                  label: 'Correo Electrónico',
                  onChanged: (value) {
                    bloc?.add(LoginEmailChanged(email: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.email.error,
                ),
                const SizedBox(height: 16),

                // Campo Password
                CustomTextField(
                  label: 'Contraseña',
                  isPassword: true,
                  onChanged: (value) {
                    bloc?.add(
                      LoginPasswordChanged(password: BlocFormItem(value: value)),
                    );
                  },
                  validator: (value) => state.password.error,
                ),
                const SizedBox(height: 24),

                // Botón Login
                PrimaryButton(
                  text: 'Iniciar Sesión',
                  onPressed: () {
                    if (state.formKey!.currentState!.validate()) {
                      bloc?.add(const LoginSubmitted());
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Por favor completa los campos correctamente',
                        toastLength: Toast.LENGTH_SHORT,
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Enlace Registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta?',
                      style: AppTextStyles.body.copyWith(fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      child: const Text(
                        'Regístrate aquí',
                        style: AppTextStyles.textLink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Divisor de Acceso Rápido Demo
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'O ingresa al instante con perfil demo:',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Botones Demo por Rol
                _buildDemoButton(
                  context: context,
                  title: 'Ingresar como Paciente',
                  subtitle: 'Josué Quiroz • Reserva, citas e historial',
                  icon: Icons.person,
                  color: AppColors.primary,
                  onTap: () => _quickLoginAs(
                    context: context,
                    roleId: 'PACIENTE',
                    roleName: 'Paciente',
                    targetRoute: AppRoutes.homeClient,
                    userName: 'Josué',
                    userLastname: 'Quiroz',
                    email: 'paciente@mediapp.com',
                  ),
                ),
                const SizedBox(height: 10),
                _buildDemoButton(
                  context: context,
                  title: 'Ingresar como Médico',
                  subtitle: 'Dr. Carlos Mendoza • Pediatría (CMP-45892)',
                  icon: Icons.medical_services_outlined,
                  color: AppColors.accent,
                  onTap: () => _quickLoginAs(
                    context: context,
                    roleId: 'MEDICO',
                    roleName: 'Médico',
                    targetRoute: AppRoutes.homeDoctor,
                    userName: 'Carlos',
                    userLastname: 'Mendoza',
                    email: 'dr.mendoza@mediapp.com',
                    cmp: 'CMP-45892',
                    specialty: 'Pediatría',
                  ),
                ),
                const SizedBox(height: 10),
                _buildDemoButton(
                  context: context,
                  title: 'Ingresar como Administrador',
                  subtitle: 'Gestión clínica, métricas y usuarios',
                  icon: Icons.admin_panel_settings_outlined,
                  color: AppColors.primary_admin,
                  onTap: () => _quickLoginAs(
                    context: context,
                    roleId: 'ADMINISTRADOR',
                    roleName: 'Administrador',
                    targetRoute: AppRoutes.homeAdmin,
                    userName: 'Administrador',
                    userLastname: 'Clínico',
                    email: 'admin@mediapp.com',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}