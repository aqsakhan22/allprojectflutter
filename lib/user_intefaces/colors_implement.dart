import 'dart:math';

import 'package:flutter/material.dart';
class ColrosImplement extends StatefulWidget {
  const ColrosImplement({Key? key}) : super(key: key);

  @override
  State<ColrosImplement> createState() => _ColrosImplementState();
}

class _ColrosImplementState extends State<ColrosImplement> {

  List<Color> colors=[
    Colors.red,  Colors.blue,  Colors.pink,  Colors.orange,  Colors.yellow,  Colors.grey,  Colors.green,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("colors"),),
      body:GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              childAspectRatio: 1 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemBuilder: (BuildContext context,int index){
            return Container(
              decoration: BoxDecoration(
                // color: Colors.primaries[_random.nextInt(Colors.primaries.length)]
                // [_random.nextInt(9) * 100]
                // color: colors[Random().nextInt(colors.length)]
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    colors[Random().nextInt(colors.length)],
                    colors[Random().nextInt(colors.length)] ,
                    colors[Random().nextInt(colors.length)]
                  ]
                )
              ),

              child: Text("jghv"),
            );
          }

      ),
    );
  }
}
