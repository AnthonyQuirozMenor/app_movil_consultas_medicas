import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/AdminAmenitiesListItem.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListState.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class AdminAmenitiesListPage extends StatefulWidget {
  const AdminAmenitiesListPage({super.key});

  @override
  State<AdminAmenitiesListPage> createState() => _AdminAmenitiesListPageState();
}

class _AdminAmenitiesListPageState extends State<AdminAmenitiesListPage> {
  AdminAmenitiesListBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Despachamos el evento para obtener las comodidades
      _bloc?.add(const GetAmenities());
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<AdminAmenitiesListBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comodidades del Hotel',
        style: TextStyle(
          color: Colors.black, // El color del texto
          fontWeight: FontWeight.bold, // Pone el texto en negrita
        ),
         ),
         centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de comodidades
         Navigator.pushNamed(context, AppRoutes.adminAmenitiesCreate);
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocListener<AdminAmenitiesListBloc, AdminAmenitiesListState>(
        listener: (context, state) {
          final responseState = state.response;
          // Si la eliminación fue exitosa (devuelve bool), recargamos la lista
          if (responseState is Success && responseState.data is bool) {
            Fluttertoast.showToast(msg: 'Eliminación exitosa', toastLength: Toast.LENGTH_LONG);
            _bloc?.add(const GetAmenities());
          }
          if (responseState is Error) {
            Fluttertoast.showToast(msg: responseState.message, toastLength: Toast.LENGTH_LONG);
          }
        },
        child: BlocBuilder<AdminAmenitiesListBloc, AdminAmenitiesListState>(
          builder: (context, state) {
            final responseState = state.response;
            if (responseState is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (responseState is Success) {
              List<Amenities> amenities = responseState.data as List<Amenities>;
              return ListView.builder(
                itemCount: amenities.length,
                itemBuilder: (context, index) {
                  return AdminAmenitiesListItem(_bloc, amenities[index]);
                },
              );
            }
            return Container(); // Estado inicial o si no hay datos
          },
        ),
      ),
    );
  }
}