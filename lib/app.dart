import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vilavi/BLoC_API/api_bloc.dart';
import 'package:vilavi/BLoC_API/api_event.dart';
import 'package:vilavi/BLoC_AUTH/auth_bloc.dart';
import 'package:vilavi/UI/login.dart';
import 'package:vilavi/UI/tasks.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VILAVI Task Assistant',
      initialRoute: '/',
      routes: {
        '/': (context) => BlocProvider(
          child: LoginScreen(),
          create: (context) => AuthBloc(),
        ),
        '/taskList': (context) =>
            BlocProvider(
              child: TaskScreen(),
              create: (context) => TaskBloc()..add(FetchTasksEvent()),
            ),
      },
    );
  }
}


