import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/RegisterContent.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterBloc.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterState.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
RegisterBloc? _bloc;

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(
     appBar: AppBar(
      title: const Text('Atras'),
      backgroundColor: Colors.transparent,
      elevation: 0,
     ),
     body:BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
         final responseState = state.response;
        if(responseState is Error){
          Fluttertoast.showToast(
            msg: responseState.message,
            toastLength: Toast.LENGTH_LONG );

        } else if(responseState is Success){
          Fluttertoast.showToast(
              msg: responseState.data.toString(),
              toastLength: Toast.LENGTH_LONG,
            );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login, // Siguiente paso: el cuestionario
            (route) => false, // Elimina el stack de autenticación
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state){
        if(state.response is Loading){
         return Stack(
          children: [
            RegisterContent(_bloc,state),
            const Center(child: CircularProgressIndicator())
          ],
         );
        }
        return RegisterContent(_bloc,state);
      }
      
      )

    )
    );
      

  
  }
}