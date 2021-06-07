import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../models/participant.dart';

import '../helpers/db_helper.dart';

class Trips with ChangeNotifier {
  List<Trip> _items = [];

  final dummy = Trip(
    id: '18000101',
    name: 'Holiday Trip',
    currency: 'INR',
    description: 'Sample trip',
    participants: [
      Participant(pId: 'p1', participant: 'Nivaa'),
      Participant(pId: 'p2', participant: 'Akshayaa'),
      Participant(pId: 'p3', participant: 'Rathi'),
      Participant(pId: 'p4', participant: 'Thangaraj'),
    ],
  );

  List<Trip> get items {
    _items.sort((a, b) {
      return DateTime.parse(a.id).compareTo(DateTime.parse(b.id));
    });
    _items.reversed;
    return [..._items];
  }

  Future<void> addTrip(Trip trip) async {
    final newTrip = Trip(
        id: DateTime.now().toString(),
        name: trip.name,
        description: trip.description,
        currency: trip.currency,
        participants: trip.participants);
    _items.insert(0, newTrip);

    await DBHelper.insertTrip('trips', {
      'id': newTrip.id,
      'name': newTrip.name,
      'description': newTrip.description,
      'currency': newTrip.currency,
    });

    for (int i = 0; i < newTrip.participants.length; i++) {
      await DBHelper.insertPart('participants', {
        'pid': newTrip.participants[i].pId,
        'tid': newTrip.id,
        'participant': newTrip.participants[i].participant
      });
    }
    notifyListeners();
  }

  Future<void> fetchAndSetTrips() async {
    final dataList = await DBHelper.getTrip('trips');
    final partList = await DBHelper.getPart('participants');

    //print(partList.length);

    _items = dataList.map(
      (item) {
        List<Participant> participant = [];
        List<Participant> participant1 = [];
        participant1 = partList.map(
          (part) {
            if (item['id'] == part['tid']) {
              return Participant(
                  pId: part['pid'], participant: part['participant']);
            }
            //print(item['id']);
            //print(part['tid']);
            return null;
            
          },
        ).toList();
        //print('xxx');
        participant1.forEach((element) {
          if (element != null) {
            participant.add(element);
          }
        });
        //print(participant.length);
        return Trip(
          id: item['id'],
          name: item['name'],
          description: item['description'],
          currency: item['currency'],
          participants: participant,
        );
      },
    ).toList();
    _items.add(dummy);
    notifyListeners();
  }

  Future<void> updateTrip(String tid, Trip trip) async {
    final tripIndex = _items.indexWhere((tri) => tri.id == tid);
    _items[tripIndex] = trip;

    await DBHelper.updateTrips(
      'trips',
      {
        'id': trip.id,
        'name': trip.name,
        'description': trip.description,
        'currency': trip.currency,
      },
    );

    for (int i = 0; i < trip.participants.length; i++) {
      await DBHelper.insertPart('participants', {
        'pid': trip.participants[i].pId,
        'tid': trip.id,
        'participant': trip.participants[i].participant
      });
    }

    notifyListeners();
  }

  Future<void> deleteTrip(String tripId) async {
    print('yyy');
    await DBHelper.deleteTrips(
      'trips',
      {'id': tripId},
    );

    await DBHelper.deleteTrPart(
      'participants',
      {'tid': tripId},
    );

    await DBHelper.deleteTrTrans(
      'transactions',
      {'tid': tripId},
    );

    await DBHelper.deleteTrPartAcct(
      'parAccts',
      {'tid': tripId},
    );

    _items.removeWhere((t) => t.id == tripId);
    notifyListeners();
  }
}
