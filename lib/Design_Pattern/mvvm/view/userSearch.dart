import 'package:firebaseflutterproject/Design_Pattern/mvvm/MyViewModel.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/model/user.dart';
import 'package:firebaseflutterproject/Design_Pattern/mvvm/viewmodel/userViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  final TextEditingController _typeAheadController = TextEditingController();
  List showSelectedList=StateService.states;
  List<UserModel>  searchData=[];
  bool isSearch=false;
  FocusNode searchFocusNode = FocusNode();
  int perPage  = 5;
  int present = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final instance = Provider.of<UserViewModel>(context, listen: false);
    // instance.usersApi(users);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     instance.notifyListeners();

      //  searchData.addAll(instance.usersList.users.getRange(present,present +  perPage));
      // present = present + perPage;
      //   setState(() {
      //
      //   });
     // instance.usersList.users.add(UserModel(
     //     id: 11, name: 'aqsa', username: 'aqsa khan', email: 'aqsa@gmail.com',
     // ));


    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Search"),
      ),
      body:   Consumer<UserViewModel>(
          builder: (context, model, child) {

            return  (model.state == ViewState.idle) ?
            Column(
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Back ${isSearch} ${searchData.isEmpty}")),

                Padding(padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                  child:    TypeAheadField(

                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(labelText: 'State'),
                        controller: this._typeAheadController,
                        focusNode: searchFocusNode,
                        onSubmitted: (value){
                          print("on submitted is  ${searchData}");
                          isSearch=true;
                        searchData=  model.usersList.users.where((element) => element.name!.toLowerCase().toString().contains(value.toLowerCase().toString())).toList();
                          setState(() {

                          });
                          print("on submitted after is  ${searchData}");

                          searchFocusNode.unfocus();
                        },
                        onChanged: (value){
                          print("on changec ${value}");
                          if(value.toString().isEmpty){
                            searchData=[];
                            isSearch=false;
                            searchFocusNode.unfocus();
                            setState(() {

                            });

                          }
                        },
                        onEditingComplete: (){
                          print("On editing complete");
                        }
                      ),
                      onSuggestionsBoxToggle: (bool value){
                        print("onSuggestionsBoxToggle is ${value}");
                      },
                      suggestionsCallback: (pattern) async {
                        print("suggestion callback is ${pattern}");
                        return await StateService.getSuggestions(pattern);
                      },
                      transitionBuilder:
                          (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },

                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text("${suggestion}"),
                        );
                      },
                      onSuggestionSelected: (String suggestion) {
                        this._typeAheadController.text = suggestion;
                        showSelectedList = showSelectedList.where((item) => item.toString().toLowerCase().contains(suggestion.toString().toLowerCase())).toList();
                        setState(() {
                        });
                      }),

                ),

                // Expanded(child:
                //
                // ListView.builder(shrinkWrap: true,
                //     itemCount: isSearch ? searchData.length :  model.usersList.users.length,
                //     itemBuilder: (BuildContext context,int index){
                //       return
                //         (isSearch) ?
                //         (index == ( searchData.length - 1) && searchData.length >=5) ?
                //
                //         ElevatedButton(
                //           child: Text("Load More "),
                //           onPressed: () {
                //
                //             if((present + perPage) > model.usersList.users.length) {
                //               searchData.addAll(
                //                   model.usersList.users.getRange(present, model.usersList.users.length));
                //             } else {
                //               searchData.addAll(
                //                   model.usersList.users.getRange(present, present + perPage));
                //             }
                //             present = present + perPage;
                //
                //             setState(() {
                //
                //             });
                //
                //
                //           },
                //         )
                //             :
                //
                //         Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                //           child: Card(
                //             elevation: 10.0,
                //             // color: Colors.blueGrey,
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text("Search Data ID : ${searchData[index].id}",),
                //                   Text("Name : ${searchData[index].name}",),
                //                   Text("UserName : ${searchData[index].username}",),
                //                   Text("currrent index : ${index} ${searchData.length}",),
                //
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )
                //
                //
                //
                //             :
                //
                //         (index == model.usersList.users.length - 1) ?
                //         ElevatedButton(
                //           child: Text("Load More"),
                //           onPressed: () {
                //
                //           },
                //         )
                //
                //             :
                //         Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                //           child: Card(
                //             elevation: 10.0,
                //             // color: Colors.blueGrey,
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                //               child: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text("ID : ${model.usersList.users[index].id}",),
                //                   Text("Name : ${model.usersList.users[index].name}",),
                //                   Text("user length index : ${model.usersList.users.length} current index ${index}",),
                //
                //                 ],
                //               ),
                //             ),
                //           ),
                //         );
                //     })
                //
                //
                // )
                (searchData.isEmpty && isSearch == true ) == true ?
                Text("Not Found",textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent,fontSize: 22),)
                :
                SearchBody(model: model, isSearch: isSearch, controller: this._typeAheadController, searchData: searchData,)




              ],
            )

                :
              Center(child:   CircularProgressIndicator(
                color: Colors.red,
              ),);
          }),
    );
  }
}
class StateService {
  static final List<String> states = [
    'ANDAMAN AND NICOBAR ISLANDS',
    'ANDHRA PRADESH',
    'ARUNACHAL PRADESH',
    'ASSAM',
    'BIHAR',
    'CHATTISGARH',
    'CHANDIGARH',
    'DAMAN AND DIU',
    'DELHI',
    'DADRA AND NAGAR HAVELI',
    'GOA',
    'GUJARAT',
    'HIMACHAL PRADESH',
    'HARYANA',
    'JAMMU AND KASHMIR',
    'JHARKHAND',
    'KERALA',
    'KARNATAKA',
    'LAKSHADWEEP',
    'MEGHALAYA',
    'MAHARASHTRA',
    'MANIPUR',
    'MADHYA PRADESH',
    'MIZORAM',
    'NAGALAND',
    'ORISSA',
    'PUNJAB',
    'PONDICHERRY',
    'RAJASTHAN',
    'SIKKIM',
    'TAMIL NADU',
    'TRIPURA',
    'UTTARAKHAND',
    'UTTAR PRADESH',
    'WEST BENGAL',
    'TELANGANA',
    'LADAKH'
  ];


  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({Key? key, required this.model, required this.isSearch, required this.controller, required this.searchData})
      : super(key: key);

