import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import '../utility/functions.dart';
import '../models/model_object_preview.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';


///  Persistencia de datos
class BlocPreview extends Bloc<BlocEvent, BlocState>
{

  BlocPreview() : super(StateIsInitializing(),);


  //---------------------------------------------------------------------------
  // gestion objeto vista para escribir la url
  //---------------------------------------------------------------------------
  /// Para gestion de la url copiada
  BehaviorSubject<String> _g1urlController = BehaviorSubject<String>.seeded("");
  /// captura del texto 
  Stream<String> get g1Url => _g1urlController.stream;
  /// Url copiada
  Function(String) get onG1UrlChanged => _g1urlController.sink.add;


  /// activacion los botones de accion
  Stream<bool> get onActivateAccion => streamActiveButtomClear();
  Stream<bool> streamActiveButtomClear()
  {
     Stream<bool> _llgReturn = BehaviorSubject<bool>.seeded(false);

    _g1urlController.stream.listen((onData) {
      _llgReturn  = BehaviorSubject<bool>.seeded(onData.isNotEmpty); 
    });
    Future.delayed(const Duration(seconds: 1));
    return _llgReturn;
  }

  /// Limpiar datos
  void fcvResetData()
  {
     _g1urlController = BehaviorSubject<String>.seeded("");
     _tmpInregData.add(PreviewData());
  }

  // Cerrar controladores 
  void dispose() {
    _g1urlController.close();
    _g1regDataController.close();
    _tmpListController.close();
  }

  //---------------------------------------------------------------------------
  // gestion temporales y cargar desde la Web
  //---------------------------------------------------------------------------
  /// Registro temporal para cargar datos de la Url
  PreviewData regData = PreviewData();

  /// Straming para activar el boton guardar
  final BehaviorSubject<PreviewData> _g1regDataController = BehaviorSubject<PreviewData>();
  Sink<PreviewData> get _tmpInregData => _g1regDataController.sink;
  Stream<PreviewData> get g1regData => _g1regDataController.stream;

  /// Temporal auxiliar
  final List<PreviewData>  _tmpInListAux = [];

  /// Controlador para lista de registros cargados en vista
  final PublishSubject<List<PreviewData>> _tmpListController = PublishSubject<List<PreviewData>>();
  Sink<List<PreviewData>> get _tmpInList => _tmpListController.sink;
  Stream<List<PreviewData>> get tmpStreamList => _tmpListController.stream;

  /// fcvAddRegister: Adicionar registro al hacer click
  /// en el boton guardar
  void fcvAddRegister()
  {
    /*
    var ob = data.copyWith(description: data.description,
                           image: data.image,
                           link: data.link,
                           title: data.title);
    */  
    _tmpInListAux.add(regData);
    _tmpInList.add(_tmpInListAux);
  }

  // Proceso de gestion
  @override
  Stream<BlocState> mapEventToState(BlocEvent event) async* 
  {
    if (event is EventCapture)
    {
      yield StateIsCapture();
    }

    if (event is EventLoad)
    {
      yield StateIsLoading();
      yield *_fcvLoadData(event);
    }

    if (event is EventError)
    {
      // cuando ocurre un error
      yield StateIsFailure(msjError:'ocurrió algún error.');
    }
  }
  /// Crgando datos para la vista
  Stream<BlocState> _fcvLoadData(EventLoad event) async*
  {
    try 
    {
      regData = PreviewData();
      bool llgResponse = false;

      // Cargar los datos desde la base de datos
      await getPreviewData(event.message).then((tcrValue) {
        if (tcrValue.image != null) // se ejecuto sin error
        {   
          regData = tcrValue;
          _tmpInregData.add(tcrValue);
          llgResponse = true;
        }
      });

      if (llgResponse == true)
      {
          // Mostrar la vista de la pagina (preview Url)
          yield StateIsSuccessFull();
      }
      else
      {
        // Ocurrio un error al cargar la url (no se encontro los objetos en el dom)
        yield StateIsFailure(msjError: "No fué posible cargar la vista.");
      }

    }
    on ManagementError catch (e) 
    {
      yield StateIsFailure(msjError: e.message);
    }
  }
}