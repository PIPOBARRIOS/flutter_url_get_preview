import 'package:flutter/material.dart';
import '../models/model_object_preview.dart';

//---------------------------------------------------------------------------
// Vista tipo Lista
//---------------------------------------------------------------------------
/// Menu tipo Hoja inferior
void fcvMenuBottomSheetViewList(BuildContext context, Function(PreviewData) fcOnSelectItem)
{
  var _height = MediaQuery.of(context).size.height;
  //var _width  = MediaQuery.of(context).size.width * 0.95;

  //var _heightView = _height*0.80; 
  
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0)
      ),
    ),    
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,          
          height: 120,
          child: ListView(
            children: <Widget>[
                // Campos para captura
              ViewForm(key:  const Key('M10-657-776754545'), context: context),
              _fobBuildButtonSaveLink(fcOnSelectItem),
            ],
          ),
        ),
      );
    },
  );
}

//---------------------------------------------------------------------------
// Boton guardar
//---------------------------------------------------------------------------
/// guardar los cambios realizados
Widget _fobBuildButtonSaveLink(Function(PreviewData) fcOnSelectItem)
{
  return _fobViewButtonAction("Guardar",
  (){
    fcOnSelectItem(_setPreviewRegister());
  });
}

/// Mostrar Boton debajo del mensaje
Widget _fobViewButtonAction(String tcrLabel,  VoidCallback tobButtonPressed)
{
  return MaterialButton(
    height: 40,
    minWidth: 70,
    color: Colors.blue,
    child: Container(
      alignment: Alignment.center,
      height: 25,
      width: 90,
      child: Text(tcrLabel.toString(), 
        style: const TextStyle(
        color: Colors.white,
        fontSize: 16)
      ),
    ),    
    onPressed: tobButtonPressed
  );
}

PreviewData _setPreviewRegister()
{
  return  PreviewData(
    title:'Así es el Xperia Pro - 1',
    description: 'Así es el Xperia Pro - 1, el primer móvil de Sony con sensor de una pulgada (y Snapdragon 888,  pantalla OLED 4K a 120Hz y 512 GB de memoria interna...) #sonyxperiapro1',
    link: 'https://external.fbaq6-1.fna.fbcdn.net/safe_image.php?d=AQE8Pewum_QMjfqW&w=400&h=400&url=https%3A%2F%2Fi.blogs.es%2F30c86b%2Fsony%2F840_560.jpeg&cfs=1&ext=emg0&_nc_oe=6eec5&_nc_sid=06c271&ccb=3-5&_nc_hash=AQFdwIDSb3toASkL',
  );
}

//---------------------------------------------------------------------------
// Vista capura de datos
//---------------------------------------------------------------------------

/// Vista formulario
class ViewForm extends StatelessWidget
{
  final Key? key;
  final BuildContext context; 

  const ViewForm({this.key, required this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    var _height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[
        _fobViewAppBarSearch(),

        Container(
          height: _height* 0.80,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,),
          //child: _fobTextSearchAndButton(),
        ),

      ],
    );
  }

  /// AppBarra de de busqueda
  Widget _fobViewAppBarSearch() 
  {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.rectangle,),
          child: _fobTextSearchAndButton(),
        ),
      );
  }

  /// Boton para ejecutar la busqueda
  Widget _fobTextSearchAndButton()
  {
    final _lobController = TextEditingController();
    final _lobFocusNode = FocusNode();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 10, right: 60, bottom: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 37, top: 2, bottom: 2),
            child: TextField(
              decoration: const InputDecoration(
              hintText: 'Copia el link aqui...' ,
              border: InputBorder.none,
              ),  
              controller: _lobController,
              focusNode: _lobFocusNode,
            ),
          ),
        ),
            
        //  limpiar el cuadro de texto
        _lobController.text.isEmpty ? Container() :
        Container(
          height: 30,
          margin: const EdgeInsets.only(left: 2, bottom: 12),
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            heroTag: const Key("LOCER-45667-01"),
            child: const Icon(Icons.close),
            elevation: 5,
            backgroundColor: Colors.redAccent,
            onPressed: () {
              _lobController.clear();
              _fcvStarSearch();
            } 
          ),
        ),      
        // Ejecutar busqueda
        Container(
          height: 40,
          margin: const EdgeInsets.only(right: 52, bottom: 7),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: const Key("LOCER-4536555467-02"),
            child: const Icon(Icons.search),
            elevation: 5,
            backgroundColor: Colors.teal[300],
            onPressed: () {
              //Lanzar la busqueda
              _fcvStarSearch();
            }
          ),
        ),
      ],
    );
  }

  /// Realizar busqueda
  void _fcvStarSearch()
  {
  }
}