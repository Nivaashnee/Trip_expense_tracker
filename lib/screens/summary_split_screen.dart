import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/summary_split_list.dart';

import '../models/summary_topay_list.dart';
import '../models/summary_paid_list.dart';
import '../models/summary_table.dart';
import '../models/summary_split.dart';
import '../models/transaction.dart';
import '../models/trip.dart';

import '../providers/transactions.dart';
import '../providers/trips.dart';

class SummarySplitScreen extends StatefulWidget {
  @override
  _SummarySplitScreenState createState() => _SummarySplitScreenState();
}

class _SummarySplitScreenState extends State<SummarySplitScreen> {
  List<Transaction> transactions;
  List<SummaryToPayList> toPay;
  List<SummayPaidList> paid;
  List<SummaryTable> summary;
  List<SummarySplit> split;

  Trip trip;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    toPay = [];
    paid = [];
    summary = [];
    split = [];
    super.didChangeDependencies();
    final String tripId = ModalRoute.of(context).settings.arguments;
    transactions = Provider.of<Transactions>(context)
        .trans
        .where((trans) => trans.tId == tripId)
        .toList();
    trip = Provider.of<Trips>(context)
        .items
        .firstWhere((element) => element.id == tripId);

    // // // // // // // // // // // // // // // //
    // Summary
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
            summary[j].amount += double.parse(
                transactions[i].parAcct[j].amtPaid.toStringAsFixed(2));
            summary[j].amtplus += double.parse(
                    (transactions[i].parAcct[j].amtPaid).toStringAsFixed(2)) -
                double.parse(
                    transactions[i].parAcct[j].amtToPay.toStringAsFixed(2));
          }
        }
      }

      for (int i = 0; i < summary.length; i++) {
        if (summary[i].amtplus < 0) {
          toPay.add(SummaryToPayList({
            'id': summary[i].id,
            'name': summary[i].name,
            'amt': (summary[i].amtplus * -1)
          }));
        }
        if (summary[i].amtplus >= 0) {
          paid.add(SummayPaidList({
            'id': summary[i].id,
            'name': summary[i].name,
            'amt': summary[i].amtplus
          }));
        }
      }

      List<Map<String, List>> eachData = [];

      toPay.forEach((item) {
        List<Map<String, Object>> internal = [];
        paid.forEach((p) {
          internal.add({'to': p.paid['id'], 'name': p.paid['name'], 'amt': 0});
        });
        eachData.add({
          'from': [item.toPay['id']],
          'name': [item.toPay['name']],
          'toList': internal
        });
      });

      while (paid[0].paid['amt'] != 0) {
        paid.sort((a, b) => b.paid['amt'].compareTo(a.paid['amt']));
        toPay.sort((a, b) => b.toPay['amt'].compareTo(a.toPay['amt']));

        int indexFrom = eachData
            .indexWhere((item) => item['from'][0] == toPay[0].toPay['id']);
        int indexTo = eachData[indexFrom]['toList']
            .indexWhere((item) => item['to'] == paid[0].paid['id']);

        if (paid[0].paid['amt'] <= toPay[0].toPay['amt']) {
          //////////
          eachData[indexFrom]['toList'][indexTo]['amt'] += paid[0].paid['amt'];
          /////////
          toPay[0].toPay['amt'] -= paid[0].paid['amt'];
          //print(toPay[0]['x']) ;
          paid[0].paid['amt'] = 0;
          //print(eachData[indexFrom]['toList'][indexTo]['amt']);

        } else {
          ///////////
          eachData[indexFrom]['toList'][indexTo]['amt'] +=
              toPay[0].toPay['amt'];
          /////////
          paid[0].paid['amt'] -= toPay[0].toPay['amt'];
          //print(toPay[0]['x']) ;
          toPay[0].toPay['amt'] = 0;
          //print(eachData[indexFrom]['toList'][indexTo]['amt']);
        }

        //print(eachData[1]['toList'][1]['amt']);

        //print('from:${eachData[indexFrom]['from'][0]} , to:${eachData[indexFrom]['toList'][indexTo]['to']} ,amt: ${eachData[indexFrom]['toList'][indexTo]['amt']}');

        paid.sort((a, b) => b.paid['amt'].compareTo(a.paid['amt']));
        toPay.sort((a, b) => b.toPay['amt'].compareTo(a.toPay['amt']));
      }

      //eachData.forEach((item) {
      //  print('FROM : ${item['name'][0]} ');
      //  print('PAYMENT List');
      //  item['toList'].forEach((element) {
      //    print('To : ${element['name']} , Amount : ${element['amt']}');
      //  });
      //  print('//////');
      //});

      eachData.forEach((item) {
        item['toList'].forEach((element) {
          if (element['amt'] != 0) {
            split.add(SummarySplit({
              'from': item['name'],
              'to': element['name'],
              'amt': element['amt'],
            }));
          }
        });
      });
      //print(split.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (split.length == 0)
        ? Center(child: Text('No settlements yet!..'))
        : Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                'How to settle',
                style: TextStyle(
                  fontSize: 25,
                  color: Theme.of(context).primaryColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: split.length,
                    itemBuilder: (ctx, i) =>
                        SummarySplitList(split[i], trip.currency),
                  ),
                ),
              ),
            ],
          );
  }
}
