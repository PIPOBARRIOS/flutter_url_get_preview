import 'dart:async';
//import 'dart:collection';
import 'package:bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/model_object_preview.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_event.dart';
import 'bloc_state.dart';


///  Persistencia de datos
class UrlPreViewBloc extends Bloc<BlocEvent, BlocState>
{

  UrlPreViewBloc() : super(StateIsInitializing(),);

  /// Registro dado desde temporal que viene desde la base de datos
  PreviewData lobRecord = PreviewData();

  final List<PreviewData>  _tmpInListAux = [];
  /// Controlador documentos cargados 
  final PublishSubject<List<PreviewData>> _tmpListController = PublishSubject<List<PreviewData>>();
  Sink<List<PreviewData>> get _tmpInList => _tmpListController.sink;
  /// Lista general registro cargados
  Stream<List<PreviewData>> get tmpStreamList => _tmpListController.stream;

  //------------------------------------------------
  // Declaración controladores
  //------------------------------------------------
  /// Para gestion de la url copiada
  BehaviorSubject<String> _g1urlController = BehaviorSubject<String>.seeded("");
  // Flujo de datos
  Stream<String> get g1Url => _g1urlController.stream;

  //------------------------------------------------
  // Funciones Validacion 
  //------------------------------------------------
  /// Url copiada
  Function(String) get onG1UrlChanged => _g1urlController.sink.add;

  /*
  //------------------------------------------------
  // activacion botones
  //------------------------------------------------
  /// activacion del boton Guardar 
  Stream<bool> get onActivateCREATE => Rx.combineLatest3(
                                      g1note, 
                                      g1address,
                                      g1price,
                                      (a, b, c) => true);
  */

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

  //------------------------------------------------
  // Funciones Limpiar datos
  //------------------------------------------------
  /// Limpiar datos
  void fcvResetData()
  {
     _g1urlController = BehaviorSubject<String>.seeded("");
    //_g1urlController.sink.add('');
    _g1addressController.sink.add('');
    _g1priceController.sink.add('');
  }
  
  //------------------------------------------------
  // Funciones para Cargar en temporal
  //------------------------------------------------
  ///Cargar los datos en el registro temporal maestro
  PreviewData fobGetRegisterDataGestion()
  {

    _g1urlController.stream.listen((onData) {
     lobRecord.link = onData;
    });

    _g1addressController.stream.listen((onData) {
     lobRecord.description = onData;
    });


    return lobRecord;
  }
  //------------------------------------------------
  // fcvAddRegister: Adicionar registro
  //------------------------------------------------
  /// Adicionar registro
  void fcvAddRegister(PreviewData tobRegister)
  {
    _tmpInListAux.add(tobRegister);
    _tmpInList.add(_tmpInListAux);
  }

  // Cerrar controladores 
  void dispose() {
    _tmpListController.close();
    _g1urlController.close();
    _g1addressController.close();
    _g1priceController.close();
 }

  // Se invoca cuando se accede a un método o propiedad inexistente - para cumplir con la implements BlocBase
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}