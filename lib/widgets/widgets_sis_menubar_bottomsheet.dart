import 'package:flutter/material.dart';
import '../blocs/bloc_persistent.dart';
import '../models/model_object_preview.dart';

//---------------------------------------------------------------------------
// Vista tipo Lista
//---------------------------------------------------------------------------
/// Menu tipo Hoja inferior
void fcvMenuBottomSheetViewList(UrlPreViewBloc bloc, 
                                BuildContext context, 
                                Function(PreviewData) fcOnSelectItem)
{
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
              _viewForm(bloc,context),
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
Widget _viewForm(UrlPreViewBloc bloc,BuildContext context)
{
    var _height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[

        _fobViewAppBarSearch(bloc, context),
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
Widget _fobViewAppBarSearch(UrlPreViewBloc bloc, BuildContext context)
{
  double _width = MediaQuery.of(context).size.width;

  final _lobController = TextEditingController();
  final _lobFocusNode = FocusNode();

  // cargar los datos desde Bloc
  var data = bloc.fobGetRegisterDataGestion();
  _lobController.text = data.link != null ? data.link!: '';

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
          size: 40,),
        ),
        StreamBuilder<String>(
          stream: bloc.g1Url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return  Container(
              //color: Colors.amber,
              width: _width*0.70,
              height: 45,
              padding: const EdgeInsets.only(left: 5, top: 14),
              margin: const EdgeInsets.only(left: 50, top: 5, bottom: 5),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Pega el link aqui...' ,
                  border: InputBorder.none,
                ),
                controller: _lobController,
                focusNode: _lobFocusNode,
                onChanged: bloc.onG1UrlChanged,
              )
            );
          }
        ),
        // Boton limpiar texto
        StreamBuilder<bool>(
          stream: bloc.onActivateAccion,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

            return snapshot.hasData == true && snapshot.data == true ?
              Container(
                height: 45,
                margin: const EdgeInsets.only(top: 5, bottom: 7, right: 30),
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  heroTag: UniqueKey(),
                  child: const Icon(Icons.close),
                  elevation: 5,
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    _lobController.clear();
                    //_fcvStarSearch();
                  } 
                ),
              ) :
              Container();
            //return _fobBuildViewButton(snapshot);
          }
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
              _fcvStarSearch();
            }
          ),
        ),
      ],
    )),
  );
}

/// Realizar busqueda  de la url dentro del texto
void _fcvStarSearch(String tcrText)
{
  var lob = getPreviewData(tcrText);
}
