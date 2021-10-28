import 'package:flutter/material.dart';

import 'blocs/bloc_persistent.dart';
import 'models/model_object_preview.dart';
import 'widgets/widgets_sis_menubar_bottomsheet.dart';

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
  UrlPreViewBloc _homeBloc = UrlPreViewBloc();  

  late final List<PreviewData> _tmpData=[
    PreviewData(
      title:'Así es el Xperia Pro - 1',
      description: 'Así es el Xperia Pro - 1, el primer móvil de Sony con sensor de una pulgada (y Snapdragon 888,  pantalla OLED 4K a 120Hz y 512 GB de memoria interna...) #sonyxperiapro1',
      link: 'https://external.fbaq6-1.fna.fbcdn.net/safe_image.php?d=AQE8Pewum_QMjfqW&w=400&h=400&url=https%3A%2F%2Fi.blogs.es%2F30c86b%2Fsony%2F840_560.jpeg&cfs=1&ext=emg0&_nc_oe=6eec5&_nc_sid=06c271&ccb=3-5&_nc_hash=AQFdwIDSb3toASkL',
    )
  ];

  @override
  Widget build(BuildContext context) 
  {
    _height = MediaQuery.of(context).size.height;
    _width  = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _setListView(),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: _addPreview,
        tooltip: 'Agregar',
        child: const Icon(Icons.add),
      ),
      */ 
    );
  }

  Widget _addPreview()
  {
    return Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.only(bottom: _height *0.0680),
          alignment: Alignment.center,
          height: _height * 0.10,
          width: _width * 0.24,
          child: _fobBuildButtonAddNewEdition(),
        ),
    );
  }

  /*
  void _addPreview()
  {
    fcvMenuBottomSheetViewList(context, (item){
      Navigator.pop(context);
      _homeBloc.fcvAddRegister(item);
    });
    /*
    _homeBloc.fcvAddRegister(
      PreviewData(
        title:'Así es el Xperia Pro - 1',
        description: 'Así es el Xperia Pro - 1, el primer móvil de Sony con sensor de una pulgada (y Snapdragon 888,  pantalla OLED 4K a 120Hz y 512 GB de memoria interna...) #sonyxperiapro1',
        link: 'https://external.fbaq6-1.fna.fbcdn.net/safe_image.php?d=AQE8Pewum_QMjfqW&w=400&h=400&url=https%3A%2F%2Fi.blogs.es%2F30c86b%2Fsony%2F840_560.jpeg&cfs=1&ext=emg0&_nc_oe=6eec5&_nc_sid=06c271&ccb=3-5&_nc_hash=AQFdwIDSb3toASkL',
      )
    );
    */
  }
  */

  Widget _setListView()
  {
    return StreamBuilder<List<PreviewData>>(
          stream: _homeBloc.tmpStreamList,
          builder: (BuildContext context, AsyncSnapshot<List<PreviewData>> snapshot) {
            return ListView(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _fnuItemCount(snapshot.data),
                  itemBuilder: (BuildContext context, index) 
                  {
                    if (snapshot.data != null)
                    {
                      return _fobBuildPreview(context, index, snapshot.data![index]);
                    }
                    return Container(height: _height*0.80,);
                  },
                ),  
              ]  
            );  
          }
        );

    /*
    return Stack(
      children: <Widget>[   
        StreamBuilder<List<PreviewData>>(
          stream: _homeBloc.tmpStreamList,
          builder: (BuildContext context, AsyncSnapshot<List<PreviewData>> snapshot) {
            return ListView(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _fnuItemCount(snapshot.data),
                  itemBuilder: (BuildContext context, index) 
                  {
                    if (snapshot.data != null)
                    {
                      return _fobBuildPreview(context, index, snapshot.data![index]);
                    }
                    return Container(height: _height*0.80,);
                  },
                ),  
              ]  
            );  
          }
        ),
      ]
    );
    */
  }

  int _fnuItemCount(List<PreviewData>? tmp) 
  {
    var _lnuReturn = tmp != null ? tmp.length:  1;
    return _lnuReturn;
  }

  /// Mostrar la vista previa
  Widget _fobBuildPreview(BuildContext context, int tnuIndex, PreviewData tobReg) 
  {
    var _width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: _width*0.95,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(15),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: <Widget>[

              const SizedBox(height: 30),
              // Titulo
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.title!, 
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18)
                ),
              ),
              // Imagen
              Image(image: NetworkImage(tobReg.link!)),
              // Descripción
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.description!, 
                  style: const TextStyle(
                    fontSize: 14)
                  ),
                ),

              const SizedBox(height: 30),
            ],
          ),
        )
      )
    );
  }
}
