import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/AdminAmenityCreateContent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateState.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListEvent.dart';

class AdminAmenityCreatePage extends StatefulWidget {
  const AdminAmenityCreatePage({super.key});

  @override
  State<AdminAmenityCreatePage> createState() => _AdminAmenityCreatePageState();
}

class _AdminAmenityCreatePageState extends State<AdminAmenityCreatePage> {
  AdminAmenityCreateBloc? _bloc;

  @override
  void initState() {
    super.initState();
    // Inicializamos el BLoC y le pasamos el formKey
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc?.add(const AdminAmenityCreateInitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<AdminAmenityCreateBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Comodidad'),
        centerTitle: true,
      ),
      body: BlocListener<AdminAmenityCreateBloc, AdminAmenityCreateState>(
        listener: (context, state) {
          final responseState = state.response;
          if (responseState is Success) {
            // Cuando se crea con éxito, actualizamos la lista de la pantalla anterior
            context.read<AdminAmenitiesListBloc>().add(const GetAmenities());
            _bloc?.add(const ResetForm());
            Fluttertoast.showToast(
                msg: 'La comodidad se creó correctamente',
                toastLength: Toast.LENGTH_LONG);
            Navigator.pop(context);
          } else if (responseState is Error) {
            Fluttertoast.showToast(
                msg: responseState.message, toastLength: Toast.LENGTH_LONG);
          }
        },
        child: BlocBuilder<AdminAmenityCreateBloc, AdminAmenityCreateState>(
          builder: (context, state) {
            final responseState = state.response;
            // Mostramos un loader mientras se envía el formulario
            if (responseState is Loading) {
              return Stack(
                children: [
                  AdminAmenityCreateContent(_bloc, state),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }
            return AdminAmenityCreateContent(_bloc, state);
          },
        ),
      ),
    );
  }
}