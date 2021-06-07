import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/trips.dart';
import '../providers/transactions.dart';

class TransactionsList extends StatelessWidget {
  final Transaction trans;
  final String tripId;

  

  TransactionsList(this.trans, this.tripId);
  @override
  Widget build(BuildContext context) {
    final tripsData =
        Provider.of<Trips>(context).items.firstWhere((tri) => tri.id == tripId);
    return GestureDetector(
      
      onLongPress: () {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Expense'),
            content: Text(
              'Do you want to delete?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('no'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Provider.of<Transactions>(context, listen: false)
                      .deleteTransaction(trans.tranId);
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '   ${trans.transTitle}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '   ${DateFormat.yMMMd().format(trans.date)}',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            ),
            Container(
              height: 55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '${trans.amount.toStringAsFixed(1)}  ${tripsData.currency}   ',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Paid By: ${trans.paidBy.participant}   ',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ],
              ),
            )
            //ListTile(
            //  title: Text(trans.transTitle),
            //  subtitle: Text(
            //    DateFormat.yMMMd().format(trans.date),
            //  ),
            //  trailing: Text(trans.amount.toString()),
            //),
          ],
        ),
      ),
    );
  }
}
