import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
class SearchFilter extends StatefulWidget {
  const SearchFilter({Key? key}) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  final TextEditingController _typeAheadController = TextEditingController();
  List showSelectedList=StateService.states;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Filter"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0,),
       Padding(padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
       child:    TypeAheadField(
           textFieldConfiguration: TextFieldConfiguration(
             decoration: InputDecoration(labelText: 'State'),
             controller: this._typeAheadController,
           ),
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
             print("selected list is ${showSelectedList}");
           }),

       ),

         Expanded(child:  ListView.builder(

             itemCount: showSelectedList.length ,
             itemBuilder: (BuildContext context,int index){

               return Card(
                 
                 child: Column(
                   children: [
                     Text("${showSelectedList[index]}",style: TextStyle(
                         color: Colors.red
                     ),)

                   ],
                 ),
               );
             }))
        ],
      ),
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