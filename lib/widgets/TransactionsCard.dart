import 'package:flutter/material.dart';

//тупа класс этих картонок
class TransactionCard {
  TransactionCard(
      {this.color,
      this.icon,
      this.sum = 18.24,
      this.time = const [4, 20, 'PM'],
      this.note = 'Я купил батон\nи съел его',
      this.index,
      this.bloc,
      this.snapshot,
      this.serial});

  Color color;
  IconData icon;
  double sum;
  List time;
  String note;
  int index;
var bloc;
  AsyncSnapshot snapshot;
  int serial;
}

//а вот это батя билдер, что строит из объектов класса выше реальные карточки
