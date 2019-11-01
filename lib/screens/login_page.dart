import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

hexColor(value) {
  String newColor = '0xff' + value;
  newColor = newColor.replaceAll('#', '');
  var intColor = int.parse(newColor);
  return intColor;
}

class _UpperShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 50);
    var firstEndPoint = Offset(size.width * 0.5, size.height - 50);
    var firstControlpoint = Offset(size.width * 0.25, size.height);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50);
    var secondControlPoint = Offset(size.width * .75, size.height - 100);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class _DownShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    var firstEndPoint = Offset(size.width * 0.5, 35);
    var firstControlpoint = Offset(size.width * 0.25, 70);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, 60);
    var secondControlPoint = Offset(size.width * .75, 0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: Color(hexColor('E8A87C')),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ClipPath(
              clipper: _UpperShapeClipper(),
              child: Container(
                color: Color(
                  hexColor('85DCB0'),
                ),
                height: MediaQuery.of(context).size.height / 2 + 50,
                child: Center(
                  child: Hero(
                    tag: 'Save.it',
                    transitionOnUserGestures: true,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        'Save.it',
                        style: TextStyle(fontSize: 78),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: _DownShapeClipper(),
              child: Container(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //гугл регистрация

                      RawMaterialButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Sign Up with Google',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        elevation: 10,
                        splashColor: Color(
                          hexColor('E8A87C'),
                        ),
                        onPressed: () {},
                        fillColor: Color(hexColor('E27D60')),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      //регистрация через фаербейс
                      OutlineButton(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  _EmailLoginPage(context: context)));
                        },
                        borderSide: BorderSide(color: Colors.white),
                        highlightedBorderColor: Color(
                          hexColor('E27D60'),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      )
                    ],
                  ),
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Color(
                  hexColor('41B3A3'),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FlatButton(
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => _EmailSignUpPage(context: context)));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailLoginPage extends LoginPage {
  _EmailLoginPage({this.context});
  var context;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(hexColor('85DCB0')),
            Color(
              hexColor('41B3A3'),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Align(
                //столбец с названием, формами и кнопкой
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Hero(
                      transitionOnUserGestures: true,
                      tag: 'Save.it',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          'Save.it',
                          style: TextStyle(fontSize: 78),
                        ),
                      ),
                    ),
                    //столбец с формари
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 270,
                            child: TextFormField(
                              onSaved: (a) => _email = a,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email must be entered';
                                } else if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Email is incorrect';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Color(
                                hexColor('E27D60'),
                              ),
                              cursorRadius: Radius.circular(1),
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: Color(hexColor('E27D60')),
                                    fontSize: 19),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: 270,
                            child: TextFormField(
                              onSaved: (a) => _password = a,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password must be entered';
                                } else if (value.length < 6) {
                                  return 'Password is incorrect';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Color(
                                hexColor('E27D60'),
                              ),
                              cursorRadius: Radius.circular(1),
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: Color(hexColor('E27D60')),
                                    fontSize: 19),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //кнопка
                    RawMaterialButton(
                      child: Container(
                        width: 250,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      elevation: 10,
                      splashColor: Color(
                        hexColor('E8A87C'),
                      ),
                      onPressed: () {},
                      fillColor: Color(hexColor('E27D60')),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.center,
              ),
              //кнопочка назад
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  iconSize: 40,
                  padding: EdgeInsets.only(top: 40, left: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailSignUpPage extends LoginPage {
  _EmailSignUpPage({this.context});
  var context;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(hexColor('85DCB0')),
            Color(
              hexColor('41B3A3'),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Align(
                //столбец с названием, формами и кнопкой
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Hero(
                      transitionOnUserGestures: true,
                      tag: 'Save.it',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Text(
                          'Save.it',
                          style: TextStyle(fontSize: 78),
                        ),
                      ),
                    ),
                    //столбец с формари
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 270,
                            child: TextFormField(
                              onSaved: (a) => _email = a,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email must be entered';
                                } else if (!value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Email is incorrect';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Color(
                                hexColor('E27D60'),
                              ),
                              cursorRadius: Radius.circular(1),
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: Color(hexColor('E27D60')),
                                    fontSize: 19),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: 270,
                            child: TextFormField(
                              onSaved: (a) => _password = a,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password must be entered';
                                } else if (value.length < 6) {
                                  return 'At least 6 symbols required';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black),
                              cursorColor: Color(
                                hexColor('E27D60'),
                              ),
                              cursorRadius: Radius.circular(1),
                              decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: TextStyle(
                                    color: Color(hexColor('E27D60')),
                                    fontSize: 19),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 260,
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .copyWith(fontSize: 14),
                                children: [
                                  TextSpan(
                                      text:
                                          'By tappig Sign Up, you acknowledge that you have read the '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    style: TextStyle(
                                      color: Color(
                                        hexColor('E27D60'),
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: ' and agree to the '),
                                  TextSpan(
                                    text: 'Terms of Service',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {},
                                    style: TextStyle(
                                      color: Color(
                                        hexColor('E27D60'),
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    //кнопка
                    RawMaterialButton(
                      child: Container(
                        width: 250,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      elevation: 10,
                      splashColor: Color(
                        hexColor('E8A87C'),
                      ),
                      onPressed: () {},
                      fillColor: Color(hexColor('E27D60')),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.center,
              ),
              //кнопочка назад
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                  iconSize: 40,
                  padding: EdgeInsets.only(top: 40, left: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
