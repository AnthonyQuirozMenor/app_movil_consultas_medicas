import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/data/dataSource/local/MedicalLocalStore.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AppointmentsService {
  final Future<String> token;
  final MedicalLocalStore _localStore = MedicalLocalStore();

  AppointmentsService(this.token);

  Future<Resource<List<Appointment>>> getAppointments({
    String? patientId,
    String? doctorId,
  }) async {
    try {
      final tokenValue = await token;
      final queryParams = <String, String>{};
      if (patientId != null && patientId.isNotEmpty) {
        queryParams['patient_id'] = patientId;
      }
      if (doctorId != null && doctorId.isNotEmpty) {
        queryParams['doctor_id'] = doctorId;
      }
      final uri = Uri.http(ApiConfig.API_URL, '/appointments',
          queryParams.isNotEmpty ? queryParams : null);
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data as List).map((x) => Appointment.fromJson(x)).toList();
        return Success(list);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      return Success(_localStore.getAppointments(
        patientId: patientId,
        doctorId: doctorId,
      ));
    }
  }

  Future<Resource<List<String>>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/appointments/available-slots', {
        'doctor_id': doctorId,
        'date': date.toIso8601String().split('T').first,
      });
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Success(List<String>.from(data));
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      return Success(_localStore.getAvailableSlots(doctorId, date));
    }
  }

  Future<Resource<Appointment>> createAppointment(Appointment appointment) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/appointments');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };
      final body = json.encode(appointment.toJson());

      final response = await http.post(uri, headers: headers, body: body).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final created = Appointment.fromJson(data);
        _localStore.bookAppointment(created);
        return Success(created);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      try {
        final created = _localStore.bookAppointment(appointment);
        return Success(created);
      } catch (err) {
        return Error(err.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  Future<Resource<bool>> cancelAppointment(String appointmentId) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/appointments/$appointmentId/cancel');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.put(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        _localStore.cancelAppointment(appointmentId);
        return Success(true);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      final res = _localStore.cancelAppointment(appointmentId);
      return Success(res);
    }
  }

  Future<Resource<bool>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) async {
    try {
      final tokenValue = await token;
      final uri =
          Uri.http(ApiConfig.API_URL, '/appointments/$appointmentId/reschedule');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };
      final body = json.encode({
        'appointment_date': newDate.toIso8601String(),
        'appointment_time': newTime,
      });

      final response = await http.put(uri, headers: headers, body: body).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        _localStore.rescheduleAppointment(appointmentId, newDate, newTime);
        return Success(true);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      try {
        final res = _localStore.rescheduleAppointment(appointmentId, newDate, newTime);
        return Success(res);
      } catch (err) {
        return Error(err.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  Future<Resource<bool>> attendAppointment({
    required String appointmentId,
    required String diagnosis,
    required String treatment,
    required String observations,
  }) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/appointments/$appointmentId/attend');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };
      final body = json.encode({
        'diagnosis': diagnosis,
        'treatment': treatment,
        'observations': observations,
      });

      final response = await http.put(uri, headers: headers, body: body).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        _localStore.attendAppointment(
          appointmentId: appointmentId,
          diagnosis: diagnosis,
          treatment: treatment,
          observations: observations,
        );
        return Success(true);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      final res = _localStore.attendAppointment(
        appointmentId: appointmentId,
        diagnosis: diagnosis,
        treatment: treatment,
        observations: observations,
      );
      return Success(res);
    }
  }
}
