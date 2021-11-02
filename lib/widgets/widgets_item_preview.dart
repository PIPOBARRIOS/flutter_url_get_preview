import 'package:flutter/material.dart';
import '../models/model_object_preview.dart';

/// Mostrar la vista previa
Widget fobBuildPreview(BuildContext context, PreviewData tobReg) 
{
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;
  var _scale = _height;
  _scale = _width > _scale ?  _width : _scale;

  return SizedBox(
      width: _width*0.98,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(15),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: <Widget>[
              // Imagen
              Container(
                height: _scale*0.40,
                width: _width,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,),
                child: Image(image: NetworkImage(tobReg.image!.url, scale: 0.2), 
                  fit: BoxFit.cover),
              ),
              // Titulo
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.title!, 
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: _scale*0.020)
                ),
              ),
              // Descripción
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.description!, 
                  style: TextStyle(
                    fontSize: _scale*0.012)
                  ),
                ),

              SizedBox(height: _scale*0.014),
            ],
          ),
        )
      )
  );
}
