import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/trips.dart';

class EditTripsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String tripId = ModalRoute.of(context).settings.arguments;
    final tripsData =
        Provider.of<Trips>(context).items.firstWhere((tri) => tri.id == tripId);
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.grey[100],
      height: double.infinity,
      child: SingleChildScrollView(
              child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(8),
              elevation: 8,
              shadowColor: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: mediaQuery.size.height * 0.283,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: mediaQuery.size.height * 0.0933,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Title',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              tripsData.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: mediaQuery.size.height * 0.0933,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Description',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              tripsData.description,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: mediaQuery.size.height * 0.0933,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Currency',
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            Text(
                              tripsData.currency,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              elevation: 8,
              shadowColor: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Center(
                      widthFactor: 2.47,
                      child: Text(
                        'Participants',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: tripsData.participants
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: double.infinity,
                              child: Text(
                                e.participant,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.teal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
