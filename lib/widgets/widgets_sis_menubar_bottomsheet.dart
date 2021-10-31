import 'package:flutter/material.dart';
import '../utility/functions.dart';
import '../blocs/bloc_persistent.dart';
import '../models/model_object_preview.dart';

/// datos del Registro cargado 
PreviewData? _lobReg;

/// Para persistencia de datos
UrlPreViewBloc? _bloc;

/// Capturar texto
final _lobController = TextEditingController();

//---------------------------------------------------------------------------
// Vista tipo Lista
//---------------------------------------------------------------------------
/// Menu tipo Hoja inferior
void fcvMenuBottomSheetViewList(UrlPreViewBloc bloc, 
                                BuildContext context, 
                                Function(PreviewData) fcOnSelectItem)
{
  _bloc = bloc;
  var _height = MediaQuery.of(context).size.height;
  //var _width  = MediaQuery.of(context).size.width * 0.95;
 
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
          height: _height*0.95,
          child: Stack(
            children: <Widget>[
                // Campos para captura
              _viewForm(context),
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
  return _fobViewButtonAction("Guardar", (){
    if (_lobReg != null)
    {
      _resetData();
      fcOnSelectItem(_lobReg!);
    }
  });
}

/// Mostrar Boton debajo del mensaje
Widget _fobViewButtonAction(String tcrLabel,  VoidCallback tobButtonPressed)
{
  return Align(
    alignment: Alignment.bottomCenter,
    child: MaterialButton(
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
    ),
  );
}

//---------------------------------------------------------------------------
// Vista capura de datos
//---------------------------------------------------------------------------

/// Vista formulario
Widget _viewForm(BuildContext context)
{
    var _height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[

        _fobViewAppBarSearch(context),
        Container(
          margin: const EdgeInsets.all(5),
          height: _height* 0.40,
          decoration: const BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,),
          //child: _fobTextSearchAndButton(),
        ),

      ],
    );
}

/// Boton para ejecutar la busqueda
Widget _fobViewAppBarSearch(BuildContext context)
{
  double _width = MediaQuery.of(context).size.width;

  final _lobFocusNode = FocusNode();

  // cargar los datos desde Bloc
  var data = _bloc?.fobGetRegisterDataGestion();
  _lobController.text = data?.link != null ? data!.link!: '';

  return Align(
    alignment: Alignment.topCenter,
    child: Container(
    //alignment: Alignment.bottomCenter,
    margin: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(40),
    ),
    child: Stack(
      children: <Widget>[
        // icono  
        Container(
          margin: const EdgeInsets.only(left: 5, top: 3),
          child: const Icon(Icons.link, 
            color: Colors.grey,
            size: 40,
          ),
        ),
        StreamBuilder<String>(
          stream: _bloc?.g1Url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return  Container(
              color: Colors.amber,
              width: _width*0.65,
              //height: 45,
              padding: const EdgeInsets.only(left: 2),
              margin: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
              child: TextField(
                style: const TextStyle(
                    fontSize: 12
                ),
                decoration: const InputDecoration(
                  hintText: 'Pega el link aqui...' ,
                  border: InputBorder.none,
                ),
                controller: _lobController,
                focusNode: _lobFocusNode,
                onChanged: _bloc?.onG1UrlChanged,
                keyboardType: TextInputType.multiline,
                maxLines: null,                       
              )
            );
          }
        ),
        // Boton limpiar texto
        Container(
          height: 45,
          margin: const EdgeInsets.only(top: 5, bottom: 7, right: 50),
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.close, color: Colors.red),
            elevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: () {
              _resetData();
            } 
          ),
        ),
        // Ejecutar busqueda
        Container(
          height: 45,
          //color: Colors.cyan,
          margin: const EdgeInsets.only(top: 5, bottom: 7),
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.search),
            elevation: 5,
            backgroundColor: Colors.teal[300],
            onPressed: () {
              //Lanzar la busqueda
              _fcvStarSearch(_lobController.text);
            }
          ),
        ),
      ],
    )),
  );
}

/// Realizar busqueda  de la url dentro del texto
void _fcvStarSearch(String tcrText) async
{
  print(' -----------busqueda-----------');
  if (tcrText.isNotEmpty)
  {
    print('---------haciendo busqueda-------------');
    _lobReg = null;
    await getPreviewData(tcrText).then((value) {

      print('--------- en proceso-------------');
      _resetData();
      _lobReg = value;
    });
  }
}

/// limpiar campo de captura y el Bloc
void _resetData()
{
  _lobController.clear();
  _bloc?.fcvResetData();
}

