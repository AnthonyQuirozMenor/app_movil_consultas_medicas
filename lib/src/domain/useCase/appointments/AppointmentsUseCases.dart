import 'package:myfirstlove/src/domain/useCase/appointments/AttendAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/CancelAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/CreateAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/GetAppointmentsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/GetAvailableSlotsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/RescheduleAppointmentUseCase.dart';

class AppointmentsUseCases {
  final GetAppointmentsUseCase getAppointments;
  final GetAvailableSlotsUseCase getAvailableSlots;
  final CreateAppointmentUseCase createAppointment;
  final CancelAppointmentUseCase cancelAppointment;
  final RescheduleAppointmentUseCase rescheduleAppointment;
  final AttendAppointmentUseCase attendAppointment;

  AppointmentsUseCases({
    required this.getAppointments,
    required this.getAvailableSlots,
    required this.createAppointment,
    required this.cancelAppointment,
    required this.rescheduleAppointment,
    required this.attendAppointment,
  });
}