  final UserViewModel model;
  final bool isSearch;
  final TextEditingController controller;
  final List<UserModel> searchData;
  @override
  Widget build(BuildContext context) {
    print("search data is empty ${(searchData.isNotEmpty || model.usersList.users.isNotEmpty)}");
    // print("searchData is ${model.mySearch.searchData.toString()}");
    // print("research data  is ${model.myResearch.researchData!.map((e) => print("${e.title}"))}");

    return
      Expanded(child:

    ListView.builder(shrinkWrap: true,
          itemCount: isSearch ? searchData.length :  model.usersList.users.length,
          itemBuilder: (BuildContext context,int index){
            return
              (isSearch) ?


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Card(
                  elevation: 10.0,
                  // color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Search Data ID : ${searchData[index].id}",),
                        Text("Name : ${searchData[index].name}",),
                        Text("UserName : ${searchData[index].username}",),
                        Text("currrent index : ${index} ${searchData.length}",),

                      ],
                    ),
                  ),
                ),
              )



                  :

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                child: Card(
                  elevation: 10.0,
                  // color: Colors.blueGrey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID : ${model.usersList.users[index].id}",),
                        Text("Name : ${model.usersList.users[index].name}",),
                        Text("user length index : ${model.usersList.users.length} current index ${index}",),

                      ],
                    ),
                  ),
                ),
              );
          })


    )



    ;
  }
}