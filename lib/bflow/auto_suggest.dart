class AutoSuggest {
  AutoSuggest({this.success, this.message, this.autoSuggestions});

  dynamic success;
  dynamic message;
  List<AutoSuggestData>? autoSuggestions;

  String? title;
  String? page = '1';

  factory AutoSuggest.fromJson(Map<String, dynamic> json) {
    return AutoSuggest(
      success: json['success'],
      message: json['msg'],
      autoSuggestions: List<AutoSuggestData>.from(
          json['data'].map((e) => AutoSuggestData.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'page': page,
    };
  }
}

class AutoSuggestData {
  AutoSuggestData({this.id, this.title, this.createdAt});

  dynamic id;
  dynamic title;
  dynamic createdAt;

  factory AutoSuggestData.fromJson(Map<String, dynamic> json) {
    return AutoSuggestData(
      id: json['id'],
      title: json['title'],
      createdAt: json['created_at'],
    );
  }
}
