import 'package:flutter/foundation.dart';
class CountProvider with ChangeNotifier{
  int counter=0;
  int get getcounter => counter; // set get
   void setCount(){
     counter++;
     notifyListeners();
   }

}