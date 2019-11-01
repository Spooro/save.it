import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:save_it/widgets/TransactionsCard.dart';
import 'package:save_it/resources/categoriesData.dart';
import 'package:save_it/resources/colors.dart';
import 'Categories.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    //стримбилдер списка карточек
    return StreamBuilder(
        stream: Firestore.instance
            .collection('transactionCards')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // индикатор загрузки
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          return CardListView(documents: snapshot.data.documents);
        });
  }
}

class CardListView extends StatelessWidget {
  final List<DocumentSnapshot> documents;

  CardListView({this.documents});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        String sum = documents[index].data['sum'].toString();
        String note = documents[index].data['note'];
        String time = documents[index].data['time'];
        int serial = documents[index].data['serial'];

        return Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
                flex: 30,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Material(
                    color: categoriesList[serial].color,
                    elevation: 10,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {
                        // тап на карточку
                      },
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 120,
                        child: Center(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Icon(
                                      categoriesList[serial].icon,
                                      color: Colors.black,
                                      size: 57,
                                    ),
                                  ),
                                ),
                                flex: 3,
                              ),
                              Container(
                                height: 120,
                                width: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              Expanded(
                                flex: 10,
                                child: Container(
                                  child: Stack(
                                    children: <Widget>[
                                      //время
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 14, bottom: 3),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            time,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),

                                      //кнопка изменить
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: PopupMenuButton(
                                            elevation: 10,
                                            onSelected: (a) {
                                              //изменитьб
                                              a == 'edit'
                                                  ? editSumDialog(
                                                      context,
                                                      serial,
                                                      serial > 5 ? true : false,
                                                      sum,
                                                      note,
                                                      time,
                                                      documents,
                                                      index)

                                                  //удалитьб
                                                  : Firestore.instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction.get(
                                                              documents[index]
                                                                  .reference);
                                                      await transaction.delete(
                                                          snapshot.reference);
                                                    });
                                            },
                                            icon: Icon(Icons.more_vert),
                                            itemBuilder:
                                                (BuildContext context) {
                                              return [
                                                PopupMenuItem(
                                                  child: Text('Edit'),
                                                  value: 'edit',
                                                ),
                                                PopupMenuItem(
                                                  child: Text('Delete'),
                                                  value: '',
                                                )
                                              ];
                                            },
                                          )),

                                      //сумма и заметка
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                sum.toString(),
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                note,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 21),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Expanded(
              flex: 4,
              child: Container(),
            )
          ],
        );
        //карточки
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 10,
        );
      },

      // количество элементов
      itemCount: documents.length,
    );
  }
}

Future<bool> editSumDialog(context, int serial, bool income, String sum,
    String note, String time, List<DocumentSnapshot> documents, int index) {
  //выбор даты
  Future<Null> _selectDate(BuildContext context) async {
    DateTime date = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2016),
        initialDate: date,
        lastDate: DateTime(2020));
    if (picked != null) {
      time = time.substring(0, 5) +
          ' ' +
          DateFormat('dd/MM/yyyy').format(picked).substring(0, 10);
    }
  }

//выбор времени
  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay timeOfDay = TimeOfDay.now();
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );
    if (picked != null) {
      time = picked.toString().substring(10, 15) + time.substring(5, 15);
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
                                child: Text(time),
                              ),

                              //форма для суммы
                              TextFormField(
                                onSaved: (a) {
                                  sum = a;
                                },
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                                initialValue: sum,
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
                                  note = a;
                                },
                                style: TextStyle(color: Colors.black),
                                initialValue: note,
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
                              _formKey.currentState.save();
                              //обновляем график

                              // обновляем фаерстор

                              Firestore.instance
                                  .runTransaction((transaction) async {
                                DocumentSnapshot snapshot = await transaction
                                    .get(documents[index].reference);
                                await transaction.update(snapshot.reference, {
                                  'serial': serial,
                                  'note': note,
                                  'sum': sum,
                                  'time': time
                                });
                              });
                            }
                            Future.delayed(Duration.zero,
                                () => Navigator.of(context).pop());
                            // ;
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
