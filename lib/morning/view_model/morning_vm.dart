
import 'package:firebaseflutterproject/bflow/api_client.dart';
import 'package:firebaseflutterproject/bflow/auto_suggest.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/bflow/search.dart';

import '../morning.dart';


class MorningVM extends MyViewModel {
  var myResearch = Research();
  var mySearch = Search();


  Future<void> morningApi(Research research) async {
    setState(ViewState.busy);
    try {
      myResearch = await MorningClient().researchReportApi(research);

      setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      return Future.error(e.toString());
    }
  }

  Future<void> morningPaginationApi(Research research) async {
    paginatedState(ViewState.busy);
    try {
      var newData = await MorningClient().researchReportApi(research);
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
}
