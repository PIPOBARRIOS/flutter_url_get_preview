import 'package:flutter/material.dart';
import '../models/model_object_preview.dart';

//---------------------------------------------------------------------------
// Vista tipo Lista
//---------------------------------------------------------------------------
/// Menu tipo Hoja inferior
void fcvMenuBottomSheetViewList(BuildContext context, 
                                Function(PreviewData) fcOnSelectItem)
{
  var _height = MediaQuery.of(context).size.height;
  //var _width  = MediaQuery.of(context).size.width * 0.95;

  var _heightView = _height*0.80; 
  
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0)
      ),
    ),    
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,          
          height: _heightView,
          child: Container(
           
          ),
        ),
      );
    },
  );
}

PreviewData _setPreviewRegister()
{
  return  PreviewData(
    title:'Así es el Xperia Pro - 1',
     description: 'Así es el Xperia Pro - 1, el primer móvil de Sony con sensor de una pulgada (y Snapdragon 888,  pantalla OLED 4K a 120Hz y 512 GB de memoria interna...) #sonyxperiapro1',
    link: 'https://external.fbaq6-1.fna.fbcdn.net/safe_image.php?d=AQE8Pewum_QMjfqW&w=400&h=400&url=https%3A%2F%2Fi.blogs.es%2F30c86b%2Fsony%2F840_560.jpeg&cfs=1&ext=emg0&_nc_oe=6eec5&_nc_sid=06c271&ccb=3-5&_nc_hash=AQFdwIDSb3toASkL',
  );
}
