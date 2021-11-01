import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


///  Persistencia de datos
class BehaviorBloc implements BlocBase
{

  /// Para gestion de la url copiada
  BehaviorSubject<String> _g1urlController = BehaviorSubject<String>.seeded("");
  /// captura del texto 
  Stream<String> get g1Url => _g1urlController.stream;
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
  }

  // Cerrar controladores 
  void dispose() {
    _g1urlController.close();
 }

  // Se invoca cuando se accede a un método o propiedad inexistente - para cumplir con la implements BlocBase
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}