  import 'package:flutter/material.dart';
import '../models/model_object_preview.dart';

/// Mostrar la vista previa
Widget fobBuildPreview(BuildContext context, PreviewData tobReg) 
{
  double _height = MediaQuery.of(context).size.height;
  double _width = MediaQuery.of(context).size.width;

  return SizedBox(
      width: _width*0.95,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(15),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height*0.010),
              // Titulo
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.title!, 
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: _height*0.040)
                ),
              ),
              // Imagen
              Image(image: NetworkImage(tobReg.image!.url)),
              // Descripción
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(tobReg.description!, 
                  style: TextStyle(
                    fontSize: _height*0.030)
                  ),
                ),

              SizedBox(height: _height*0.010),
            ],
          ),
        )
      )
  );
}
