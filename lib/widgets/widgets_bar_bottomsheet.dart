import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_url_get_preview/blocs/bloc_event.dart';
import 'package:flutter_url_get_preview/blocs/bloc_state.dart';
import '../blocs/bloc_base.dart';
import '../models/model_object_preview.dart';

/// datos del Registro cargado 
PreviewData? _lobReg;

/// Para persistencia de datos
late BlocPreview _bloc;

/// Capturar texto
final _lobController = TextEditingController();

//---------------------------------------------------------------------------
// Vista tipo Lista
//---------------------------------------------------------------------------
/// Menu tipo Hoja inferior
void fcvMenuBottomSheetViewList(BlocBase bloc, 
                                BuildContext context, 
                                Function fcOnSelectItem)
{
  //_bloc = bloc;
  _bloc = BlocProvider.of<BlocPreview>(context);

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
          child: _PreViewbuild(context),
      ),

    ],
  );
}

// vista gestion bloc
Widget _PreViewbuild(BuildContext context)
{
  return Stack(
    children: <Widget>[ 
      BlocBuilder<BlocPreview,BlocState>(
      bloc: _bloc,
      builder: (context, state) {
          
        if (state is StateIsInitializing || state is StateIsCapture)
        {
          return _fcvBuildIsCapture(context);
        } 
        else if (state is StateIsLoading)
        {
          return _fcvBuildIsLoading(context);
        }
        else if (state is StateIsSuccessFull)
        {
          return _fcvBuildSuccessFull(context);
        }
        else if (state is StateIsFailure)
        {
          return _fcvBuildFailure();
        }
        return Container();
      }),
    ],
  );
}

Widget _fcvBuildIsCapture(BuildContext context)
{
  var _height = MediaQuery.of(context).size.height;
  return Container(
    margin: const EdgeInsets.all(5),
    alignment: Alignment.center,
    height: _height* 0.12,
    decoration: const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.rectangle,),
    child: Icon(Icons.link, 
      color: Colors.grey,
      size: _height* 0.10),
  );
}

Widget _fcvBuildIsLoading(BuildContext context)
{
  var _height = MediaQuery.of(context).size.height;
  return Container(
    margin: const EdgeInsets.all(5),
    alignment: Alignment.center,
    height: _height* 0.12,
    decoration: const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.rectangle,),
    child: const CircularProgressIndicator(strokeWidth: 5),
  );
}

Widget _fcvBuildSuccessFull(BuildContext context)
{
  _bloc.data
  var _height = MediaQuery.of(context).size.height;
  return Container(
    margin: const EdgeInsets.all(5),
    alignment: Alignment.center,
    height: _height* 0.12,
    decoration: const BoxDecoration(
      color: Colors.red,
      shape: BoxShape.rectangle,),
    child: Icon(Icons.link, 
      color: Colors.grey,
      size: _height* 0.10),
  );
}

//---------------------------------------------------------------------------
// Boton guardar
//---------------------------------------------------------------------------
/// guardar los cambios realizados
Widget _fobBuildButtonSaveLink(Function fcOnSelectItem)
{
  return _fobViewButtonAction("Guardar", (){
    if (_lobReg != null)
    {
      fcOnSelectItem(_lobReg!);
      _resetData();
    }
  });
}
/// Boton Accion 
Widget _fobViewButtonAction(String tcrLabel,  VoidCallback tobButtonPressed)
{
  return Align(
    alignment: Alignment.bottomCenter,
    child: MaterialButton(
      height: 40,
      minWidth: 70,
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
      child: Container(
        alignment: Alignment.center,
        height: 25,
        width: 130,
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

/// Boton para ejecutar la busqueda
Widget _fobViewAppBarSearch(BuildContext context)
{
  double _width = MediaQuery.of(context).size.width;

  final _lobFocusNode = FocusNode();

  // cargar los datos desde Bloc
  //var data = _bloc?.fobGetRegisterDataGestion();
  //_lobController.text = data?.link != null ? data!.link!: '';

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
          stream: _bloc.g1Url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return  Container(
              color: Colors.amber,
              width: _width*0.65,
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
                onChanged: _bloc.onG1UrlChanged,
                keyboardType: TextInputType.multiline,
                maxLines: null,                       
              )
            );
          }
        ),
        // Boton limpiar texto
        StreamBuilder<String>(
          stream: _bloc.g1Url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) 
          {
            if (snapshot.data != null)
            {
              return snapshot.data!.isNotEmpty ?
              Stack(
                children: <Widget>[
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
                ]
              ): Container();
            }
            return Container();
          }
        ),
      ],
    )),
  );
}

/// Realizar busqueda  de la url dentro del texto
/// y cargar datos
void _fcvStarSearch(String tcrText) async
{
  if (tcrText.isNotEmpty)
  {
     _bloc.add(EventLoad(message: tcrText));
  }
}

/// limpiar campo de captura y el Bloc
void _resetData()
{
  _bloc.add(EventCapture());
  _lobController.clear();
  _bloc.fcvResetData();
}

