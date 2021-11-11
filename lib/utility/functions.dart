import 'dart:async';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' as parser show parse;
import 'package:http/http.dart' as http show get;
import 'utility.dart';
import '../models/model_object_preview.dart';


/// Regex para verificar si el texto es un email
const lcrRegexEmail = r'([a-zA-Z0-9+._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)';

/// Regex para verificar si content type es una imagen
const lcrRegexImageContentType = r'image\/*';

/// Regex para encontrar link dentro del texto
const lcrRegexLink = r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?';

/// Leer desde texto para obetenr un objeto tipo [PreviewData]  
/// y poder mostrar una vista previa de la primera url encontrada
Future<PreviewData> getPreviewData(String tcrText, {String? proxy}) async 
{

  var previewData = PreviewData();

  String? previewDataDescription;
  PreviewDataImage? previewDataImage;
  String? previewDataTitle;
  String? previewDataUrl;

  try 
  {
    // buscar dentro de un email
    final emailRegexp = RegExp(lcrRegexEmail, caseSensitive: false);
    final textWithoutEmails = tcrText.replaceAllMapped(emailRegexp,      
                                                      (match) => '').trim();
    if (textWithoutEmails.isEmpty) return previewData; // regresa vacio

    // encontrar link dentro de un texto
    final urlRegexp = RegExp(lcrRegexLink, caseSensitive: false);
    final matches = urlRegexp.allMatches(textWithoutEmails);
    if (matches.isEmpty) return previewData; // regresa vacio

    var url = textWithoutEmails.substring(matches.first.start, matches.first.end);

    if (!url.toLowerCase().startsWith('http')) 
    {
      url = 'https://' + url;
    }

    // Cargar los datos de la consulta en el document dom
    previewDataUrl = _calculateUrl(url, proxy);
    final uri = Uri.parse(previewDataUrl);
    final response = await http.get(uri);
    final document = parser.parse(response.body);

    final imageRegexp = RegExp(lcrRegexImageContentType);

    //print(response.body);

    if (imageRegexp.hasMatch(response.headers['content-type'] ?? '')) 
    {
      final imageSize = await _getImageSize(previewDataUrl);
      previewDataImage = PreviewDataImage(height: imageSize.height,
                                          url: previewDataUrl,
                                          width: imageSize.width);
      return PreviewData(
        image: previewDataImage,
        link: previewDataUrl,
      );
    }

    if (!_hasUTF8Charset(document)) { return previewData; }

    final title = _getTitle(document);
    if (title != null) { previewDataTitle = title.trim(); }

    final description = _getDescription(document);
    if (description != null) { previewDataDescription = description.trim(); }

    final imageUrls = _getImageUrls(document, url);

    //final video = _getVidelosUrls(document, url);


    Size imageSize;
    String imageUrl;

    // Cuando hay imagenes en la vista
    if (imageUrls.isNotEmpty) 
    {
      // cuando hay varias, traer la mas grande
      imageUrl = imageUrls.length == 1
                              ? _calculateUrl(imageUrls[0], proxy)
                              : await _getBiggestImageUrl(imageUrls, proxy);

      imageSize = await _getImageSize(imageUrl);
      previewDataImage = PreviewDataImage(height: imageSize.height,
                                          url: imageUrl,
                                          width: imageSize.width);

      //print(" -- url imagen -------------- " +imageUrl);
    }
    return PreviewData(
      type: _getTypeUrlsWithVideo(previewDataUrl),
      description: previewDataDescription,
      image: previewDataImage,
      link: previewDataUrl,
      title: previewDataTitle,
    );
  } 
  catch (e) 
  {
    return PreviewData(
      description: previewDataDescription,
      image: previewDataImage,
      link: previewDataUrl,
      title: previewDataTitle,
    );
  }
}

/// Clasificar urls con posibles videos (instagram,facebook,Tiktok,Youtube)
TypeContext _getTypeUrlsWithVideo(String tcrUrl) 
{
  var _type = TypeContext.undefined;
  if ((tcrUrl.startsWith('https://www.youtube.com') || 
      tcrUrl.startsWith('https://youtube.com') || 
      tcrUrl.startsWith('https://youtu.be')) && tcrUrl.contains('playlist?list') == false )
  {
    _type = TypeContext.videoyoutube;
  }
  else if (tcrUrl.startsWith('https://www.facebook.com') || 
          tcrUrl.startsWith('https://facebook.com')) 
  {
    if (tcrUrl.contains('/videos/') || tcrUrl.contains('/watch/'))
    {
      _type = TypeContext.videofacebook;
    } 
  }
  else if (tcrUrl.startsWith('https://www.instagram.com') || 
           tcrUrl.startsWith('https://instagram.com')) 
  {
    if (tcrUrl.contains('/reel/') || tcrUrl.contains('/tv/'))
    {
      _type = TypeContext.videoinstagram;
    } 
  }
  else if (tcrUrl.startsWith('https://www.tiktok.com') || 
           tcrUrl.startsWith('https://tiktok.com')) 
  {
    _type = TypeContext.videotiktok;
  }

  return _type;
}

/// cuando hay un proxy
String _calculateUrl(String baseUrl, String? proxy) 
{
  if (proxy != null) 
  {
    return '$proxy$baseUrl';
  }

  return baseUrl;
}

String? _getMetaContent(Document document, String propertyValue) 
{
  final meta = document.getElementsByTagName('meta');

  final element = meta.firstWhere((e) => e.attributes['property'] == propertyValue,
                            orElse: () => meta.firstWhere((e) => e.attributes['name'] == propertyValue,
                                                          orElse: () => Element.tag(null)));

  return element.attributes['content']?.trim();
}

