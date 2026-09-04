import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/data/dataSource/local/MedicalLocalStore.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class DoctorsService {
  final Future<String> token;
  final MedicalLocalStore _localStore = MedicalLocalStore();

  DoctorsService(this.token);

  Future<Resource<List<Doctor>>> getDoctors({String? specialtyId}) async {
    try {
      final tokenValue = await token;
      final queryParams = specialtyId != null && specialtyId.isNotEmpty
          ? {'specialty_id': specialtyId}
          : null;
      final uri = Uri.http(ApiConfig.API_URL, '/doctors', queryParams);
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data as List).map((x) => Doctor.fromJson(x)).toList();
        return Success(list);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      return Success(_localStore.getDoctors(specialtyId: specialtyId));
    }
  }

  Future<Resource<Doctor>> getDoctorById(String id) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/doctors/$id');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Success(Doctor.fromJson(data));
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      final doc = _localStore.getDoctorById(id);
      if (doc != null) {
        return Success(doc);
      }
      return Error('Médico no encontrado');
    }
  }

  Future<Resource<List<DoctorSchedule>>> getDoctorSchedules(String doctorId) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/doctors/$doctorId/schedules');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list =
            (data as List).map((x) => DoctorSchedule.fromJson(x)).toList();
        return Success(list);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      return Success(_localStore.getDoctorSchedules(doctorId));
    }
  }

  Future<Resource<bool>> updateDoctorSchedule(DoctorSchedule schedule) async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/doctors/schedules/${schedule.id}');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };
      final body = json.encode(schedule.toJson());

      final response = await http.put(uri, headers: headers, body: body).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _localStore.updateDoctorSchedule(schedule);
        return Success(true);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      final result = _localStore.updateDoctorSchedule(schedule);
      return Success(result);
    }
  }
}
