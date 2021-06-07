import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './participant.dart';

class Trip {
  final String id;
  final String name;
  final String description;
  final String currency;
  final List<Participant> participants;

  Trip({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.currency,
    @required this.participants,
  });
}
