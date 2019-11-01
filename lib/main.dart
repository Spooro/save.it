import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




import 'package:save_it/resources/theme.dart';

import 'package:provider/provider.dart';


import 'home.dart';





void main() => runApp(MyApp());




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      builder: (_) => ThemeChanger(themes[0]),
      child: new MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(home:Home(), theme: ThemeData.dark(), debugShowCheckedModeBanner: false,);
  }
}
