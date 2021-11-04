import 'package:meta/meta.dart';

/// Represents the size object
@immutable
class Size {
  /// Creates [Size] from width and height
  const Size({
    required this.height,
    required this.width,
  });

  /// Height
  final double height;

  /// Width
  final double width;
}

/// Extraer el id del video en una Url de Youtube 
/// para usuar en la url embebida en navegador ejemplo (https://www.youtube.com/embed/L4iLMRHVmZ8)
String? fcvGetIdVideoUrlYoutube(String tcrUrlVideo, {bool trimWhitespaces = true}) 
{
    if (!tcrUrlVideo.contains("http") && (tcrUrlVideo.length == 11)) return tcrUrlVideo;

    if (trimWhitespaces) tcrUrlVideo = tcrUrlVideo.trim(); // quitar los espacios

    for (var exp in [RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
                     RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
                     RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")])  {

      Match? match = exp.firstMatch(tcrUrlVideo);
      if (match != null && match.groupCount >= 1) return match.group(1); // devilver la Id del video
    }

    return null;
}
