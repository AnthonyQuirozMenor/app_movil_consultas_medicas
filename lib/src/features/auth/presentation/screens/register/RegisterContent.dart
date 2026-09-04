
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/src/common_widgets/custom_text_field.dart';
import 'package:myfirstlove/src/common_widgets/primary_button.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterBloc.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterEvent.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class RegisterContent extends StatelessWidget {
  final RegisterBloc? bloc;
  final RegisterState state;

  const RegisterContent(this.bloc, this.state, {super.key});

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
                Text(
                  'Registro de Paciente',
                  style: AppTextStyles.screenTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Crea tu cuenta en MediApp para agendar citas con especialistas.',
                  style: AppTextStyles.body.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),


                // Nombre
                CustomTextField(
                  label: 'Nombre',
                  onChanged: (value) {
                    bloc?.add(RegisterNameChanged(name: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.name.error,
                ),
                const SizedBox(height: 16),
                //Apellidos
                CustomTextField(
                  label: 'Apellidos',
                  onChanged: (value) {
                    bloc?.add(RegisterLastNameChanged(lastname: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.lastname.error,
                ),
                
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  label: 'Email',
                  onChanged: (value) {
                    bloc?.add(RegisterEmailChanged(email: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.email.error,
                ),
                const SizedBox(height: 16),

                // Password
                CustomTextField(
                  label: 'Password',
                  isPassword: true,
                  onChanged: (value) {
                    bloc?.add(RegisterPasswordChanged(password: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.password.error,
                ),
                const SizedBox(height: 16),

                // Repeat Password
                CustomTextField(
                  label: 'Repetir Password',
                  isPassword: true,
                  onChanged: (value) {
                    bloc?.add(RegisterConfirmPasswordChanged(confirmPassword: BlocFormItem(value: value)));
                  },
                  validator: (value) => state.confirmPassword.error,
                ),
                const SizedBox(height: 32),

                // Botón de registro
                PrimaryButton(
                  text: 'Registrarse',
                  onPressed: () {
                    if (state.formKey!.currentState!.validate()) {
                      bloc?.add(const RegisterSubmitted());
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Formulario inválido',
                        toastLength: Toast.LENGTH_LONG,
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Link para iniciar sesión
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya estás registrado?',
                      style: AppTextStyles.body.copyWith(fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                      },
                      child: const Text(
                        'Inicia sesión aquí',
                        style: AppTextStyles.textLink,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}