import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../utility/utility.dart';

//-------------------------------------------------------------- 
// PreviewData: Clase para guardar los datos obtenidos de la Url
//-------------------------------------------------------------- 
/// Clase para guardar los datos obtenidos de la Url
@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class PreviewData extends Equatable {

  /// Tipo contenido
  TypeContext? type;
  /// Texto descripcion del contenido (usualmente og:description meta tag)
  String? description;

  /// ver [PreviewDataImage]
  PreviewDataImage? image;

  /// URL del recurso
  String? link;

  /// Link del titulo (usualmente og:title meta tag)
  String? title;

  PreviewData({
     this.type=TypeContext.undefined, 
     this.description,
     this.image,
     this.link,
     this.title,
  });

  /// Cargar desde json
  factory PreviewData.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataFromJson(json);

  /// convertir datos a json.
  Map<String, dynamic> toJson() => _$PreviewDataToJson(this);

  /// Crear una copia de los datos.
  /// Null values will nullify existing values.
  PreviewData copyWith({String? description,
                        PreviewDataImage? image,
                        String? link,
                        String? title}) 
  {
    return PreviewData(
      type: type,
      description: description,
      image: image,
      link: link,
      title: title,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [type, description, image, link, title];
}

//-------------------------------------------------------------- 
// PreviewDataImage: Clase para cargar caracteristicas de la imagen
//-------------------------------------------------------------- 
/// Clase para cargar caracteristicas de la imagen
@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class PreviewDataImage extends Equatable {

  /// Altura de la imagen en pixels
  double height;

  /// URL de la imagen
  String url;

  /// ancho en en pixels de la imagen
  double width;

  /// Clase para cargar caracteristicas de la imagen
  PreviewDataImage({
    required this.height,
    required this.url,
    required this.width,
  });

  /// Creates preview data image from a map (decoded JSON).
  factory PreviewDataImage.fromJson(Map<String, dynamic> json) =>
      _$PreviewDataImageFromJson(json);

  /// Converts preview data image to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$PreviewDataImageToJson(this);

  /// Equatable props
  @override
  List<Object> get props => [height, url, width];
}


//-------------------------------------------------------------- 
// Para serealizar los registros
//-------------------------------------------------------------- 

PreviewData _$PreviewDataFromJson(Map<String, dynamic> json) => PreviewData(
      description: json['description'] as String?,
      image: json['image'] == null ? null : PreviewDataImage.fromJson(json['image'] as Map<String, dynamic>),
      link: json['link'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$PreviewDataToJson(PreviewData instance) =>
    <String, dynamic>{
      'description': instance.description,
      'image': instance.image?.toJson(),
      'link': instance.link,
      'title': instance.title,
    };

PreviewDataImage _$PreviewDataImageFromJson(Map<String, dynamic> json) =>
    PreviewDataImage(
      height: (json['height'] as num).toDouble(),
      url: json['url'] as String,
      width: (json['width'] as num).toDouble(),
    );

Map<String, dynamic> _$PreviewDataImageToJson(PreviewDataImage instance) =>
    <String, dynamic>{
      'height': instance.height,
      'url': instance.url,
      'width': instance.width,
    };
