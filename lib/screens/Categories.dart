import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:save_it/resources/categoriesData.dart';
import 'package:save_it/resources/colors.dart';
import 'package:intl/intl.dart';

hexColor(value) {
  String newColor = '0xff' + value;
  newColor = newColor.replaceAll('#', '');
  var intColor = int.parse(newColor);
  return intColor;
}

final _formKey = GlobalKey<FormState>();

var a = Firestore.instance.collection('transactionCards').where('serial', isEqualTo: 0).getDocuments();
final GlobalKey<AnimatedCircularChartState> expensesKey =
    GlobalKey<AnimatedCircularChartState>();
final GlobalKey<AnimatedCircularChartState> incomeKey =
    GlobalKey<AnimatedCircularChartState>();

List<CircularStackEntry> expensesData = <CircularStackEntry>[
  CircularStackEntry(<CircularSegmentEntry>[
    CircularSegmentEntry(0, groceries.color),
    CircularSegmentEntry(0, health.color),
    CircularSegmentEntry(0, gifts.color),
    CircularSegmentEntry(0, transport.color),
    CircularSegmentEntry(0, shopping.color),
    CircularSegmentEntry(0, leisure.color),
  ]),
];

List<CircularStackEntry> incomeData = <CircularStackEntry>[
  CircularStackEntry(
    <CircularSegmentEntry>[
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, Colors.transparent),
      CircularSegmentEntry(0, salary.color),
      CircularSegmentEntry(0, incomeGifts.color),
    ],
  ),
];

int expenses = 100;
int income = 200;

final number = ValueNotifier(0);
final _pageOptions = [Expenses(), Income()];

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: number,
      builder: (context, value, child) {
        return _pageOptions[number.value];
      },
    );
  }
}

//страничка расходов
class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  ValueNotifier(number.value++);
                });
              },
              child: CircularGraph('Expenses', expensesData),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CustomIcon(groceries.name, groceries.color, groceries.icon,
                  groceries.serial),
              CustomIcon(health.name, health.color, health.icon, health.serial),
              CustomIcon(gifts.name, gifts.color, gifts.icon, gifts.serial),
              CustomIcon(transport.name, transport.color, transport.icon,
                  transport.serial)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomIcon(shopping.name, shopping.color, shopping.icon,
                  shopping.serial),
              CustomIcon(
                  leisure.name, leisure.color, leisure.icon, leisure.serial)
            ],
          )
        ],
      ),
    ));
  }
}

