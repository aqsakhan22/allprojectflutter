import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '/network/interceptor/logging_interceptor.dart';
import '/network/response/general_response.dart';
import 'app_url.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: AppUrl.baseUrl) // Enter Your API Base URL
abstract class ApiService {
  factory ApiService(Dio dio, baseUrl) {
    dio.options = BaseOptions(
        receiveTimeout: 50000,
        connectTimeout: 50000,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        /* If needed headers */
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic RVhFSWRlYXMgSW50ZXJuYXRpb25hbCB3d3cuZXhlaWRlYXMubmV0'
        });

    dio.interceptors.add(Logging());
    return _ApiService(dio, baseUrl: AppUrl.baseUrl);
  }

  // APIs EndPoints Request Bodies without Token
  @POST('/login')
  Future<GeneralResponse> login(@Body() Map<String, dynamic> body);

  @POST('/signup')
  Future<GeneralResponse> signup(@Body() Map<String, dynamic> body);

  // APIs EndPoints Request Bodies with Token
  @POST('/dashboard')
  Future<GeneralResponse> dashboard(@Body() Map<String, dynamic> body);

  @POST('/forgetpassword')
  Future<GeneralResponse> forgetpassword(@Body() Map<String, dynamic> body);

  @POST('/logout')
  Future<GeneralResponse> logout();

  @POST('/updaterun')
  Future<GeneralResponse> updaterun(@Body() Map<String, dynamic> body);

  @POST('/startrun')
  Future<GeneralResponse> startrun(@Body() Map<String, dynamic> body);

  @POST('/finishrun')
  Future<GeneralResponse> finishrun(@Body() Map<String, dynamic> body);

  @POST('/runhistory')
  Future<GeneralResponse> runhistory();

  @POST('/feedback')
  Future<GeneralResponse> feedback(@Body() Map<String, dynamic> body);

  @POST('/sponsors')
  Future<GeneralResponse> sponsors(@Body() Map<String, dynamic> body);

  @POST('/clubs')
  Future<GeneralResponse> clubs(@Body() Map<String, dynamic> body);

  @POST('/clubmembers')
  Future<GeneralResponse> clubmembers(@Body() Map<String, dynamic> body);

  @POST('/joinclub')
  Future<GeneralResponse> joinclub(@Body() Map<String, dynamic> body);

  @POST('/videos')
  Future<GeneralResponse> videos(@Body() Map<String, dynamic> body);

  @POST('/addrunninggear')
  @MultiPart()
  Future<GeneralResponse> addrunninggear(
      @Part(name: 'Photo') File photo,
      @Part(name: 'Type') String Type,
      @Part(name: 'Brand') String Brand,
      @Part(name: 'YearOfMake') String YearOfMake,
      @Part(name: 'YearOfPurchased') String YearOfPurchased,

      );


  @POST('/runninggears')
  Future<GeneralResponse> runninggears(@Body() Map<String, dynamic> body);


  @POST('/updaterunninggear')
  @MultiPart()
  Future<GeneralResponse> updaterunninggear(
      @Part(name: 'RunningGear_ID') String RunningGear_ID,
      @Part(name: 'Photo') File Photo,
      @Part(name: 'Type') String Type,
      @Part(name: 'Brand') String Brand,
      @Part(name: 'YearOfMake') String YearOfMake,
      @Part(name: 'YearOfPurchased') String YearOfPurchased,
      );


  @POST('/runners')
  Future<GeneralResponse> runners(@Body() Map<String, dynamic> body);

  @POST('/friendrequest')
  Future<GeneralResponse> friendrequest(@Body() Map<String, dynamic> body);

  @POST('/friends')
  Future<GeneralResponse> friends(@Body() Map<String, dynamic> body);

  @POST('/runnersbylocations')
  Future<GeneralResponse> runnersbylocations(@Body() Map<String, dynamic> body);

  @POST('/clubevents')
  Future<GeneralResponse> clubevents(@Body() Map<String, dynamic> body);

  @POST('/clubprograms')
  Future<GeneralResponse> clubprograms(@Body() Map<String, dynamic> body);

  @POST('/clubprogramstatus')
  Future<GeneralResponse> clubprogramstatus(@Body() Map<String, dynamic> body);

  @POST('/clubeventstatus')
  Future<GeneralResponse> clubeventstatus(@Body() Map<String, dynamic> body);

  // APIs EndPoints Request with Token & MultiPart

  // Add Recipient
  @POST('/updateprofile')
  @MultiPart()
  Future<GeneralResponse> updateProfile(
    @Part(name: 'ProfilePhoto') File ProfilePhoto,
    @Part(name: 'FullName') String FullName,
    @Part(name: 'Designation') String Designation,
    @Part(name: 'Phone') String Phone,
    @Part(name: 'DateOfBirth') String DateOfBirth,
    @Part(name: 'Height') String Height,
    @Part(name: 'Weight') String Weight,
    @Part(name: 'Gender') String Gender,
    @Part(name: 'City') String City,
    @Part(name: 'State') String State,
    @Part(name: 'Country') String Country,
    @Part(name: 'Address') String Address,
    @Part(name: 'MeasurementUnit') String MeasurementUnit,
    @Part(name: 'RunBefore') String RunBefore,
    @Part(name: 'FastestTime') String FastestTime,
    @Part(name: 'AMTimeStart') String AMTimeStart,
    @Part(name: 'AMTimeEnd') String AMTimeEnd,
    @Part(name: 'PMTimeStart') String PMTimeStart,
    @Part(name: 'PMTimeEnd') String PMTimeEnd,
    @Part(name: 'PreferredDays') String PreferredDays,
    @Part(name: 'RunningProgram') String RunningProgram,
    @Part(name: 'Goal') String Goal,
    @Part(name: 'MembershipLevel') String MembershipLevel,
  );

  @POST('/allprograms')
  Future<GeneralResponse> allprograms(@Body() Map<String, dynamic> body);

  @POST('/chats')
  Future<GeneralResponse> chats(@Body() Map<String, dynamic> body);

  @POST('/chatpersonal')
  Future<GeneralResponse> chatpersonal(@Body() Map<String, dynamic> body);

  @POST('/chatstatus')
  Future<GeneralResponse> chatstatus(@Body() Map<String, dynamic> body);

  @POST('/chatsend')
  @MultiPart()
  Future<GeneralResponse> chatsendMedia(
    @Part(name: 'File') File media,
    @Part(name: 'Type') String Type,
    @Part(name: 'ChatInfo_ID') String ChatInfo_ID,
    @Part(name: 'Message') String Message,
  );

  @POST('/chatsend')
  @MultiPart()
  Future<GeneralResponse> chatsendMediaWithout(
    @Part(name: 'Type') String Type,
    @Part(name: 'ChatInfo_ID') String ChatInfo_ID,
    @Part(name: 'Message') String Message,
  );

  @POST('/forumsend')
  @MultiPart()
  Future<GeneralResponse> forumsendMedia(
    @Part(name: 'Attachment') File media,
    @Part(name: 'Forum_ID') String Forum_ID,
    @Part(name: 'Body') String Body,
  );
  @POST('/forumsend')
  @MultiPart()
  Future<GeneralResponse> forumsendMediaWithout(
    @Part(name: 'Forum_ID') String Forum_ID,
    @Part(name: 'Body') String Body,
  );

  @POST('/forums')
  Future<GeneralResponse> forums(@Body() Map<String, dynamic> body);

  @POST('/forumreplies')
  Future<GeneralResponse> forumreplies(@Body() Map<String, dynamic> body);

  @POST('/feedsociallist')
  Future<GeneralResponse> feedsociallist(@Body() Map<String, dynamic> body);

  @POST('/feeds')
  Future<GeneralResponse> feeds(@Body() Map<String, dynamic> body);

  @POST('/feedsend')
  @MultiPart()
  Future<GeneralResponse> feedsend(
    @Part(name: 'IsPinned') String IsPinned,
    @Part(name: 'Body') String Body,
    @Part(name: 'Attachment') File Attachment,
  );
  @POST('/feedsend')
  @MultiPart()
  Future<GeneralResponse> feedsendWithoutFile(
    @Part(name: 'IsPinned') String IsPinned,
    @Part(name: 'Body') String Body,
  );

  @POST('/feedcommentsend')
  Future<GeneralResponse> feedcommentsend(@Body() Map<String, dynamic> body);

  @POST('/feedsocial')
  Future<GeneralResponse> feedsocial(@Body() Map<String, dynamic> body);

  @POST('/feedstatus')
  Future<GeneralResponse> feedstatus(@Body() Map<String, dynamic> body);

  @POST('/chatclub')
  Future<GeneralResponse> chatclub(@Body() Map<String, dynamic> body);

  @POST('/notifications')
  Future<GeneralResponse> notifications(@Body() Map<String, dynamic> body);

  @POST('/clubactivate')
  Future<GeneralResponse> clubactivate(@Body() Map<String, dynamic> body);

  @POST('/myclubs')
  Future<GeneralResponse> myclubs(@Body() Map<String, dynamic> body);

  @POST('/feedpinstatus')
  Future<GeneralResponse> feedpinstatus(@Body() Map<String, dynamic> body);

  @POST('/quotes')
  Future<GeneralResponse> quotes(@Body() Map<String, dynamic> body);

  @POST('/audioqueues')
  Future<GeneralResponse> audioQueues(@Body() Map<String, dynamic> body);
}
