class UserData {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? image;
  final String? address;

  UserData({
    this.firstname,
    this.lastname,
    this.email,
    this.image,
    this.address,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      address: json['address'],
      image: json['image'],
    );
  }
}
