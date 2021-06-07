import 'package:flutter/foundation.dart';

import './participant.dart';
import './participant_acct.dart';

class Transaction {
  final String tId;
  final String tranId;
  final String transTitle;
  final Participant paidBy;
  final DateTime date;
  final double amount;
  final List<ParticipantAcct> parAcct;

  Transaction({
    @required this.tId,
    @required this.tranId,
    @required this.transTitle,
    @required this.paidBy,
    @required this.date,
    @required this.amount,
    @required this.parAcct,
  });
}
