class User {
  String? id,
      firstName,
      lastName,
      phoneNumber,
      profilePhoto,
      email,
      defaultTrusty;
  Map? trusties, emergencyContacts;
  bool? isAdmin, isBlocked;
  Map? lastLocation;
  List? reviewedProducts;

  User({
      this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.trusties,
      this.profilePhoto,
      this.emergencyContacts,
      this.isAdmin,
      this.isBlocked,
      this.email,
      this.defaultTrusty});

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'trusties': trusties,
        'profilePhoto': profilePhoto,
        'emergencyContacts': emergencyContacts,
        'isAdmin': isAdmin,
        'isBlocked': isBlocked,
        'email': email,
        'defaultTrusty': defaultTrusty,
        'reviewedProducts': reviewedProducts
      };

  User.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        firstName = jsonData['firstName'],
        lastName = jsonData['lastName'],
        phoneNumber = jsonData['phoneNumber'],
        profilePhoto = jsonData['profilePhoto'],
        trusties = jsonData['trusties'],
        emergencyContacts = jsonData['emergencyContacts'],
        isAdmin = jsonData['isAdmin'] ?? false,
        isBlocked = jsonData['isBlocked'] ?? false,
        email = jsonData['email'],
        defaultTrusty = jsonData['defaultTrusty'] ?? '',
        lastLocation = jsonData['lastLocation'] ?? {},
        reviewedProducts = jsonData['reviewedProducts'];
}
