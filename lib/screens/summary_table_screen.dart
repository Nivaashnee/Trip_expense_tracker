import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transactions.dart';
import '../providers/trips.dart';
import '../models/transaction.dart';
import '../models/trip.dart';
import '../models/summary_table.dart';

class SummaryTableScreen extends StatefulWidget {
  final AppBar _appBar;

  SummaryTableScreen(this._appBar);

  @override
  _SummaryTableScreenState createState() => _SummaryTableScreenState();
}

class _SummaryTableScreenState extends State<SummaryTableScreen> {
  List<Transaction> transactions;
  List<SummaryTable> summary;

  Trip trip;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    transactions = [];
    summary = [];

    super.didChangeDependencies();
    final String tripId = ModalRoute.of(context).settings.arguments;
    transactions = Provider.of<Transactions>(context)
        .trans
        .where((trans) => trans.tId == tripId)
        .toList();
    trip = Provider.of<Trips>(context)
        .items
        .firstWhere((element) => element.id == tripId);

    // // // // // // // // // // // // //
    // Table
    if (transactions.length != 0) {
      for (int i = 0; i < transactions.length; i++) {
        for (int j = 0; j < transactions[i].parAcct.length; j++) {
          if (summary.every(
              (element) => element.name != trip.participants[j].participant)) {
            summary.add(SummaryTable(trip.participants[j].pId,
                trip.participants[j].participant, 0, 0));
          }
        }
      }

      for (int i = 0; i < transactions.length; i++) {
        for (int j = 0; j < transactions[i].parAcct.length; j++) {
          if (summary.length != 0) {
            summary[j].amount += double.parse(transactions[i].parAcct[j].amtPaid.toStringAsFixed(2));
            summary[j].amtplus += double.parse(transactions[i].parAcct[j].amtPaid.toStringAsFixed(2)) -
                double.parse(transactions[i].parAcct[j].amtToPay.toStringAsFixed(2));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final transac = Provider.of<Transactions>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.height - widget._appBar.preferredSize.height - 56,
          width: double.infinity,
          child: Column(
            children: [
              Card(
                elevation: 8,
                margin: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                shadowColor: Theme.of(context).accentColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '${transac.totalAmount(transactions).toStringAsFixed(1)} ${trip.currency}',
                          style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color,
                          ),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (summary.length != 0)
                Container(
                  margin: EdgeInsets.all(8),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    shadowColor: Theme.of(context).accentColor,
                    child: DataTable(
                      horizontalMargin: 30,
                      headingRowHeight: 70,
                      dividerThickness: 2,
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Amount',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '+/-',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                      rows: summary
                          .map(
                            (sum) => DataRow(
                              cells: [
                                DataCell(Text(
                                  sum.name,
                                  style: TextStyle(fontSize: 16),
                                )),
                                DataCell(Text(
                                  sum.amount.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 16),
                                )),
                                DataCell(Text(
                                  sum.amtplus.toStringAsFixed(1),
                                  style: TextStyle(fontSize: 16),
                                )),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              if (summary.length != 0)
                Container(
                  margin: EdgeInsets.all(20),
                  child: Text(
                    '*here Amount refers to the total amount paid and +/- refers to the total amount due.',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.red),
                  ),
                ),
              if (summary.length == 0)
                Center(
                  child: Text('No transactions added yet. Start adding some.'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
