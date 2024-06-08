
class Customer {
  final int? id;
  final String name;
  final String email;
  final String mobile;
  final String? address;
  final String? image;
  final double? latitude;
  final double? longitude;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.mobile,
    this.address,
    this.image,
    this.latitude,
    this.longitude,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    mobile: json['mobile'],
    address: json['address'],
    image: json['image'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'mobile': mobile,
    'address': address,
    'image': image,
    'latitude': latitude,
    'longitude': longitude,
  };
}