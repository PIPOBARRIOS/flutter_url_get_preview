import 'package:flutter/material.dart';
import '../models/model_object_preview.dart';
import '../utility/utility.dart';


/// Mostrar la vista previa 
Widget fobBuildPreview(BuildContext context, PreviewData tobReg) 
{
  if (tobReg.type == TypeContext.undefined)
  {
    // ese una url de cualquier origen con una imagen, titulo y descripción.
    return fobBuildPreviewImage(context,tobReg);
  }
  else
  {
    return fobBuildPreviewImage(context,tobReg);
  }
}

//----------------------------------------------
// Gestion vista imagenes
//----------------------------------------------

/// Mostrar la vista previa imagenes
Widget fobBuildPreviewImage(BuildContext context, PreviewData tobReg) 
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

//----------------------------------------------
// Gestion vista videos
//----------------------------------------------

/// Html para Embeber el codigo vista del video
String _getHtmlBody(String tcrCodeEmbed) => """
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style>
            *{box-sizing: border-box;margin:0px; padding:0px;}
              #widget {
                        display: flex;
                        justify-content: center;
                        margin: 0 auto;
                        max-width:100%;
                    }      
          </style>
        </head>
        <body>
          <div id="widget">$tcrCodeEmbed</div>
        </body>
      </html>
""";
