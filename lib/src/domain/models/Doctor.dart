class Doctor {
  final String id;
  final int? userId;
  final String name;
  final String lastname;
  final String cmp;
  final String specialtyId;
  final String specialtyName;
  final String email;
  final String phone;
  final String description;
  final int experienceYears;
  final double consultationFee;
  final String image;
  final double rating;
  final int reviewsCount;

  Doctor({
    required this.id,
    this.userId,
    required this.name,
    required this.lastname,
    required this.cmp,
    required this.specialtyId,
    required this.specialtyName,
    required this.email,
    required this.phone,
    required this.description,
    required this.experienceYears,
    required this.consultationFee,
    required this.image,
    this.rating = 4.9,
    this.reviewsCount = 38,
  });

  String get fullName => 'Dr. $name $lastname';

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"]?.toString() ?? '',
        userId: json["user_id"] != null
            ? int.tryParse(json["user_id"].toString())
            : null,
        name: json["name"] ?? '',
        lastname: json["lastname"] ?? '',
        cmp: json["cmp"] ?? '',
        specialtyId: json["specialty_id"]?.toString() ?? '',
        specialtyName: json["specialty_name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        description: json["description"] ?? '',
        experienceYears: json["experience_years"] != null
            ? int.tryParse(json["experience_years"].toString()) ?? 5
            : 5,
        consultationFee: json["consultation_fee"] != null
            ? (json["consultation_fee"] as num).toDouble()
            : 80.0,
        image: json["image"] ?? '',
        rating: json["rating"] != null
            ? (json["rating"] as num).toDouble()
            : 4.9,
        reviewsCount: json["reviews_count"] != null
            ? int.tryParse(json["reviews_count"].toString()) ?? 25
            : 25,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "lastname": lastname,
        "cmp": cmp,
        "specialty_id": specialtyId,
        "specialty_name": specialtyName,
        "email": email,
        "phone": phone,
        "description": description,
        "experience_years": experienceYears,
        "consultation_fee": consultationFee,
        "image": image,
        "rating": rating,
        "reviews_count": reviewsCount,
      };
}
