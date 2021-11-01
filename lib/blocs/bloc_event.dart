import 'package:equatable/equatable.dart';
import '../models/model_object_preview.dart';

/// Clase Base
abstract class BlocEvent extends Equatable {
  
  @override
  List<Object> get props => []; // iniciar vacia lista de objetos 
}


abstract class Event extends BlocEvent {

  /// Para pasar parametros de utilidad
  final String message;

  Event({this.message = ''}); // se inicia la variable vacia
}

/// Desde formulario se esta realizando la captura de datos
class EventCapture extends Event {}

/// Descencadenar el evento para guardar los datos
class EventSave extends Event {

  /// Temporal registros que recoge todos los datos capturados
  final PreviewData tmpData;

  EventSave({String message ='', required this.tmpData}) :
             super(message: message); // se inicia las variables vacias

}

/// Descencadenar el evento cargar datos de una url en la vista
class EventLoad extends Event {

  EventLoad({String message =''}) : super(message: message); // se inicia las variables vacias

}

/// Cuando ocurre un erro en la autenticación
class EventError extends Event {} // activa el evento error

/// Control para errores
class  ManagementError implements Exception 
{
  final String message;
  ManagementError(this.message);
}
