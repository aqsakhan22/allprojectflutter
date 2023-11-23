import 'package:blocprovider/bloc/counterbloc/counter_bloc.dart';
import 'package:blocprovider/bloc/flutter_doc_sample/flutterDocUi.dart';
import 'package:blocprovider/bloc/internetConnectivity/InternetUI.dart';
import 'package:blocprovider/bloc/internetConnectivity/internet_bloc.dart';
import 'package:blocprovider/bloc/validationBloc/signin/bloc/signin_bloc.dart';
import 'package:blocprovider/bloc/validationBloc/signin/signin.dart';
import 'package:blocprovider/cubit/InternetCubitUI.dart';
import 'package:blocprovider/cubit/intternetcubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => InternetBloc()),
            BlocProvider(create: (_) => InternetCubit()),
            BlocProvider(create: (_) => SignIn()),
            // BlocProvider(create: (_) => CounterBloc()),
          ],
          child:
          MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a blue toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home:  SignInScreen(),
        )


      );

  }
}


