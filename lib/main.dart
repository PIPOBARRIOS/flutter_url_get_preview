import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Views/main_page_view.dart';
import 'blocs/bloc_base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider<BlocPreview>(
      create: (context) => BlocPreview(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aplicación Vista Url',
          theme: ThemeData( primarySwatch: Colors.blue,),
          home: const MainPage(title: 'Vista Previa Url'),
      ),
    );
  }
}