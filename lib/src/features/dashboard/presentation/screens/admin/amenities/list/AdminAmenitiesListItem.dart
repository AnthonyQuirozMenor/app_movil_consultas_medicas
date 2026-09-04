import 'package:flutter/material.dart';
import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListEvent.dart';

class AdminAmenitiesListItem extends StatelessWidget {
  final AdminAmenitiesListBloc? bloc;
  final Amenities? amenity;

  const AdminAmenitiesListItem(this.bloc, this.amenity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(amenity?.name ?? ''),
      subtitle: Text(amenity?.description ?? ''),
      trailing: Wrap(
        direction: Axis.horizontal,
        children: [
          // Botón para editar
          IconButton(
            onPressed: () {
              // Navegar a la pantalla de actualización de comodidades
              // Navigator.pushNamed(context, 'admin/amenity/update', arguments: amenity);
            },
            icon: const Icon(Icons.edit, color: Colors.blue),
          ),
          // Botón para eliminar
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar Eliminación'),
                    content: Text(
                        '¿Estás seguro de que deseas eliminar "${amenity?.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          bloc?.add(DeleteAmenity(id: amenity!.id!));
                          Navigator.of(context).pop();
                        },
                        child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}