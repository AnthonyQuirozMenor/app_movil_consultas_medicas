import 'package:flutter/material.dart';
import 'package:myfirstlove/src/common_widgets/custom_text_field.dart';
import 'package:myfirstlove/src/common_widgets/primary_button.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class AdminAmenityCreateContent extends StatelessWidget {
  final AdminAmenityCreateBloc? bloc;
  final AdminAmenityCreateState state;

  const AdminAmenityCreateContent(this.bloc, this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: state.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           
            const SizedBox(height: 40),
            
            // Campo para el nombre
            CustomTextField(
              label: 'Nombre de la comodidad',
              onChanged: (text) {
                bloc?.add(NameChanged(name: BlocFormItem(value: text)));
              },
              validator: (value) {
                return state.name.error;
              },
            ),
            const SizedBox(height: 20),

            // Campo para la descripción
            CustomTextField(
              label: 'Descripción (Opcional)',
              onChanged: (text) {
                bloc?.add(DescriptionChanged(description: BlocFormItem(value: text)));
              },
              // Sin validador porque es opcional
            ),
            const Spacer(), // Empuja el botón hacia abajo

            // Botón de envío
            PrimaryButton(
              text: 'Crear Comodidad',
              onPressed: () {
                if (state.formKey!.currentState!.validate()) {
                  bloc?.add(const FormSubmit());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}