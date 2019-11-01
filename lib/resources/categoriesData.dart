import 'package:flutter/material.dart';

hexColor(value) {
  String newColor = '0xff' + value;
  newColor = newColor.replaceAll('#', '');
  var intColor = int.parse(newColor);
  return intColor;
}

class Categorie {
  final String name;
  final Color color;
  final IconData icon;
  final int serial;

  Categorie({
    @required this.name,
    @required this.color,
    @required this.icon,
    @required this.serial,
  });
}

List<Categorie> categoriesList = [groceries, health, gifts, transport, shopping, leisure, salary, incomeGifts];

Categorie groceries = Categorie(
    color: Color(hexColor('FFC11E')),
    icon: IconData(0xe803, fontFamily: 'icons'),
    name: 'Groceries',
    serial: 0);

Categorie health = Categorie(
    color: Color(hexColor('35D073')),
    icon: IconData(0xe801, fontFamily: 'icons'),
    name: 'Health',
    serial: 1);

Categorie gifts = Categorie(
    color: Color(hexColor('FF53A5')),
    icon: IconData(0xe802, fontFamily: 'icons'),
    name: 'Gifts',
    serial: 2);

Categorie transport = Categorie(
    color: Color(hexColor('5199FF')),
    icon: Icons.directions_bus,
    name: 'Transport',
    serial: 3);

Categorie shopping = Categorie(
    color: Color(hexColor('FF6E4E')),
    icon: IconData(0xf290, fontFamily: 'icons'),
    name: 'Shopping',
    serial: 4);

Categorie leisure = Categorie(
    color: Color(hexColor('C728FF')),
    icon: Icons.theaters,
    name: 'Leisure',
    serial: 5);

Categorie salary = Categorie(
    color: Color(hexColor('35D073')),
    icon: Icons.attach_money,
    name: 'Salary',
    serial: 6);

Categorie incomeGifts = Categorie(
    color: Color(hexColor('FF53A5')),
    icon: IconData(0xe802, fontFamily: 'icons'),
    name: 'Gifts',
    serial: 7);
