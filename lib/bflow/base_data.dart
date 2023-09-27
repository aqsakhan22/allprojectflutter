class BaseData {
  BaseData({this.success, this.message, this.baseMetaData});

  dynamic success;
  dynamic message;
  BaseMetaData? baseMetaData;

  factory BaseData.fromJson(Map<String, dynamic> json) {
    return BaseData(
      success: json['success'],
      message: json['msg'],
      baseMetaData: json['data'] == null ? null : BaseMetaData.fromJson(json['data']),
    );
  }
}

class BaseMetaData {
  BaseMetaData(
      {this.sectors, this.companies, this.categories, this.reportTypes});

  List<Sector>? sectors;
  List<Company>? companies;
  List<Category>? categories;
  List<ReportType>? reportTypes;

  factory BaseMetaData.fromJson(Map<String, dynamic> json) {
    return BaseMetaData(
      sectors:
          List<Sector>.from(json['sectors'].map((x) => Sector.fromJson(x))),
      companies:
          List<Company>.from(json['companies'].map((x) => Company.fromJson(x))),
      categories: List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x))),
      reportTypes: List<ReportType>.from(
          json['report_types'].map((x) => ReportType.fromJson(x))),
    );
  }
}

class Sector {
  Sector({this.id, this.sectorName});

  dynamic id;
  dynamic sectorName;

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['id'],
      sectorName: json['sector_name'],
    );
  }
}

class Company {
  Company({this.id, this.symbol, this.companyName});

  dynamic id;
  dynamic symbol;
  dynamic companyName;

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      symbol: json['symbol'],
      companyName: json['company_name'],
    );
  }
}

class Category {
  Category({this.id, this.categoryTitle});

  dynamic id;
  dynamic categoryTitle;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryTitle: json['category_title'],
    );
  }
}

class ReportType {
  ReportType(
      {this.id, this.mainCatId, this.reportTypeTitle, this.isRestricted});

  dynamic id;
  dynamic mainCatId;
  dynamic reportTypeTitle;
  dynamic isRestricted;

  factory ReportType.fromJson(Map<String, dynamic> json) {
    return ReportType(
      id: json['id'],
      mainCatId: json['main_cat_id'],
      reportTypeTitle: json['report_type_title'],
      isRestricted: json['is_restricted'],
    );
  }
}
