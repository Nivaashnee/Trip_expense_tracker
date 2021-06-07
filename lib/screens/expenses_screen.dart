import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/transactions_list.dart';

import '../models/transaction.dart';

import '../providers/transactions.dart';

class ExpensesScreen extends StatelessWidget {
  static const routeName = '/expence-screen';

  @override
  Widget build(BuildContext context) {
    final String tripId = ModalRoute.of(context).settings.arguments;

    //final transactions = Provider.of<Transactions>(context)
    //    .trans
    //    .where((trans) => trans.tId == tripId)
    //    .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.grey[100],
            //height: mediaQuery.size.height * 0.60,

            child: FutureBuilder(
              future: Provider.of<Transactions>(context, listen: false)
                  .fetchAndSetTransactions(),
              builder: (ctx, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Transactions>(
                      child: Center(child: Text('No transactions added yet')),
                      builder: (ctx, transactions, ch) {
                        var count = 0;
                        List<Transaction> transac = [];
                        transactions.trans.forEach((trans) {
                          if (trans.tId == tripId) {
                            count++;
                            transac.add(trans);
                          }
                        });
                        return (count <= 0)
                            ? ch
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: count,
                                      itemBuilder: (ctx, i) => TransactionsList(
                                          transac[count - i - 1], tripId),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    child: Text(
                                      '*longpress to delete expense',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
