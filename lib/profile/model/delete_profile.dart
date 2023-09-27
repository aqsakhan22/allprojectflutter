class DeleteProfile {
  DeleteProfile({this.success, this.message});

  dynamic success;
  dynamic message;

  factory DeleteProfile.fromJson(Map<String, dynamic> json) {
    return DeleteProfile(
      success: json['success'],
      message: json['msg'],
    );
  }
}
