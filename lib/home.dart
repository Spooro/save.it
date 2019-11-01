import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:save_it/screens/Transactions.dart';
import 'package:save_it/screens/login_page.dart';

import 'screens/Categories.dart';
import 'screens/Settings.dart';





class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  int _selectedPage = 0;
  final _pageOptions = [Categories(), Transactions()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _pageOptions.length);
    _tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _selectedPage = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _selectedPage == 0
            ? FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          unselectedItemColor: Colors.grey[600],
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
            _tabController.animateTo(_selectedPage);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                IconData(0xf526, fontFamily: 'icons'),
              ),
              title: Text('Categories'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), title: Text('Transactions'))
          ],
        ),
        drawer: _CustomDrawer(),
        appBar: AppBar(
          title: Text(
            'Save.it',
          ),
          centerTitle: true,
        ),
        body: TabBarView(controller: _tabController, children: _pageOptions));
  }
}

class _CustomDrawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          child: Image.asset(
                            'assets/cat.jpg',
                            height: 80,
                            width: 80,
                          ),
                          elevation: 4,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                       'userUid',
                        style: TextStyle(fontSize: 31),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          _CustomListTile('Settings', Icons.settings, () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Settings(),
              ),
            );
          }),
          _CustomListTile('About us', Icons.info_outline, () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          })
        ],
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final onTap;

  _CustomListTile(this.title, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    icon,
                    size: 35,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
