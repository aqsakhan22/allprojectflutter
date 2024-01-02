import 'package:flutter/material.dart';
class BottomSheetIssue extends StatefulWidget {
  const BottomSheetIssue({Key? key}) : super(key: key);

  @override
  State<BottomSheetIssue> createState() => _BottomSheetIssueState();
}

class _BottomSheetIssueState extends State<BottomSheetIssue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Bottom Sheet Issue"),
      ),
      body:
        Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  showModalBottomSheet(
                      // isScrollControlled: true,
                      context: context,
                    builder: (context){
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                         // padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'OTP sent to ',
                                        style: TextStyle(
                                            fontSize: 15 ,color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text: 'email',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'Verification Code',
                                      style: TextStyle(color: Colors.grey),
                                    ),

                                  ],
                                ),
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Jeyboard"
                                ),
                              )

                            ],
                          ),
                        );
                    }

                  );

            }, child: Text("Test Bottom Sheet"))
          ],
        ),

    );
  }
}
