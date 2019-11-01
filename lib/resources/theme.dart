import 'package:flutter/material.dart';


hexColor(value) {
  String newColor = '0xff' + value;
  newColor = newColor.replaceAll('#', '');
  var intColor = int.parse(newColor);
  return intColor;
}

List themes = [
  ThemeData(brightness: Brightness.dark, fontFamily: 'Gilroy'),
  ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Gilroy',
    
    // accentColor: Color(
    //   hexColor('E27D60'),
    // ),
    // primaryColor: Color(
    //   hexColor('85DCB0'),
    // ),
  
   
  

  )
];

class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
