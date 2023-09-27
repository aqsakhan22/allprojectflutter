class UpdateProfile {
  UpdateProfile({this.success, this.message, this.email, this.mobileNumber});

  dynamic success;
  dynamic message;
  String? email;
  String? mobileNumber;

  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
      success: json['success'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'mobile_number': mobileNumber,
    };
  }
}
