import 'package:flutter/material.dart';
import 'package:runwith/screens/nav_drawer.dart';
import 'package:runwith/theme/color.dart';
import 'package:runwith/widget/app_bar_widget.dart';
import 'package:runwith/widget/bottom_bar_widget.dart';

class ProgramScehdule extends StatefulWidget {
  final List<dynamic> programschedule;
  const ProgramScehdule({Key? key, required this.programschedule}) : super(key: key);

  @override
  State<ProgramScehdule> createState() => _ProgramScehduleState();
}

class _ProgramScehduleState extends State<ProgramScehdule> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isChecked=true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: MyNavigationDrawer(),
      key: _key,
      bottomNavigationBar: BottomNav(scaffoldKey: _key,),
      appBar: AppBarWidget.textAppBar("PROGRAM SCHEDULE",),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child:
        widget.programschedule.isEmpty ?

        Center(child: Text("No Data",style: TextStyle(color: Colors.white),),)
            :

        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
          itemCount: widget.programschedule.length,
            itemBuilder: (BuildContext context,int parentIndex){
            return
              widget.programschedule[parentIndex]['ProgramContent'] != null ?
             Column(
               children: [
                 SizedBox(height: 10,),
                 Text("WEEK ${parentIndex + 1}",style: TextStyle(color: Colors.white),),
                 ListView.builder(
                     shrinkWrap: true,
                     padding: EdgeInsets.zero,
                     itemCount: (widget.programschedule[parentIndex]['ProgramContent'] as List).length,
                     physics: ScrollPhysics(),
                     itemBuilder: (BuildContext context,int childIndex){
                       return Container(
                         margin: EdgeInsets.symmetric(vertical: 10.0),
                         padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                         height: size.height * 0.17,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
                           border: Border.all(
                             width: 1,
                             color: Colors.white
                           ),
                         ),
                         child: Row(
                           children: [
                             Flexible(
                               child:  Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children: [
                                   // SizedBox(height: 5,),
                                   Text("Day ${childIndex + 1} ${widget.programschedule[parentIndex]['ProgramContent'][childIndex]['Day']} ",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w800),),
                                   SizedBox(height: 5,),
                                   Text("KM Program",style: TextStyle(color: Colors.white),),
                                   SizedBox(height: 5,),
                                   Text("${widget.programschedule[parentIndex]['ProgramContent'][childIndex]['Run'] ?? "0"} Min",style: TextStyle(color: Colors.white),),
                                   SizedBox(height: 5,),
                                   Text("${widget.programschedule[parentIndex]['ProgramContent'][childIndex]['Title']}",style: TextStyle(color: Colors.white),),SizedBox(height: 5,),


                                 ],
                               ),),
                             Container(
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(
                                     width: 2,
                                     color: CustomColor.green
                                 ),
                               )  ,
                               width: 30,
                               height: 30,
                               // color:Colors.red,

                               child: Transform.scale(
                                 scale: 1.5 ,

                                 child:   Checkbox(
                                   checkColor: CustomColor.green,
                                   activeColor:CustomColor.white, //works when true
                                   // fillColor:MaterialStateProperty.all(CustomColor.white),
                                   shape: RoundedRectangleBorder(
                                     // Making around shape
                                       side: BorderSide(
                                         color: CustomColor.white, //your desire colour here
                                         width: 20,
                                       )  ,
                                       borderRadius: BorderRadius.circular(20)),

                                   onChanged:(bool? value){
                                     // setState(() {
                                     //   isChecked=value!;
                                     // });
                                   },
                                   value: widget.programschedule[parentIndex]['ProgramContent'][childIndex]['Run'] == null ? false : true,

                                 ),
                               ),
                             )
                           ],
                         )

                       );




                     })
               ],
             )

                  :
             SizedBox();
            }),
      ),
    );
  }
}
