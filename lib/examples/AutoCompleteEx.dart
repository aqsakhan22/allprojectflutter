import 'package:flutter/material.dart';

//https://www.fluttercampus.com/guide/189/how-to-add-autocomplete-suggestions-on-textfield-in-flutter/
//https://www.youtube.com/watch?v=ybV1aIyKFE0
//https://api.flutter.dev/flutter/widgets/RawAutocomplete-class.html
class AutoCompleteEx extends StatefulWidget {
  const AutoCompleteEx({Key? key}) : super(key: key);

  @override
  State<AutoCompleteEx> createState() => _AutoCompleteExState();
}

class _AutoCompleteExState extends State<AutoCompleteEx> {
  List<String> suggestons = ["USA", "UK", "Uganda", "Uruguay", "United Arab Emirates"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("äuto complete"),
      ),
      body: Column(
        children: [
          RawAutocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              } else {
                List<String> matches = <String>[];
                matches.addAll(suggestons);

                matches.retainWhere((s) {
                  print("matches value is ${s}");
                  return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
                return matches;
              }
            },
            onSelected: (String selection) {
              print('You just selected $selection');
            },
            fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
              return TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (String value) {},
              );
            },
            optionsViewBuilder: (BuildContext context, void Function(String) onSelected, Iterable<String> options) {
              return Material(
                  child: SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                          child: Column(
                        children: options.map((opt) {
                          return InkWell(
                              onTap: () {
                                onSelected(opt);
                              },
                              child: Container(
                                  padding: EdgeInsets.only(right: 60),
                                  child: Card(
                                      child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(10),
                                    child: Text(opt),
                                  ))));
                        }).toList(),
                      ))));
            },
          )
        ],
      ),
    );
  }
}
