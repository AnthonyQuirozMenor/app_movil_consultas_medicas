import 'dart:convert';

Amenities amenityFromJson(String str) => Amenities.fromJson(json.decode(str));

String amenityToJson(Amenities data) => json.encode(data.toJson());

class Amenities {
    int? id; 
    String name;
    String? description;

    Amenities({
        this.id,
        required this.name,
        this.description,
    });

    
    static List<Amenities> fromJsonList(List<dynamic> jsonList) {
        List<Amenities> toList = [];
        for (var item in jsonList) {
            Amenities amenity = Amenities.fromJson(item);
            toList.add(amenity);
        }
        return toList;
    }

   
    factory Amenities.fromJson(Map<String, dynamic> json) => Amenities(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    
    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id; 
    }
    data['name'] = name;
    if (description != null) {
      data['description'] = description;
    }
    return data;
}
}