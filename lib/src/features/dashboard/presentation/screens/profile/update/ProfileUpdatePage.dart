import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/bloc/HomeBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/bloc/HomeEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/profile/update/ProfileUpdateContent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/profile/update/bloc/ProfileUpdateState.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  ProfileUpdateBloc? _bloc;
  User? user;

  @override
  void initState() {
    // UNA VEZ
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // PANTALLA CARGADA
      _bloc?.add(ProfileUpdateInitEvent(user: user));
    });
  }

@override
Widget build(BuildContext context) {
  // DESPUES DEL INIT // VARIAS VECES
  _bloc = BlocProvider.of<ProfileUpdateBloc>(context);

 final args = ModalRoute.of(context)?.settings.arguments;
user = args is User ? args : null;

print('Usuario recibido en ProfileUpdatePage: ${user?.toJson()}');


  if (args == null) {
    print('No se recibió ningún argumento User.');
  } else {
    print('Argumento User recibido correctamente.');
  }

  // Asegura el cast solo si no es null
  user = args is User ? args : null;

  return Scaffold(
    body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
      listener: (context, state) {
        final responseState = state.response;
        if (responseState is Error) {
          Fluttertoast.showToast(
            msg: responseState.message,
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (responseState is Success) {
          User user = responseState.data as User;
          _bloc?.add(ProfileUpdateUpdateUserSession(user: user));
          Future.delayed(const Duration(seconds: 1), () {
            context.read<HomeBloc>().add(ProfileInfoGetUser());
          });
          Fluttertoast.showToast(
            msg: 'Actualización exitosa',
            toastLength: Toast.LENGTH_LONG,
          );
        }
      },
      child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
        builder: (context, state) {
          final responseState = state.response;
          if (responseState is Loading) {
            return Stack(
              children: [
                ProfileUpdateContent(_bloc, state, user),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }
          return ProfileUpdateContent(_bloc, state, user);
        },
      ),
    ),
  );
}

}