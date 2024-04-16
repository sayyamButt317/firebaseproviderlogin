class InfoModel {
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? image;
  final String? address;

  InfoModel({
    this.firstname,
    this.lastname,
    this.email,
    this.image,
    this.address,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      address: json['address'],
      image: json['image'],
    );
  }
}
