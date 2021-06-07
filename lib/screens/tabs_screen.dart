import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/expenses_screen.dart';
import '../screens/statistics_screen.dart';
import '../screens/add_transactions_screen.dart';
import '../screens/add_trips_screen.dart';
import '../screens/edit_trips_screen.dart';
import '../screens/tab_bar_screen.dart';

import '../providers/trips.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs-screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Map<String, Object>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': ExpensesScreen(),
      },
      {
        'page': StatisticsScreen(),
      },
      {
        'page': TabBaScreen(),
      },
      {
        'page': EditTripsScreen(),
      },
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String tripId = ModalRoute.of(context).settings.arguments;
    final tripsData =
        Provider.of<Trips>(context).items.firstWhere((tri) => tri.id == tripId);

    var bottomNavigation = BottomNavigationBar(
      onTap: _selectPage,
      //showUnselectedLabels: true,
      backgroundColor: Colors.pink,
      unselectedItemColor: Colors.teal,
      selectedItemColor: Theme.of(context).accentColor,
      currentIndex: _selectedPageIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.monetization_on),
          title: Text('Expenses'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          title: Text('Statistics'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Summary'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
    );

    return Scaffold(
      appBar: (_selectedPageIndex !=2 ) ? AppBar(
        title: Text(tripsData.name),
        actions: <Widget>[
          if (_selectedPageIndex == 0)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddTransactionsScreen.routeName,
                  arguments: tripsData,
                );
              },
            ),
          if (_selectedPageIndex == 3)
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddTripsScreen.routeName, arguments: tripId);
                })
        ],
      ) : null,
      body: _pages[_selectedPageIndex]['page'],
      floatingActionButton: (_selectedPageIndex == 0)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AddTransactionsScreen.routeName,
                  arguments: tripsData,
                );
              },
              elevation: 5,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )
          : null,
      bottomNavigationBar: bottomNavigation,
    );
  }
}
