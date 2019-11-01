import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'апликейшн by Белуга\'Карпарейшн',
            style: TextStyle(
              fontSize: 40,
            ),
            textAlign: TextAlign.center,
          ),
          Container(
              width: 500,
              height: 200,
              child: FittedBox(
                  fit: BoxFit.fill, child: Image.asset('assets/orehus.png')))
        ],
      ),
    );
  }
}
