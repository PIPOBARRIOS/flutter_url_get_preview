import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/bloc_base.dart';
import 'models/model_object_preview.dart';
import 'widgets/widgets_item_preview.dart';
import 'widgets/widgets_bar_bottomsheet.dart';

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
          home: const MyHomePage(title: 'Vista Previa Url'),
      ),
    );
    /*
    return MaterialApp(
      title: 'Vista url',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vista Previa Url'),
    );
    */
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> 
{
  double _height = 0;
  //double _width = 0;
  late BlocPreview _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BlocPreview>(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    _height = MediaQuery.of(context).size.height;
    //_width  = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _setListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPreview,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addPreview()
  {
    _bloc.fcvResetData();
    fcvMenuBottomSheetViewList(_bloc, context, (){

      Navigator.pop(context);
      _bloc.fcvAddRegister();

    });
  }

  Widget _setListView()
  {
    return Stack(
        children: <Widget>[
          StreamBuilder<List<PreviewData>>(
          stream: _bloc.tmpStreamList,
          builder: (BuildContext context, AsyncSnapshot<List<PreviewData>> snapshot) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: _fnuItemCount(snapshot.data),
              itemBuilder: (BuildContext context, index) {
                if (snapshot.data != null)
                {
                  return fobBuildPreview(context, snapshot.data![index]);
                }
                return Container(height: _height*0.80,);
              }
            );
          }),  
        ],
    );
  }

  int _fnuItemCount(List<PreviewData>? tmp) 
  {
    var _lnuReturn = tmp != null ? tmp.length:  1;
    return _lnuReturn;
  }
}
