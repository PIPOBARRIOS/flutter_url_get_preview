import 'dart:async';
import 'package:bloc/bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/model_object_preview.dart';
import 'package:rxdart/rxdart.dart';

//import '../utility/utility.dart';
//import '../models/model_saleoffer.dart';
//import 'bloc_saleoffer_behavior_validator.dart';

///
///  GESTION VALIDACION PARA FORMULARIO CAPTURA DE DATOS PARTICIPANTES EN UNA OFERTA
///
class UrlPreViewBloc implements BlocBase
{
  /// Registro dado desde temporal que viene desde la base de datos
  PreviewData lobRecord = PreviewData();

  /// Controlador documentos cargados 
  final PublishSubject<List<PreviewData>> _tmpListController = PublishSubject<List<PreviewData>>();
  Sink<List<PreviewData>> get _tmpInList => _tmpListController.sink;
  /// Lista general registro cargados
  Stream<List<PreviewData>> get tmpStreamList => _tmpListController.stream;

  //------------------------------------------------
  // Declaración controladores
  //------------------------------------------------

  /// Descripcion de la oferta
  final BehaviorSubject<String> _g1noteController = BehaviorSubject<String>.seeded("3");
  /// Dirección residencia 
  final BehaviorSubject<String> _g1addressController = BehaviorSubject<String>.seeded("");
  /// Precio o valor economico 
  final BehaviorSubject<String> _g1priceController = BehaviorSubject<String>.seeded("0");

  //------------------------------------------------
  // Flujo de datos
  //------------------------------------------------
  /*
  Stream<String> get g1note => _g1noteController.stream.transform(fcrValidnote);
  Stream<String> get g1address => _g1addressController.stream.transform(fcrValidaddress);
  Stream<String> get g1price => _g1priceController.stream.transform(fflValidprice);
  */
  //------------------------------------------------
  // Funciones Validacion 
  //------------------------------------------------
  /// Descripcion de la oferta
  Function(String) get onG1noteChanged => _g1noteController.sink.add;
  /// Dirección residencia
  Function(String) get onG1addressChanged => _g1addressController.sink.add;
  /// Precio o valor
  Function(String) get onG1priceChanged => _g1priceController.sink.add;

  //------------------------------------------------
  // Funciones para mostrar y activacion del boton Guardar 
  // combineLatest: puede ser combineLatest3,combineLatest4,combineLatest5... 15
  //------------------------------------------------
  /*
  Stream<bool> get onActivateCREATE => Rx.combineLatest3(
                                      g1note, 
                                      g1address,
                                      g1price,
                                      (a, b, c) => true);
  */
  //------------------------------------------------
  // Funciones Limpiar datos
  //------------------------------------------------
  /// Limpiar datos
  void fcvResetData()
  {
    _g1noteController.sink.add('');
    _g1addressController.sink.add('');
    _g1priceController.sink.add('');
  }
  
  //------------------------------------------------
  // Funciones para Cargar en temporal
  //------------------------------------------------
  ///Cargar los datos en el registro temporal maestro
  PreviewData fobGetRegisterDataGestion()
  {

    _g1noteController.stream.listen((onData) {
     lobRecord.title = onData;
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
    _tmpInList.add([tobRegister]);
  }

  // Cerrar controladores 
  void dispose() {
    _tmpListController.close();
    _g1noteController.close();
    _g1addressController.close();
    _g1priceController.close();
 }

  // Se invoca cuando se accede a un método o propiedad inexistente - para cumplir con la implements BlocBase
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}