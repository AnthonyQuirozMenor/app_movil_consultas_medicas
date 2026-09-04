import 'dart:convert';

import 'package:myfirstlove/src/data/api/ApiConfig.dart';
import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/utils/ListToString.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:http/http.dart' as http;

class AmenitiesService {
  final Future<String> token;

  AmenitiesService(this.token);

   Future<Resource<List<Amenities>>> getAmenities() async {
    try {
      Uri url = Uri.http(ApiConfig.API_URL, '/amenities');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.get(url, headers: headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Amenities> amenities = Amenities.fromJsonList(data);
        return Success(amenities);
      } else {
        return Error(ListToString(data['message']));
      }
    } catch (e) {
      print('Error en AmenitiesService getAmenities: $e');
      return Error(e.toString());
    }
  }
//servicio para eliminar un amenities
Future<Resource<bool>> delete(int id) async{
  print('Eliminando amenity con id: $id');
  try{
     Uri url = Uri.http(ApiConfig.API_URL, '/amenities/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Success(true);
      } else {
          final data = json.decode(response.body);
        return Error(ListToString(data['message']));
      }                      
  }catch (e) {
      print('Error en AmenitiesService getAmenities: $e');
      return Error(e.toString());

    }

}

//servicio para crear un amenities
Future<Resource<Amenities>> create(Amenities amenity) async{
  try{
     Uri url = Uri.http(ApiConfig.API_URL, '/amenities');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode(amenity.toJson());

      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Amenities amenitiesResponse = Amenities.fromJson(data);
        return Success(amenitiesResponse);
      } else {
        return Error(ListToString(data['message']));
      }                      
  }catch (e) {
      print('Error en AmenitiesService create: $e');
      return Error(e.toString());

    }

}
//servicio para crear un amenities
Future<Resource<Amenities>> update(int id, Amenities amenity) async{
  try{
     Uri url = Uri.http(ApiConfig.API_URL, '/amenities/$id');
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": await token
      };
      String body = json.encode(amenity.toJson());

      final response = await http.put(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Amenities amenitiesResponse = Amenities.fromJson(data);
        return Success(amenitiesResponse);
      } else {
        return Error(ListToString(data['message']));
      }                      
  }catch (e) {
      print('Error en AmenitiesService update: $e');
      return Error(e.toString());

    }

}


}