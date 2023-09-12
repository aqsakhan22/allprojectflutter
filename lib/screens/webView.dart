import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AllWebview extends StatefulWidget {
  final String title, link;

  const AllWebview({Key? key, required this.title, required this.link})
      : super(key: key);

  @override
  State<AllWebview> createState() => _AllWebviewState();
}


class _AllWebviewState extends State<AllWebview> {
  bool isLoading = true;

  @override
  void initState() {
    //print("Name is /// ${ProvidersUtility.userProvider!.user.username} and email ${ProvidersUtility.userProvider!.user.email}");
    super.initState();
    print("WEBVIEW IS ${widget.title} ${widget.link} ");

    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.title}",textAlign: TextAlign.left,),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: '${widget.link}',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (finish) {
                  print("Page is loading ${finish}");
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
              isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Stack()
            ],
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}