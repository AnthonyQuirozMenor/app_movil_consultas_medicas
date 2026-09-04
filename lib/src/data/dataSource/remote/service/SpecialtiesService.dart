import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/data/dataSource/local/MedicalLocalStore.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class SpecialtiesService {
  final Future<String> token;
  final MedicalLocalStore _localStore = MedicalLocalStore();

  SpecialtiesService(this.token);

  Future<Resource<List<Specialty>>> getSpecialties() async {
    try {
      final tokenValue = await token;
      final uri = Uri.http(ApiConfig.API_URL, '/specialties');
      final headers = {
        'Content-Type': 'application/json',
        if (tokenValue.isNotEmpty) 'Authorization': 'Bearer $tokenValue',
      };

      final response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: 4),
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final list = (data as List).map((x) => Specialty.fromJson(x)).toList();
        return Success(list);
      } else {
        final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }
    } catch (_) {
      // Fallback a almacenamiento local estructurado
      return Success(_localStore.getSpecialties());
    }
  }
}
