import 'package:firebaseflutterproject/stateManagement/provider/favourite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Favouritescreen extends StatefulWidget {
  const Favouritescreen({Key? key}) : super(key: key);

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

class _FavouritescreenState extends State<Favouritescreen> {
  List selectedItems=[];
  @override
  Widget build(BuildContext context) {
    // final favouriteProvider=Provider.of<FavouriteProvider>(context,listen: false);
    print("build");
    return Scaffold(
      appBar: AppBar(title: Text("Favourite screen"),),
      body:
      Column(
        children: [
        Expanded(child:   ListView.builder(
            itemCount: 100,
            shrinkWrap: true,
            itemBuilder: (BuildContext context,int index){
              return  Consumer<FavouriteProvider>(builder: (BuildContext context,fav,child){

                return ListTile(
                  onTap: (){
                   if(fav.selectedItems.contains(index)){
fav.removeItems(index);

                   }
                   else{
                     fav.addItems(index);
                   }

                  },
                  title: Text("titlke"),
                  trailing: Icon( fav.selectedItems.contains(index) ? Icons.favorite : Icons.favorite_outline),
                );

              });

            }))
        ],
      ),
    );
  }
}
