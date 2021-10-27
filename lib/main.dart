import 'package:flutter/material.dart';

import 'models/model_object_preview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vista Previa Url'),
    );
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
  double _width = 0;
  late List<PreviewData> _tmpData;

  @override
  Widget build(BuildContext context) 
  {
    _height = MediaQuery.of(context).size.height;
    _width  = MediaQuery.of(context).size.width * 0.85;

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

  }

  Widget _setListView()
  {
    return Container(
      height: _height,
      width: _width,
      child: ListView.builder(
        padding: EdgeInsets.all(5),
        shrinkWrap: true,
        itemCount: _tmpData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) 
        {
          return _fobBuildViewListSchedule(context, index, _tmpData[index]);
        },
      ),
    );
  }

}
