class Profile {
  Profile({
    this.success,
    this.profileData,
    this.message,
  });

  bool? success;
  ProfileData? profileData;
  String? message;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      success: json['success'],
      profileData: ProfileData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class ProfileData {
  ProfileData({
    this.name,
    this.email,
    this.mobileNumber,
  });

  String? name;
  dynamic email;
  dynamic mobileNumber;

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
    );
  }
}
