
import 'dart:convert';
import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;
class AuthService {

Future<Resource<AuthResponse>> login(String email, String password) async {
 
try {
 
 Uri url = Uri.http(ApiConfig.API_URL,'/auth/login');
 Map<String, String> headers = {'Content-Type': 'application/json',};
 String body = json.encode({
   'email': email,
   'password': password,
 });
 final response = await http.post(url, headers: headers, body: body);
 final data = json.decode(response.body);
 if (response.statusCode == 200 || response.statusCode == 201) {
   AuthResponse authResponse = AuthResponse.fromJson(data);
   return Success(authResponse);
 } else {
   return Error(ListToString(data['message']));
 }

}catch (e) {
  print('Error:$e');
  return Error(e.toString());

}
}

Future<Resource<AuthResponse>> register(User user) async {
 
try {
 
 Uri url = Uri.http(ApiConfig.API_URL,'/auth/register');
 Map<String, String> headers = {'Content-Type': 'application/json',};
 String body = json.encode(user.toJson());

 print(headers);
 print(body);

 final response = await http.post(url, headers: headers, body: body);
 final data = json.decode(response.body);
 if (response.statusCode == 200 || response.statusCode == 201) {
   AuthResponse authResponse = AuthResponse.fromJson(data);
   return Success(authResponse);
 } else {
   return Error(ListToString(data['message']));
 }

}catch (e) {
  print('Error:$e');
  return Error(e.toString());

}
}
}