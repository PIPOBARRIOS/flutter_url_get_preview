import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import '../utility/functions.dart';
import '../models/model_object_preview.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';


///  Persistencia de datos
class UrlPreViewBloc extends Bloc<BlocEvent, BlocState>
{

  UrlPreViewBloc() : super(StateIsInitializing(),);

  /// Registro temporal para cargar datos de la Url
  PreviewData data = PreviewData();

  final List<PreviewData>  _tmpInListAux = [];
  /// Controlador documentos cargados 
  final PublishSubject<List<PreviewData>> _tmpListController = PublishSubject<List<PreviewData>>();
  Sink<List<PreviewData>> get _tmpInList => _tmpListController.sink;
  /// Lista general registro cargados
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
    _tmpInListAux.add(data);
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
      data = PreviewData();
      bool llgResponse = false;

      // Cargar los datos desde la base de datos
      await getPreviewData(event.message).then((tcrValue) {
        if (tcrValue.title!.isNotEmpty) // se ejecuto sin error
        {   
          data = tcrValue; 
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


  /*
  //---------------------------------------------------------------------
  // Procesos gestion firmar acuerdo y demas pasos
  //---------------------------------------------------------------------

  /// Cargando datos para la vista
  Stream<StandardEditionState> _fcvUpdateDataUpdate(SaleOfferEventUpdate event)  async*
  {
    try
    {
      bool llgResponse = false;
      await apiPublishOffer.flgApiEditSaleOffer(event.tmpData).then((tcrValue) {
        if (tcrValue != null)
        {
          llgResponse = true;
        }
      });

      if (llgResponse == true)
      {
          // Mostrar la vista de datos
          yield StandardEditionStateIsCapture();
      }
      else
      {
        // Ocurrio algin error
        yield StandardEditionStateIsFailure(msjError: "Ocurrió algún error");
      }
    }
    on ManagementError catch (e)
    {
      yield StandardEditionStateIsFailure(msjError: e.message);
    }
  }

  //---------------------------------------------------------------------
  // Procesos para gestion 
  //---------------------------------------------------------------------

  Stream<StandardEditionState> _fcvMapSavingDataBase(SaleOfferEventSave event) async*
  {
    try
    {
      bool llgResponse = false;

      await apiPublishOffer.flgApiEditSaleOffer(event.tmpData).then((tcrValue) {
        if (tcrValue != null)
        {
          llgResponse = true;
        }
      });

      if (llgResponse == true)
      {
          // Mostrar la vista, finalizado con Exito
          yield StandardEditionStateIsSuccessFull();
      }
      else
      {
        // Ocurrio algin error
        yield StandardEditionStateIsFailure(msjError: "Ocurrió algún error");
      }

    }
    on ManagementError catch (e)
    {
      yield StandardEditionStateIsFailure(msjError: e.message);
    }
  }
  */
}