//страничка заработка
class Income extends StatefulWidget {
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Center(
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    ValueNotifier(number.value--);
                  });
                },
                child: CircularGraph('Income', incomeData)),
          ),
          Row(
            children: <Widget>[
              CustomIcon(
                salary.name,
                salary.color,
                salary.icon,
                salary.serial,
                income: true,
              ),
              CustomIcon(
                incomeGifts.name,
                incomeGifts.color,
                incomeGifts.icon,
                incomeGifts.serial,
                income: true,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

//диаграмма расходов
class CircularGraph extends StatefulWidget {
  final String name;
  final graphData;

  CircularGraph(this.name, this.graphData);

  @override
  _CircularGraphState createState() => _CircularGraphState();
}

class _CircularGraphState extends State<CircularGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedCircularChart(
            key: widget.name == 'Expenses' ? expensesKey : incomeKey,
            size: const Size(280.0, 280.0),
            initialChartData: widget.graphData,
            chartType: CircularChartType.Radial,
            edgeStyle: SegmentEdgeStyle.round,
            holeRadius: 65,
          ),
          Positioned(
            top: 100,
            left: 40,
            right: 40,
            bottom: 100,
            child: Column(
              children: <Widget>[
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 23),
                ),
                widget.name == 'Expenses'
                    ? Column(
                        children: <Widget>[
                          Text(
                            '\$$expenses',
                            style: TextStyle(
                                fontSize: 24, color: Color(hexColor('41B619'))),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: Text(
                              '\$$income',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(hexColor('FF0000'))),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Text(
                            '\$$income',
                            style: TextStyle(
                                fontSize: 24, color: Color(hexColor('41B619'))),
                          ),
                          Opacity(
                            opacity: 0.4,
                            child: Text(
                              '\$$expenses',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(hexColor('FF0000'))),
                            ),
                          ),
                        ],
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//иконки
class CustomIcon extends StatefulWidget {
  final String name;
  final Color color;
  final IconData icon;
  final int serial;
  final bool income;

  CustomIcon(this.name, this.color, this.icon, this.serial,
      {this.income = false});

  @override
  _CustomIconState createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      height: 130,
      width: 100,
      child: Column(
        children: <Widget>[
          Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(50),
            color: widget.color,
            child: InkWell(
                onTap: () {
                  sumDialog(context, widget.serial, widget.income);
                },
                splashColor: Colors.white,
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    widget.icon,
                    size: 38,
                    color: Colors.black,
                  ),
                )),
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}

//диалоговое окно
Future<bool> sumDialog(context, int serial, bool income) {
  double sumValue;
  String note;

  DateTime _unformattedDate = DateTime.now();
  String _date =
      DateFormat('dd/MM/yyyy').format(_unformattedDate).substring(0, 10);

  TimeOfDay _unformattedTime = TimeOfDay.now();
  String _time = _unformattedTime.toString().substring(10, 15);

  //выбор даты
  Future<Null> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2016),
        initialDate: initialDate,
        lastDate: DateTime(2020));
    if (picked != null) {
      _date = picked.toString().substring(0, 10);
      
    }
  }

//выбор времени
  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      
      _time = picked.toString().substring(10, 15);
    }
  }

// сам диалог
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

        //контейнер диалогового окна
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: categoriesList[serial].color,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 10, right: 10, bottom: 0),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    //двойная форма
                    Form(
                      key: _formKey,
                      child: Expanded(
                        child: Theme(
                          data: ThemeData(primaryColor: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //надпись с иконкой
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      categoriesList[serial].icon,
                                      size: 17,
                                    ),
                                    Text(
                                      'Expense',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              //разделяющая линия

                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, bottom: 2),
                                child:
                                    CustomPaint(painter: Drawhorizontalline()),
                              ),

                              //время
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 3),
                                  child: Text('$_time $_date')),

                              //форма для суммы
                              TextFormField(
                                onSaved: (a) {
                                  sumValue = int.parse(a).toDouble();
                                },
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty ||
                                      value.toString() == '0') {
                                    return 'Enter a summ';
                                  }
                                  if (value.contains('-')) {
                                    return 'we don\'t support refunds now, sry';
                                  }
                                  return null;
                                },
                                autocorrect: false,
                                decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.account_balance_wallet),
                                  suffixText: 'USD',
                                  labelText: 'Amount',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(20)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              //текстовое поле для заметок
                              TextFormField(
                                onSaved: (a) {
                                  note = a.toString();
                                },
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.short_text),
                                  labelText: 'Note',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                  ],
                ),

                //кнопка готово
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(50),
                      color: greenDone,
                      child: InkWell(
                          onTap: () {
                            if (_formKey.currentState.validate()) {
                              //обновляем график
                              _formKey.currentState.save();
                              if (income) {
                                incomeData[0].entries[serial] =
                                    CircularSegmentEntry(
                                        incomeData[0].entries[serial].value +
                                            sumValue,
                                        categoriesList[serial].color);
                                incomeKey.currentState.updateData(incomeData);
                              } else {
                                expensesData[0].entries[serial] =
                                    CircularSegmentEntry(
                                        expensesData[0].entries[serial].value +
                                            sumValue,
                                        categoriesList[serial].color);
                                expensesKey.currentState
                                    .updateData(expensesData);
                              }

                              // обновляем фаерстор
                              Firestore.instance.runTransaction(
                                  (Transaction transaction) async {
                                CollectionReference reference = Firestore
                                    .instance
                                    .collection('transactionCards');

                                await reference.add({
                                  'sum': sumValue,
                                  'note': note,
                                  'serial': serial,
                                  'time': _time + ' ' + _date
                                });
                              });
                        
                              Navigator.of(context).pop();
                            }
                           
                          },
                          splashColor: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.done,
                              size: 35,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                ),

                //кнопки календаря и времени
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: <Widget>[
                        Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              splashColor: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  size: 27,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                _selectTime(context);
                              },
                              splashColor: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Icon(
                                  Icons.access_time,
                                  size: 27,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

//рисовалка линии
class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(10.0, 0.0), Offset(85.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
