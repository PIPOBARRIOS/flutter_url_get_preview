import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/model_object_preview.dart';
import '../utility/utility.dart';

//----------------------------------------------
// Gestion vista imagenes
//----------------------------------------------

/// Mostrar la vista previa imagenes
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
              /*
              Container(
                height: _scale*0.40,
                width: _width,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,),
                child: Image(image: NetworkImage(tobReg.image!.url, scale: 0.2), 
                  fit: BoxFit.cover),
              ),
              */
              // Imagen o video
              Container(
                height: _scale*0.40,
                width: _width,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,),
                child: _fobBuildPreviewCustom(tobReg, _scale*0.40),
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

/// Mostrar la vista previa 
Widget _fobBuildPreviewCustom(PreviewData tobReg, double tduHeight) 
{
  if (tobReg.type == TypeContext.undefined)
  {
    // ese una url de cualquier origen con una imagen, titulo y descripción.
    return Image(image: NetworkImage(tobReg.image!.url, scale: 0.2), 
          fit: BoxFit.cover);
  }
  else
  {
    return _buildWebView(tobReg.link!, tduHeight);
  }
}

//----------------------------------------------
// Gestion vista videos
//----------------------------------------------

Widget _buildWebView(String codeHtmlEmbed, double tduHeight) {

  Completer<WebViewController>? _controller = Completer<WebViewController>();
  var _lcrHtmlCode = codeHtmlEmbed.contains("https://www.youtube.com") ||
                     codeHtmlEmbed.contains("https://www.tiktok.com")?
                                    codeHtmlEmbed : fcrHtmlToStringUri(_getHtmlBody(codeHtmlEmbed));

    return SizedBox(
      height: tduHeight,
      child: WebView(
        initialUrl: _lcrHtmlCode,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          if (_controller.isCompleted == false)
          {
            _controller.complete(webViewController);
          }
        }
      )
    );
  }


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

// Youtube
// codigo del video - ejemplo: tcrKeyVideo ="VSzo940auvk" video https://www.youtube.com/watch?v=VSzo940auvk 
/// Codigo Html para incrustar
String _getHtmlEmbedYoutube(String tcrKeyVideo) => "https://www.youtube.com/embed/" + tcrKeyVideo;

// Instagram embedded
// link del video ejemplo: "https://www.instagram.com/tv/CRFvnXkJkjP/?utm_source=ig_web_copy_link";
/// Codigo html para incrustar
String _getHtmlEmbedInstagram(String tcrUrlVideo) => """
  <blockquote class="instagram-media" 
    data-instgrm-captioned data-instgrm-permalink="$tcrUrlVideo" 
    data-instgrm-version="12" 
    style=" background:#FFF; border:0; border-radius:3px; 
      box-shadow:0 0 1px 0 rgba(0,0,0,0.5),0 1px 10px 0 rgba(0,0,0,0.15); 
      margin: 1px; max-width:540px; min-width:326px; 
      padding:0; width:99.375%; 
      width:-webkit-calc(100% - 2px); width:calc(100% - 2px);">
    <div style="padding:16px;">
      <a href="$tcrUrlVideo" 
        style=" background:#FFFFFF; line-height:0; 
        padding:0 0; text-align:center; 
        text-decoration:none; width:100%;" target="_blank">
      </a>
    </div>
  </blockquote>
  <script type="text/javascript" src="https://www.instagram.com/embed.js"></script>
""";

//-------------------------------------------------
// Facebook embedded
//-------------------------------------------------
// link video ejemplo: "https://www.facebook.com/watch/?v=340373467856175&ref=sharing"; 
// codigo html para incrustar
String _getHtmlEmbedFaceBook(String tcrUrlVideo) => """ 
  <div id="fb-root"></div><div class="fb-video" data-href="$tcrUrlVideo"></div>
  <script type="text/javascript" src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.2"></script>
"""; 
