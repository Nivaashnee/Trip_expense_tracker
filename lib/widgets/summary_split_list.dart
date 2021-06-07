import 'package:flutter/material.dart';

import '../models/summary_split.dart';

class SummarySplitList extends StatelessWidget {
  final SummarySplit split;
  final String currency;
  

  SummarySplitList(this.split, this.currency);

  @override
  Widget build(BuildContext context) {
    double amt;

    amt= split.split['amt'];
    return Card(
      //margin: EdgeInsets.all(8),
      elevation: 8,
      shadowColor: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(
          split.split['from'][0],
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Should pay to ${split.split['to']}',
          style: TextStyle(
            color: Theme.of(context).accentColor,
            fontSize: 14,
          ),
        ),
        trailing: Chip(
          label: Text(
            '${amt.toStringAsFixed(1)} ${currency}',
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6.color,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