/// Verificar utf-8
bool _hasUTF8Charset(Document document) 
{
  final emptyElement = Element.tag(null);
  final meta = document.getElementsByTagName('meta');
  final element = meta.firstWhere((e) => e.attributes.containsKey('charset'),
                                  orElse: () => emptyElement);

  if (element == emptyElement) return true;

  return element.attributes['charset']!.toLowerCase() == 'utf-8';
}

/// Buscar el titulo de la publicación
String? _getTitle(Document document) 
{
  final titleElements = document.getElementsByTagName('title');
  if (titleElements.isNotEmpty) return titleElements.first.text;

  return _getMetaContent(document, 'og:title') ??
      _getMetaContent(document, 'twitter:title') ??
      _getMetaContent(document, 'og:site_name');
}

/// Buscar la descripcion principal
String? _getDescription(Document document) 
{
  return _getMetaContent(document, 'og:description') ??
      _getMetaContent(document, 'description') ??
      _getMetaContent(document, 'twitter:description');
}

/// Buscar las urls que contienen videos
List<String> _getVidelosUrls(Document document, String baseUrl) 
{
  var meta = document.getElementsByTagName('meta');
    print(' total '+meta.length.toString());
    print("titulo  " + document.getElementsByTagName('title')[0].innerHtml);
    //print("codigo  " + document.getElementsByTagName('og:description')[0].innerHtml);

    //var videoTags = document.getElementsByTagName('og:description');
    print(" descripcion "+_getMetaContent(document, 'og:description')!);
    //print(" video "+_getMetaContent(document, 'video')!);

    meta = document.getElementsByTagName('video');

    print("total-- "+meta.length.toString());
    for( var i = 0; i < meta.length; i++ )
    {
      print( "tags -----" + meta[i].attributes['og:video'].toString());
      print( "tags -----" + meta[i].attributes['og:source'].toString());
      //print( "tags -----" + meta[i].attributes['src'].toString());
      
      //console.log( vids.item(i).getElementsByTagName('source')[i].src);      

    }
    
  /*
  var attribute = 'content';
  var elements = meta.where((e) =>
            e.attributes['property'] == 'og:video' ||
            e.attributes['property'] == 'video' ||
            e.attributes['property'] == 'twitter:video').toList();

  if (elements.isEmpty) 
  {
    for (var element in meta) {
      if (element.attributes['property']!.contains('video'))
      {
        print(" -- video -------------- " +element.innerHtml);
      } 
    }
  }
  */
  return ['ok'];
}

/// Buscar las urls que contienen imagen
List<String> _getImageUrls(Document document, String baseUrl) 
{
  final meta = document.getElementsByTagName('meta');
  var attribute = 'content';
  var elements = meta.where((e) =>
            e.attributes['property'] == 'og:image' ||
            e.attributes['property'] == 'twitter:image').toList();

  if (elements.isEmpty) 
  {
    elements = document.getElementsByTagName('img');
    attribute = 'src';
  }

  return elements.fold<List<String>>([], (previousValue, element) 
  {
    final actualImageUrl = _getActualImageUrl(baseUrl, element.attributes[attribute]?.trim());

    return actualImageUrl != null ? [...previousValue, actualImageUrl] : previousValue;
  });
}

/// revision y ajustes para la url de la imagen
String? _getActualImageUrl(String baseUrl, String? imageUrl) 
{
  if (imageUrl == null || imageUrl.isEmpty || imageUrl.startsWith('data')) 
  {
    return null;
  }

  if (imageUrl.contains('.svg') || imageUrl.contains('.gif')) return null;

  if (imageUrl.startsWith('//')) imageUrl = 'https:$imageUrl';

  // si llega hasta aqui, es porque hay una url valida para la imagen
  if (!imageUrl.startsWith('http')) 
  {
    // quitar la doble barra
    if (baseUrl.endsWith('/') && imageUrl.startsWith('/'))  
    {
      imageUrl = '${baseUrl.substring(0, baseUrl.length - 1)}$imageUrl';
    } 
    else if (!baseUrl.endsWith('/') && !imageUrl.startsWith('/')) 
    {
      imageUrl = '$baseUrl/$imageUrl';
    } 
    else 
    {
      // concatena normal
      imageUrl = '$baseUrl$imageUrl';
    }
  }

  return imageUrl;
}

/// Leer tamaño de la imagen
Future<Size> _getImageSize(String url) 
{
  final completer = Completer<Size>();
  final stream = Image.network(url).image.resolve(ImageConfiguration.empty);
  late ImageStreamListener streamListener;

  onError(Object error, StackTrace? stackTrace) {
    completer.completeError(error, stackTrace);
  }

  listener(ImageInfo info, bool _) 
  {
    if (!completer.isCompleted) 
    {
      completer.complete(
        Size(
          height: info.image.height.toDouble(),
          width: info.image.width.toDouble(),
        ),
      );
    }
    stream.removeListener(streamListener);
  }

  streamListener = ImageStreamListener(listener, onError: onError);

  stream.addListener(streamListener);
  return completer.future;
}

/// Buscar la imagen con tamaño mas grande
Future<String> _getBiggestImageUrl(List<String> imageUrls, String? proxy) async 
{
  if (imageUrls.length > 5) 
  {
    imageUrls.removeRange(5, imageUrls.length);
  }

  var currentUrl = imageUrls[0];
  var currentArea = 0.0;

  // Traer la imagen mas grande cuando hay varias en la vista
  await Future.forEach(imageUrls, (String url) async 
  {
    final size = await _getImageSize(_calculateUrl(url, proxy));
    final area = size.width * size.height;

    if (area > currentArea) 
    {
      currentArea = area;
      currentUrl = _calculateUrl(url, proxy); // traer url de la imagen
    }
  });

  return currentUrl;
}
