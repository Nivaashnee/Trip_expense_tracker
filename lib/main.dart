import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/trips_overview_screen.dart';
import './screens/add_trips_screen.dart';
import './screens/expenses_screen.dart';
import './screens/add_transactions_screen.dart';
import './screens/statistics_screen.dart';
import './screens/tabs_screen.dart';
import './screens/tab_bar_screen.dart';

import './providers/trips.dart';
import './providers/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Trips(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Transactions(),
        ),
        
      ],
      child: MaterialApp(
        title: 'Trips Expense manager',
        theme: ThemeData(
          primaryColor: Colors.teal,
          accentColor: Colors.deepOrangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TripsOverviewScreen(),
        routes: {
          AddTripsScreen.routeName: (ctx) => AddTripsScreen(),
          ExpensesScreen.routeName: (ctx) => ExpensesScreen(),
          AddTransactionsScreen.routeName: (ctx) => AddTransactionsScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          StatisticsScreen.routeName: (ctx) => StatisticsScreen(),
          TabBaScreen.routeName: (ctx) => TabBaScreen(),
        },
      ),
    );
  }
}
