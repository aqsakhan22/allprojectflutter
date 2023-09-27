class Search {
  dynamic success;
  dynamic isRestricted;
  dynamic message;
  dynamic filePath;
  dynamic imagePath;
  List<SearchData>? searchData;

  String title = '';
  String createdAt = '';
  String sectorId = '';
  String companyId = '';
  int page = 1;

  Search({
    this.success,
    this.isRestricted,
    this.message,
    this.filePath,
    this.imagePath,
    this.searchData,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        success: json['success'],
        isRestricted: json['is_restricted'],
        message: json['msg'],
        filePath: json['filepath'],
        imagePath: json['imagespath'],
        searchData: json['data'] == null
            ? []
            : List<SearchData>.from(
                json['data']!.map((x) => SearchData.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'created_at': createdAt,
      'sector_id': sectorId,
      'company_id': companyId,
      'page': page.toString(),
    };
  }
}

class SearchData {
  dynamic id;
  dynamic sectorId;
  dynamic companyId;

  dynamic title;
  dynamic description;
  dynamic docNewName;
  dynamic imgNewName;
  dynamic createdAt;
  AnalystDetail? analystDetail;
  CompanyDetail? companyDetail;
  SectorDetail? sectorDetail;
  CategoryDetail? categoryDetail;
  ReportTypeDetail? reportTypeDetail;

  SearchData({
    this.id,
    this.sectorId,
    this.companyId,
    this.title,
    this.description,
    this.docNewName,
    this.imgNewName,
    this.createdAt,
    this.analystDetail,
    this.companyDetail,
    this.sectorDetail,
    this.categoryDetail,
    this.reportTypeDetail,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        id: json['id'],
        sectorId: json['sector_id'],
        companyId: json['company_id'],
        title: json['title'],
        description: json['description'],
        docNewName: json['doc_new_name'],
        imgNewName: json['img_new_name'],
        createdAt: json['created_at'],
        analystDetail: json["analyst_detail"] == null
            ? null
            : AnalystDetail.fromJson(json['analyst_detail']),
        companyDetail: json['company_detail'] == null
            ? null
            : CompanyDetail.fromJson(json['company_detail']),
        sectorDetail: json['sector_detail'] == null
            ? null
            : SectorDetail.fromJson(json['sector_detail']),
        categoryDetail: json['category_detail'] == null
            ? null
            : CategoryDetail.fromJson(json['category_detail']),
        reportTypeDetail: json['report_type_detail'] == null
            ? null
            : ReportTypeDetail.fromJson(json['report_type_detail']),
      );
}

class AnalystDetail {
  dynamic analystName;

  AnalystDetail({
    this.analystName,
  });

  factory AnalystDetail.fromJson(Map<String, dynamic> json) => AnalystDetail(
        analystName: json['analyst_name'],
      );
}

class CategoryDetail {
  dynamic categoryTitle;

  CategoryDetail({
    this.categoryTitle,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        categoryTitle: json['category_title'],
      );
}

class CompanyDetail {
  dynamic companyName;

  CompanyDetail({
    this.companyName,
  });

  factory CompanyDetail.fromJson(Map<String, dynamic> json) => CompanyDetail(
        companyName: json['company_name'],
      );
}

class ReportTypeDetail {
  dynamic reportTypeTitle;

  ReportTypeDetail({
    this.reportTypeTitle,
  });

  factory ReportTypeDetail.fromJson(Map<String, dynamic> json) =>
      ReportTypeDetail(
        reportTypeTitle: json['report_type_title'],
      );
}

class SectorDetail {
  dynamic sectorName;

  SectorDetail({
    this.sectorName,
  });

  factory SectorDetail.fromJson(Map<String, dynamic> json) => SectorDetail(
        sectorName: json['sector_name'],
      );
}
