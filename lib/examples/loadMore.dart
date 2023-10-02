import 'package:flutter/material.dart';
class LoadMore extends StatefulWidget {
  const LoadMore({Key? key}) : super(key: key);

  @override
  State<LoadMore> createState() => _LoadMoreState();
}

class _LoadMoreState extends State<LoadMore> {
  List<String> originalItems =  List<String>.generate(10000, (i) => "Item $i");
  List<String> items = [];
  int perPage  = 10;
  int present = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      items.addAll(originalItems.getRange(present, present + perPage));
      present = present + perPage;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoadMore Example"),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            shrinkWrap: true,
            itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
            itemBuilder: (context, index) {
              return (index == items.length ) ?
              Container(
                color: Colors.greenAccent,
                child:
                ElevatedButton(
                  child: Text("Load More"),
                  onPressed: () {
                    setState(() {
                      if((present + perPage) > originalItems.length) {
                        items.addAll(
                            originalItems.getRange(present, originalItems.length));
                      } else {
                        items.addAll(
                            originalItems.getRange(present, present + perPage));
                      }
                      present = present + perPage;
                    });
                  },
                ),
              )
                  :
              ListTile(
                title: Text('${items[index]}'),
              );

            },
          ),)
        ],
      ),
    );
  }
}
