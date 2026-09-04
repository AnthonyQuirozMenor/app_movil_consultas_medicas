import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:path/path.dart';

class UsersService {
  Future<String> token;

  UsersService(this.token);

  Future<Resource<User>> update(int id, User user) async {
    try {
      print('METODO ACTUALIZAR SIN IMAGEN');
      // http://192.168.56.2:3000/users/5
      Uri url = Uri.http(ApiConfig.API_URL, '/users/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode({
        'name': user.name,
        'lastname': user.lastname,
        'phone': user.phone,
      });
      final response = await http.put(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(data);
        return Success(userResponse);
      } else {
        // ERROR
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }

Future<Resource<User>> updateImage(int id, User user, File file) async {
    print("id server:$id");
    try {
      print('METODO ACTUALIZAR CON IMAGEN');
      Uri url = Uri.http(ApiConfig.API_URL, '/users/upload/$id');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = await token;

      // 1. AÑADIR EL ARCHIVO (Esto ya estaba bien)
      request.files.add(http.MultipartFile(
          'file', 
          http.ByteStream(file.openRead().cast()), 
          await file.length(),
          filename: basename(file.path),
          contentType: MediaType('image', 'jpg') // O el tipo de imagen correcto
      ));
      // CORRECTO:
      if (user.name != null) {
        request.fields['name'] = user.name!;
      }
      if (user.lastname != null) {
        request.fields['lastname'] = user.lastname!;
      }
      if (user.phone != null) {
        request.fields['phone'] = user.phone!;
      }
      
      final response = await request.send();
      print('RESPONSE: ${response.statusCode}');
      
      final responseBody = await response.stream.transform(utf8.decoder).first;
      final data = json.decode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(data);
        return Success(userResponse);
      } else {
        print('ERROR RESPONSE BODY: $responseBody'); // Imprime el cuerpo del error para depurar
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error: $e');
      return Error(e.toString());
    }
  }
}