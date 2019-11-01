import 'package:flutter/material.dart';


import 'package:provider/provider.dart';


import 'package:save_it/resources/theme.dart';

class Settings extends StatelessWidget {
  
    
    @override
    Widget build(BuildContext context) {
      ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Settings',
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Dark Theme'),
                    onTap: () => _themeChanger.setTheme(themes[0]),
                  ),
                  ListTile(
                    title: Text('Light Theme'),
                    onTap: () => _themeChanger.setTheme(themes[1]),
                  ),
                ],
              ),
              RawMaterialButton(
                onPressed: () {
                  
                },
                child: Text('Log Out'),
                fillColor: Colors.red,
              )
            ],
          ),
        ),
      );
    }
  }

