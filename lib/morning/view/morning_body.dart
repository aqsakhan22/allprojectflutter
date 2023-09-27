import 'package:firebaseflutterproject/bflow/auto_suggest.dart';
import 'package:firebaseflutterproject/bflow/base_data_vm.dart';
import 'package:firebaseflutterproject/bflow/flows/app_state.dart';
import 'package:firebaseflutterproject/bflow/my_view_model.dart';
import 'package:firebaseflutterproject/bflow/search.dart';
import 'package:firebaseflutterproject/examples/search_filter.dart';
import 'package:firebaseflutterproject/morning/model/research.dart';
import 'package:firebaseflutterproject/morning/view/morning_list.dart';
import 'package:firebaseflutterproject/morning/view_model/morning_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class MorningBody extends StatefulWidget {
  const MorningBody({Key? key}) : super(key: key);

  @override
  State<MorningBody> createState() => _MorningBodyState();
}

class _MorningBodyState extends State<MorningBody> {
  final research = Research();
  final search = Search();
  var baseDataVM = BaseDataVM();

  bool isSearch = false;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    print('idd: ${AppState().getScreenId}');
    research.reportCategoryId = AppState().getScreenId.toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final instance = Provider.of<MorningVM>(context, listen: false);
      baseDataVM = Provider.of<BaseDataVM>(context, listen: false);
      instance.morningApi(research);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MorningVM>(
      builder: (context, model, child) {
        return (model.getState == ViewState.idle)
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    child: Container(
                      height: 4.5.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E8EA),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF707070),
                            blurRadius: 10,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Theme(
                        data: ThemeData(
                          inputDecorationTheme: const InputDecorationTheme(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                        ),
                        child: TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: controller,
                            onChanged: (text){
                            },
                            onSubmitted: (String value) async {
                              if (value.length >= 3) {
                                search.title = value;
                                search.createdAt = baseDataVM.date;
                                search.sectorId = baseDataVM.sectorIndex;
                                search.companyId = baseDataVM.companyIndex;
                                await model.searchApi(search);
                              }
                              isSearch = true;
                              setState(() {});
                            },
                            decoration:
                                const InputDecoration(labelText: 'Search'),
                          ),
                          suggestionsCallback: (pattern) async {

                            if (pattern.length >= 3) {
                              final autoSuggest = AutoSuggest();
                              autoSuggest.title = pattern;
                              List<AutoSuggestData> suggestionList = await model.autoSuggestApi(autoSuggest);
                              List<String> titles = suggestionList.map((data) => data.title.toString()).toList();
                              return titles;
                            } else {
                              return [];
                            }
                          },
                          itemBuilder: (context, value) {

                            return Text('$value');
                          },
                          onSuggestionSelected: (value) async{
                            print('OnonSuggestionSelected $value');
                            //  controller.text=value.toString();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),

                   ElevatedButton(onPressed: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context) => SearchFilter() ));
                   }, child: Text("testing search filter")),
                  Body(model: model, isSearch: isSearch, controller: controller),
                ],
              )
            : const Center(child: CircularProgressIndicator(color: Color(0xFF8E1017)));
      },
    );
  }
}

class Body extends StatelessWidget {
  const Body({Key? key, required this.model, required this.isSearch, required this.controller})
      : super(key: key);

  final MorningVM model;
  final bool isSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (model.getSearchState == ViewState.idle)
          ? MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: (isSearch)
                    ? model.mySearch.searchData?.length
                    : model.myResearch.researchData?.length,
                itemBuilder: (_, index) {
                  return (isSearch)
                      ?
                  (index == ((model.mySearch.searchData?.length ?? 0) - 1) && model.mySearch.searchData!.length >= 5)
                          ?
                  Center(
                              child: Column(
                                children: [
                                  (model.getPaginatedState == ViewState.idle)
                                      ? ElevatedButton(
                                          onPressed: () {
                                            model.mySearch.title = controller.text.toString();
                                            model.mySearch.page = model.mySearch.page + 1;
                                            model.searchPaginatedApi(model.mySearch);
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8E1017)),
                                          child: const Text('Load More'),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(color: Color(0xFF8E1017))),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            )
                          : MorningList(
                              searchData: model.mySearch.searchData?[index]
                    )
                      : (index == (model.myResearch.researchData?.length ?? 0) - 1)
                          ? Center(
                              child: Column(
                                children: [
                                  (model.getPaginatedState == ViewState.idle)
                                      ? ElevatedButton(
                                          onPressed: () {
                                            model.myResearch.page = model.myResearch.page! + 1;
                                            model.morningPaginationApi(model.myResearch);
                                          },
                                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8E1017)),
                                          child: const Text('Load More'),
                                        )
                                      : const Center(child: CircularProgressIndicator(
                                              color: Color(0xFF8E1017))),
                                  SizedBox(height: 5.h),
                                ],
                              ),
                            )
                          : MorningList(researchData: model.myResearch.researchData?[index]);
                },
              ),
            )
          : const Center(child: CircularProgressIndicator(color: Color(0xFF8E1017))),
    );
  }
}


