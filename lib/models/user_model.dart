class UserModel {
  final String displayName;
  final String email;
  final String? phoneNumber;
  final String? photoURL;

  UserModel({
    required this.displayName,
    required this.email,
    this.phoneNumber,
    this.photoURL,
  });
}