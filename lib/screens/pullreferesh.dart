import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class RefereshScreen extends StatefulWidget {
  const RefereshScreen({Key? key}) : super(key: key);

  @override
  State<RefereshScreen> createState() => _RefereshScreenState();
}

class _RefereshScreenState extends State<RefereshScreen> {
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    items.removeRange(0, 2);
    if(mounted)
      setState(() {

      });

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length+1).toString());
    if(mounted)
      setState(() {

      });
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Refersh",style: TextStyle(color: Colors.white),),
        ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (c, i) => Card(child: Center(child: Text(items[i],style: TextStyle(color: Colors.blueAccent),))),
          itemExtent: 100.0,
          itemCount: items.length,
        ),


      ),

    );
  }
}
