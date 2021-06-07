import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/date.dart';
import '../models/categories.dart';
import '../models/participants_amt.dart';
import '../providers/trips.dart';
import '../providers/transactions.dart';

class StatisticsScreen extends StatefulWidget {
  static const routeName = '/statistic-screen';

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  var _isInit = true;
  int val=1;

  Map<String, double> dataMap1 = new Map();

  Map<String, double> dataMap2 = new Map();

  Map<String, double> dataMap3 = new Map();

  Map<String, double> dataMap = new Map();

  List<double> amtsp;
  List<Date> amtsDate;
  List<Categories> amtsCat;
  List<ParticipantsAmt> amtsPart;

  @override
  void initState() {
    super.initState();
    amtsp = [];
    amtsDate = [];
    amtsCat = [];
    amtsPart = [];

    dataMap = dataMap1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String tripId = ModalRoute.of(context).settings.arguments;
      final tripsData = Provider.of<Trips>(context)
          .items
          .firstWhere((tri) => tri.id == tripId);

      final transactions = Provider.of<Transactions>(context)
          .trans
          .where((trans) => trans.tId == tripId)
          .toList();

      for (int i = 0; i < transactions.length; i++) {
        for (int j = 0; j < transactions.length; j++) {
          if (amtsCat
              .every((element) => element.name != transactions[j].transTitle)) {
            if (transactions[i].transTitle == transactions[j].transTitle) {
              amtsCat.add(Categories(transactions[j].transTitle, 0));
            }
          }
          if (amtsDate
              .every((element) => element.date != transactions[j].date)) {
            if (transactions[i].date == transactions[j].date) {
              //print(transactions[j].date);
              amtsDate.add(Date(transactions[j].date, 0));
            }
          }
        }
      }

      //Date
      for (int i = 0; i < amtsDate.length; i++) {
        for (int j = 0; j < transactions.length; j++) {
          if (amtsDate[i].date == transactions[j].date) {
            amtsDate[i].amount += transactions[j].amount;
          }
        }
      }

      for (int i = 0; i < amtsDate.length; i++) {
        dataMap3.addAll(
            {DateFormat.yMMMd().format(amtsDate[i].date): amtsDate[i].amount});
      }

      // Categories
      for (int i = 0; i < amtsCat.length; i++) {
        for (int j = 0; j < transactions.length; j++) {
          if (amtsCat[i].name == transactions[j].transTitle) {
            amtsCat[i].amount += transactions[j].amount;
          }
        }
      }

      for (int i = 0; i < amtsCat.length; i++) {
        dataMap2.addAll({amtsCat[i].name: amtsCat[i].amount});
      }

      //Participants
      for (int i = 0; i < transactions.length; i++) {
        for (int j = 0; j < transactions[i].parAcct.length; j++) {
          amtsp.add(0);
          if (amtsPart.every((element) =>
              element.name != tripsData.participants[j].participant)) {
            amtsPart
                .add(ParticipantsAmt(tripsData.participants[j].participant, 0));
          }
        }
      }

      for (int i = 0; i < transactions.length; i++) {
        for (int j = 0; j < transactions[i].parAcct.length; j++) {
          amtsp[j] += transactions[i].parAcct[j].amtPaid;
          dataMap1.addAll({tripsData.participants[j].participant: amtsp[j]});
        }
      }

      for (int i = 0; i < amtsPart.length; i++) {
        amtsPart[i].amount = amtsp[i];
      }

      //print(dataMap1);
      //print(dataMap2);
      //print(dataMap3);
      //print(amtsCat.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorList = [
      Colors.amber,
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.red,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.green,
      Colors.grey,
      Colors.indigo,
      Colors.lightBlue,
      Colors.lime,
      Colors.orange,
      Colors.teal,
      Colors.yellow,
      Colors.black,
      Colors.deepPurple,
      Colors.lightGreen,
      Colors.white
    ];
    var mediaQuery = MediaQuery.of(context).size;
    final transac = Provider.of<Transactions>(context);
    final String tripId = ModalRoute.of(context).settings.arguments;
    final transactions = Provider.of<Transactions>(context)
        .trans
        .where((trans) => trans.tId == tripId)
        .toList();
    final trip = Provider.of<Trips>(context)
        .items
        .firstWhere((element) => element.id == tripId);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.height,
          width: double.infinity,
          child: Column(
            children: [
              DropdownButton(
                value: val,
                items: [
                  DropdownMenuItem(
                    child: Text('Participant'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('Category'),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text('Date'),
                    value: 3,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    val = value;
                    if (val == 1) {
                      dataMap = dataMap1;
                    } else if (val == 2) {
                      dataMap = dataMap2;
                    } else {
                      dataMap = dataMap3;
                    }
                  });
                },
              ),
              Card(
                elevation: 8,
                margin: EdgeInsets.all(15),
                shadowColor: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              SizedBox(height: 10),
              Card(
                margin: EdgeInsets.all(10),
                shadowColor: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: Container(
                  height: mediaQuery.height * 0.35,
                  child: (dataMap == null || dataMap.isEmpty)
                      ? Center(
                          child: Text('No Transactions added to show chart!'),
                        )
                      : Center(
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 32.0,
                            chartRadius: mediaQuery.width / 2,
                            showChartValuesInPercentage: true,
                            showChartValues: true,
                            showChartValuesOutside: false,
                            chartValueBackgroundColor: Colors.grey[200],
                            colorList: colorList,
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                            decimalPlaces: 1,
                            showChartValueLabel: true,
                            initialAngle: 0,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                              color: Colors.blueGrey[900].withOpacity(0.9),
                            ),
                            chartType: ChartType.disc,
                          ),
                        ),
                ),
              ),
              (dataMap == null || dataMap.isEmpty)
                  ? Container()
                  : Expanded(
                      child: DataTable(
                        horizontalMargin: 30,
                        headingRowHeight: 70,
                        dividerThickness: 2,
                        showCheckboxColumn: true,
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
                        ],
                        rows: (val == 3)
                            ? amtsDate
                                .map(
                                  (e) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                            '${DateFormat.yMMMd().format(e.date)}'),
                                      ),
                                      DataCell(
                                        Text(e.amount.toString()),
                                      ),
                                    ],
                                  ),
                                )
                                .toList()
                            : (val == 2)
                                ? amtsCat
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(e.name),
                                          ),
                                          DataCell(
                                            Text(e.amount.toStringAsFixed(1)),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList()
                                : amtsPart
                                    .map(
                                      (e) => DataRow(
                                        cells: [
                                          DataCell(
                                            Text(e.name),
                                          ),
                                          DataCell(
                                            Text(e.amount.toString()),
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
      ),
    );
  }
}
