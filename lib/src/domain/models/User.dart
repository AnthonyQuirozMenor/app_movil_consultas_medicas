import 'package:myfirstlove/src/domain/models/Role.dart';

class User {
    int? id;
    String name;
    String lastname;
    String? email;
    String phone;
    String? password;
    String? image;
    String? notificationToken;
    List<Role>? roles;
    // Campos opcionales para perfil médico y paciente
    String? dni;
    String? birthDate;
    String? gender;
    String? address;
    String? cmp; // Colegio Médico del Perú
    String? specialty;
    int? experienceYears;
    double? consultationFee;
    String? description;

    User({
        this.id,
        required this.name,
        required this.lastname,
        this.email,
        required this.phone,
        this.password,
        this.image,
        this.notificationToken,
        this.roles,
        this.dni,
        this.birthDate,
        this.gender,
        this.address,
        this.cmp,
        this.specialty,
        this.experienceYears,
        this.consultationFee,
        this.description,
    });
 
    // Metodo que construye la respuesta del backend
    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json["id"] : (json["id"] != null ? int.tryParse(json["id"].toString()) : 0),
        name: json["name"] ?? '',
        lastname: json["lastname"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        password: json["password"] ?? '',
        image: json["image"] ?? '',
        notificationToken: json["notification_token"] ?? '',
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
            : [],
        dni: json["dni"],
        birthDate: json["birth_date"] ?? json["birthDate"],
        gender: json["gender"],
        address: json["address"],
        cmp: json["cmp"],
        specialty: json["specialty"],
        experienceYears: json["experience_years"] is int
            ? json["experience_years"]
            : (json["experience_years"] != null ? int.tryParse(json["experience_years"].toString()) : null),
        consultationFee: json["consultation_fee"] is num
            ? (json["consultation_fee"] as num).toDouble()
            : (json["consultation_fee"] != null ? double.tryParse(json["consultation_fee"].toString()) : null),
        description: json["description"],
    );

    // Metodo que envia la informacion al backend
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data["name"] = name;
      data["lastname"] = lastname;  
      data["email"] = email;
      data["phone"] = phone;
      if (password != null && password != '') {
        data["password"] = password;
      }
      if (image != null && image != '') {
        data["image"] = image;
      }
      if (notificationToken != null && notificationToken != '') {
        data["notification_token"] = notificationToken;
      }
      if (id != null) {
        data["id"] = id;
      }
      data["roles"] = roles != null
          ? List<dynamic>.from(roles!.map((x) => x.toJson()))
          : [];
      if (dni != null) data["dni"] = dni;
      if (birthDate != null) data["birth_date"] = birthDate;
      if (gender != null) data["gender"] = gender;
      if (address != null) data["address"] = address;
      if (cmp != null) data["cmp"] = cmp;
      if (specialty != null) data["specialty"] = specialty;
      if (experienceYears != null) data["experience_years"] = experienceYears;
      if (consultationFee != null) data["consultation_fee"] = consultationFee;
      if (description != null) data["description"] = description;
      
      return data;
    }
}



