import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './summary_table_screen.dart';
import './summary_split_screen.dart';

import '../providers/trips.dart';

class TabBaScreen extends StatefulWidget {
  static const routeName = '/tab-Bar-Screen';

  @override
  _TabBaScreenState createState() => _TabBaScreenState();
}

class _TabBaScreenState extends State<TabBaScreen> {
  @override
  Widget build(BuildContext context) {
    final String tripId = ModalRoute.of(context).settings.arguments;
    final trip = Provider.of<Trips>(context)
        .items
        .firstWhere((element) => element.id == tripId);

    final appBar = AppBar(
      title: Text(trip.name),
      centerTitle: true,
      bottom: TabBar(
        labelColor: Theme.of(context).accentColor,
        indicatorColor: Theme.of(context).accentColor,
        unselectedLabelColor: Colors.white,
        tabs: [
          Tab(
            child: Text('Expense Table'),
          ),
          Tab(
            child: Text('Expense Settlement'),
          ),
        ],
      ),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: TabBarView(
          children: [
            SummaryTableScreen(appBar),
            SummarySplitScreen(),
          ],
        ),
      ),
    );
  }
}
