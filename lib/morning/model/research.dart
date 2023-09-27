// class Research {
//   Research(
//       {this.success,
//       this.message,
//       this.filePath,
//       this.imagePath,
//       this.researchData});
//
//   dynamic success;
//   dynamic message;
//   dynamic filePath;
//   dynamic imagePath;
//   List<ResearchData>? researchData = [];
//
//   // body params
//   String? createdAt = "";
//   String? sectorId = "";
//   String? reportTypeId = "";
//   String? reportCategoryId = "";
//   int? page = 1;
//
//   factory Research.fromJson(Map<String, dynamic> json) {
//     return Research(
//         success: json['success'],
//         message: json['msg'],
//         filePath: json['filepath'],
//         imagePath: json['imagespath'],
//         researchData: List<ResearchData>.from(
//             json['data'].map((x) => ResearchData.fromJson(x))));
//   }
//
//   Map<String, dynamic> toJson() => {
//         "created_at": createdAt,
//         "sector_id": sectorId,
//         "rpt_type_id": reportTypeId,
//         "rpt_category_id": reportCategoryId,
//         "page": page.toString(),
//       };
// }
//
// class ResearchData {
//   ResearchData({
//     this.title,
//     this.description,
//     this.documentFile,
//     this.imageFile,
//     this.createdAt,
//   });
//
//   dynamic title;
//   dynamic description;
//   dynamic documentFile;
//   dynamic imageFile;
//   DateTime? createdAt;
//
//   factory ResearchData.fromJson(Map<String, dynamic> json) {
//     return ResearchData(
//       title: json['title'],
//       description: json['description'],
//       documentFile: json['doc_new_name'],
//       imageFile: json['img_new_name'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }

class Research {
  bool? success;
  int? isRestricted;
  String? msg;
  String? filePath;
  String? imagePath;
  int? count;
  List<ResearchData>? researchData;

  // body params

  String? createdAt = "";
  String? sectorId = "";
  String? reportTypeId = "";
  String? reportCategoryId = "";
  int? page = 1;

  Research({
    this.success,
    this.isRestricted,
    this.msg,
    this.filePath,
    this.imagePath,
    this.count,
    this.researchData,
  });

  factory Research.fromJson(Map<String, dynamic> json) => Research(
        success: json["success"],
        isRestricted: json["is_restricted"],
        msg: json["msg"],
        filePath: json["filepath"],
        imagePath: json["imagespath"],
        count: json["count"],
        researchData: json["data"] == null
            ? []
            : List<ResearchData>.from(
                json["data"]!.map((x) => ResearchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'created_at': createdAt,
        'sector_id': sectorId,
        'rpt_type_id': reportTypeId,
        'rpt_category_id': reportCategoryId,
        'page': page.toString(),
      };
}

class ResearchData {
  int? id;
  int? sectorId;
  int? companyId;
  int? rptAnalystId;
  String? title;
  String? description;
  String? documentFile;
  String? imageFile;
  String? createdAt;
  AnalystDetail? analystDetail;
  CompanyDetail? companyDetail;
  SectorDetail? sectorDetail;
  CategoryDetail? categoryDetail;
  ReportTypeDetail? reportTypeDetail;

  ResearchData({
    this.id,
    this.sectorId,
    this.companyId,
    this.rptAnalystId,
    this.title,
    this.description,
    this.documentFile,
    this.imageFile,
    this.createdAt,
    this.analystDetail,
    this.companyDetail,
    this.sectorDetail,
    this.categoryDetail,
    this.reportTypeDetail,
  });

  factory ResearchData.fromJson(Map<String, dynamic> json) => ResearchData(
        id: json["id"],
        sectorId: json["sector_id"],
        companyId: json["company_id"],
        rptAnalystId: json["rpt_analyst_id"],
        title: json["title"],
        description: json["description"],
        documentFile: json["doc_new_name"],
        imageFile: json["img_new_name"],
        createdAt: json["created_at"],
        analystDetail: json["analyst_detail"] == null
            ? null
            : AnalystDetail.fromJson(json["analyst_detail"]),
        companyDetail: json["company_detail"] == null
            ? null
            : CompanyDetail.fromJson(json["company_detail"]),
        sectorDetail: json["sector_detail"] == null
            ? null
            : SectorDetail.fromJson(json["sector_detail"]),
        categoryDetail: json["category_detail"] == null
            ? null
            : CategoryDetail.fromJson(json["category_detail"]),
        reportTypeDetail: json["report_type_detail"] == null
            ? null
            : ReportTypeDetail.fromJson(json["report_type_detail"]),
      );
}

class AnalystDetail {
  String? analystName;

  AnalystDetail({
    this.analystName,
  });

  factory AnalystDetail.fromJson(Map<String, dynamic> json) => AnalystDetail(
        analystName: json["analyst_name"],
      );
}

class CategoryDetail {
  String? categoryTitle;

  CategoryDetail({
    this.categoryTitle,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        categoryTitle: json["category_title"],
      );
}

class CompanyDetail {
  String? companyName;

  CompanyDetail({
    this.companyName,
  });

  factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
        companyName: json["company_name"],
      );
}

class ReportTypeDetail {
  String? reportTypeTitle;
  int? isRestricted;

  ReportTypeDetail({
    this.reportTypeTitle,
    this.isRestricted,
  });

  factory ReportTypeDetail.fromJson(Map<String, dynamic> json) =>
      ReportTypeDetail(
        reportTypeTitle: json["report_type_title"],
        isRestricted: json["is_restricted"],
      );
}

class SectorDetail {
  String? sectorName;

  SectorDetail({
    this.sectorName,
  });

  factory SectorDetail.fromJson(Map<String, dynamic> json) => SectorDetail(
        sectorName: json["sector_name"],
      );
}
