class Specialty {
  final String id;
  final String name;
  final String description;
  final String icon;
  final double basePrice;
  final int doctorsCount;

  Specialty({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.basePrice = 70.0,
    this.doctorsCount = 1,
  });

  factory Specialty.fromJson(Map<String, dynamic> json) => Specialty(
        id: json["id"]?.toString() ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        icon: json["icon"] ?? 'medical_services',
        basePrice: json["base_price"] != null
            ? (json["base_price"] as num).toDouble()
            : 70.0,
        doctorsCount: json["doctors_count"] != null
            ? int.tryParse(json["doctors_count"].toString()) ?? 1
            : 1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "base_price": basePrice,
        "doctors_count": doctorsCount,
      };
}
