import 'package:Trip_expense/models/participant.dart';
import 'package:Trip_expense/models/participant_acct.dart';
import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../models/participant.dart';
import '../helpers/db_helper.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _trans = [];
  List<Transaction> _transac = [
    Transaction(
      tId: '18000101',
      tranId: '2000-01-18 22:49:18.721502',
      transTitle: 'Food',
      paidBy: Participant(pId: 'p1', participant: 'Nivaa'),
      date: DateTime(2020, 6, 23),
      amount: 5000,
      parAcct: [
        ParticipantAcct(pid: 'p1', amtToPay: 1250, amtPaid: 5000),
        ParticipantAcct(pid: 'p2', amtToPay: 1250, amtPaid: 0),
        ParticipantAcct(pid: 'p3', amtToPay: 1250, amtPaid: 0),
        ParticipantAcct(pid: 'p4', amtToPay: 1250, amtPaid: 0),
      ],
    ),
    Transaction(
      tId: '18000101',
      tranId: '2000-01-17 22:49:18.721502',
      transTitle: 'Travel',
      paidBy: Participant(pId: 'p2', participant: 'Akshayaa'),
      date: DateTime(2020, 6, 22),
      amount: 4000,
      parAcct: [
        ParticipantAcct(pid: 'p1', amtToPay: 1000, amtPaid: 0),
        ParticipantAcct(pid: 'p2', amtToPay: 1000, amtPaid: 4000),
        ParticipantAcct(pid: 'p3', amtToPay: 1000, amtPaid: 0),
        ParticipantAcct(pid: 'p4', amtToPay: 1000, amtPaid: 0),
      ],
    ),
    Transaction(
      tId: '18000101',
      tranId: '2000-01-16 22:49:18.721502',
      transTitle: 'Resort',
      paidBy: Participant(pId: 'p4', participant: 'Thangaraj'),
      date: DateTime(2020, 6, 22),
      amount: 6000,
      parAcct: [
        ParticipantAcct(pid: 'p1', amtToPay: 2000, amtPaid: 0),
        ParticipantAcct(pid: 'p2', amtToPay: 0, amtPaid: 0),
        ParticipantAcct(pid: 'p3', amtToPay: 2000, amtPaid: 0),
        ParticipantAcct(pid: 'p4', amtToPay: 2000, amtPaid: 6000),
      ],
    ),
    Transaction(
      tId: '18000101',
      tranId: '2000-01-15 22:49:18.721502',
      transTitle: 'Shopping',
      paidBy: Participant(pId: 'p3', participant: 'Rathi'),
      date: DateTime(2020, 6, 20),
      amount: 3000,
      parAcct: [
        ParticipantAcct(pid: 'p1', amtToPay: 1000, amtPaid: 0),
        ParticipantAcct(pid: 'p2', amtToPay: 1000, amtPaid: 0),
        ParticipantAcct(pid: 'p3', amtToPay: 1000, amtPaid: 3000),
        ParticipantAcct(pid: 'p4', amtToPay: 0, amtPaid: 0),
      ],
    ),
  ];

  List<Transaction> get trans {
    _trans.sort((a, b) {
      return DateTime.parse(a.tranId).compareTo(DateTime.parse(b.tranId));
    });
    _trans.reversed;
    return [..._trans];
  }

  Future<void> addTransaction(Transaction transaction) async {
    final newTrans = Transaction(
      tId: transaction.tId,
      tranId: DateTime.now().toString(),
      transTitle: transaction.transTitle,
      paidBy: transaction.paidBy,
      date: transaction.date,
      amount: transaction.amount,
      parAcct: transaction.parAcct,
    );
    _trans.insert(0, newTrans);

    await DBHelper.insertTransaction(
      'transactions',
      {
        'tranId': newTrans.tranId,
        'tid': newTrans.tId,
        'transTitle': newTrans.transTitle,
        'pid': newTrans.paidBy.pId,
        'paidBy': newTrans.paidBy.participant,
        'date': newTrans.date.toString(),
        'amount': newTrans.amount.toString(),
      },
    );

    for (int i = 0; i < newTrans.parAcct.length; i++) {
      await DBHelper.insertParAcct(
        'parAccts',
        {
          'id': DateTime.now().toString(),
          'pid': newTrans.parAcct[i].pid,
          'transId': newTrans.tranId,
          'tid': newTrans.tId,
          'amtToPay': newTrans.parAcct[i].amtToPay.toString(),
          'amtPaid': newTrans.parAcct[i].amtPaid.toString(),
        },
      );
    }

    notifyListeners();
  }

  Future<void> fetchAndSetTransactions() async {
    
    final datalist = await DBHelper.getTransaction('transactions');
    final parAcct = await DBHelper.getParAcct('parAccts');
    
    _trans = datalist.map(
      (item) {
        List<ParticipantAcct> parAcct1 = [];
        List<ParticipantAcct> parAcct2 = [];
        Participant partici =
            Participant(pId: item['pid'], participant: item['paidBy']);
        parAcct2 = parAcct.map(
          (part) {
            if (item['tranId'] == part['transId']) {
              return ParticipantAcct(
                pid: part['pid'],
                amtToPay: double.parse(part['amtToPay']),
                amtPaid: double.parse(part['amtPaid']),
              );
            }
            return null;
          },
        ).toList();
        parAcct2.forEach((element) {
          if (element != null) {
            parAcct1.add(element);
          }
        });
        return Transaction(
          tId: item['tid'],
          tranId: item['tranId'],
          transTitle: item['transTitle'],
          paidBy: partici,
          date: DateTime.parse(item['date']),
          amount: double.parse(item['amount']),
          parAcct: parAcct1,
        );
      },
    ).toList();
    _trans.forEach((element) {
      if (element.tId == '18000101') {
        deleteTransaction(element.tranId);
      }
    });
    _transac.forEach((element) {
      _trans.add(element);
    });

    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await DBHelper.deleteTransaction(
      'transactions',
      {'tranId': id},
    );
    print('xxx');
    await DBHelper.deletePartAcct(
      'parAccts',
      {'transId': id},
    );

    _trans.removeWhere((e) => e.tranId == id);
    notifyListeners();
  }

  double totalAmount(List<Transaction> trans) {
    var total = 0.0;
    trans.forEach((e) {
      for (int i = 0; i < e.parAcct.length; i++) total += e.parAcct[i].amtPaid;
    });
    return total;
  }
}
