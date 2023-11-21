import 'dart:async';

import 'package:blocprovider/bloc/internetConnectivity/internet_event.dart';
import 'package:blocprovider/bloc/internetConnectivity/internet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

class InternetBloc extends Bloc<InternetEvent,InternetState>{
  Connectivity connectivity=Connectivity();
  StreamSubscription? streamSubscription;
  InternetBloc() : super(InternetInitialState()){
    on<InternetLostEvent>((event,emit) => emit(InternetLostState()));
    on<InternetGainedEvent>((event,emit) =>  emit(InternetGainedState()));
   streamSubscription= connectivity.onConnectivityChanged.listen((result) {
     print("Intnert connectivity is ${result.name}");
      if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
        add(InternetGainedEvent());
      }
      else{
        add(InternetLostEvent());
      }


    });


  }


@override
  Future<void> close() {
    // TODO: implement close
  streamSubscription?.cancel();
    return super.close();

  }
}