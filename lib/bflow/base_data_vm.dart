
import 'package:firebaseflutterproject/bflow/api_client.dart';
import 'package:firebaseflutterproject/bflow/auto_suggest.dart';
import 'package:firebaseflutterproject/bflow/base_data.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/bflow/navigation/navigation_client.dart';
import 'package:firebaseflutterproject/bflow/search.dart';

import '../../morning/morning.dart';

class BaseDataVM extends MyViewModel {
  var baseData = BaseData();
  var mySearch = Search();
  var myResearch = Research();

  String _date = '';
  String _sector = '';
  String _company = '';
  String _sectorIndex = '';
  String _companyIndex = '';

  String get date => _date;

  String get sector => _sector;

  String get company => _company;

  String get sectorIndex => _sectorIndex;

  String get companyIndex => _companyIndex;

  Future<void> callApi() async {
    setState(ViewState.busy);
    try {
      baseData = await NavigationClient().baseDataApi();
      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<void> reportsApi(Research research) async {
    setReportsState(ViewState.busy);
    try {
      myResearch = await ApiClient().reportsApi(research);
      setReportsState(ViewState.idle);
    } catch (e) {
      setReportsState(ViewState.idle);
      print(e.toString());
      throw Future.error(e.toString());
    }
  }

  Future<void> reportsPaginationApi(Research research) async {
    paginatedState(ViewState.busy);
    try {
      var newData = await ApiClient().reportsApi(research);
      myResearch.researchData?.addAll(newData.researchData!);
      paginatedState(ViewState.idle);
    } catch (e) {
      paginatedState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<List<AutoSuggestData>> autoSuggestApi(AutoSuggest autoSuggest) async {
    try {
      var response = await ApiClient().autoSuggestApi(autoSuggest);
      return response.autoSuggestions ?? [];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<Search> searchApi(Search search) async {
    setSearchState(ViewState.busy);
    try {
      mySearch = await ApiClient().searchApi(search);
      setSearchState(ViewState.idle);
      return mySearch;
    } catch (e) {
      setSearchState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<void> searchPaginatedApi(Search search) async {
    paginatedState(ViewState.busy);
    try {
      var newData = await ApiClient().searchApi(search);
      mySearch.searchData?.addAll(newData.searchData!);
      paginatedState(ViewState.idle);
    } catch (e) {
      paginatedState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  void updateDate(String date) {
    _date = date;
    notifyListeners();
  }

  void updateSector(String value) {
    _sector = value;
    notifyListeners();
  }

  void updateCompany(String value) {
    _company = value;
    notifyListeners();
  }

  void updateSectorIndex(String value) {
    _sectorIndex = value;
    notifyListeners();
  }

  void updateCompanyIndex(String value) {
    _companyIndex = value;
    notifyListeners();
  }
}
