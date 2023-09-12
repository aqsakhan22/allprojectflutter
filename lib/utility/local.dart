class Local{

  String? countryCode;
  String? dialCode;
  String? countryName;

  Local({this.countryName, this.countryCode, this.dialCode});

  @override
  String toString() {
    return 'countryName: $countryName, countryCode: $countryCode, dialCode: $dialCode';
  }
}