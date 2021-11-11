import 'package:equatable/equatable.dart';

abstract class BlocState extends Equatable {
  
  @override
  List<Object> get props => []; // iniciar vacia lista de objetos 
}

abstract class State extends BlocState {}

/// proceso de captura datos en formulario esta en curso (estado normal)
class StateIsCapture extends State {}

/// se esta haciendo el proceso de guardar datos
class StateIsSaving extends State {}

/// Proceso de guardado esta completo
class StateIsSuccessFull extends State {}

/// Inicializacion en curso
class StateIsInitializing extends State {}

/// Proceso de busqueda  activo o en curso
class StateIsSearching extends State {}

/// Cargando datos
class StateIsLoading extends State {}

/// Ocupado en un proceso
class StateIsBusy extends State {}

/// State - Cuando no hay resultados de siguiente pagina
class StateIsNosuccessNext extends State {}

/// se produjo un erro en captura, guardado o busqueda de datos
class StateIsFailure extends State {
  final String msjError;
  StateIsFailure({required this.msjError});
}
