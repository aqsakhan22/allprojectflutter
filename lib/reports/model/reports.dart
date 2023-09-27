class Reports {
  Reports({
    this.success,
    this.message,
    this.filePath,
    this.imagePath,
    this.reportsItem,
  });

  dynamic success;
  dynamic message;
  dynamic filePath;
  dynamic imagePath;
  List<ReportsItem>? reportsItem;

  // post request parameters
  String? createdAt = "";
  String? sectorId = "";
  String? reportTypeId = "";
  String? reportCategoryId = "";
  int? page = 1;

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      success: json['success'],
      message: json['msg'],
      filePath: json['filepath'],
      imagePath: json['imagespath'],
      reportsItem: List<ReportsItem>.from(
          json['data'].map((e) => ReportsItem.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "sector_id": sectorId,
        "rpt_type_id": reportTypeId,
        "rpt_category_id": reportCategoryId,
        "page": page.toString(),
      };
}

class ReportsItem {
  ReportsItem({
    this.title,
    this.documentNewName,
    this.imageNewName,
    this.createdAt,
  });

  dynamic title;
  dynamic documentNewName;
  dynamic imageNewName;
  dynamic createdAt;

  factory ReportsItem.fromJson(Map<String, dynamic> json) {
    return ReportsItem(
      title: json['title'],
      documentNewName: json['doc_new_name'],
      imageNewName: json['img_new_name'],
      createdAt: json['created_at'],
    );
  }
}
