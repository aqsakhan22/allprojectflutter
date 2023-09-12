import 'package:json_annotation/json_annotation.dart';

part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse {
  @JsonKey(name: 'message')
  late final dynamic message;

  @JsonKey(name: 'status')
  late final int status;

  @JsonKey(name: 'data')
  late final dynamic data;

  GeneralResponse(this.data, {required this.message, required this.status});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      _$GeneralResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralResponseToJson(this);
}
