import 'package:flutter/material.dart';
void postDialogDisplay(Widget widget,BuildContext context){

       showModalBottomSheet(
         context: context,
          builder: (BuildContext context) {
           return SizedBox(
               height: MediaQuery.of(context).size.height*0.7,
               child:widget
           );
       },
        );
      }
