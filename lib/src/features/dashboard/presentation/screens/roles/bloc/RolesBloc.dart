import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/bloc/RolesEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/bloc/RolesState.dart';

class RolesBloc extends Bloc<RolesEvent, RolesState>{
  AuthUseCases authUseCases;


  RolesBloc(this.authUseCases):super(RolesState()) {
  on<GetRolesList>(_onGetRolesList);
  }

 Future<void> _onGetRolesList(
      GetRolesList event, Emitter<RolesState> emit) async {
    AuthResponse? authResponse = 
    await authUseCases.getUserSessionUseCase.run();
    emit(state.copyWith(roles: authResponse?.user.roles));
  } 

}