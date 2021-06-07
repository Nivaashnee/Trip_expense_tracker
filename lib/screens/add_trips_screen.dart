import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../providers/trips.dart';
import '../models/participant.dart';

class AddTripsScreen extends StatefulWidget {
  static const routeName = '/add-trips';

  @override
  _AddTripsScreenState createState() => _AddTripsScreenState();
}

class _AddTripsScreenState extends State<AddTripsScreen> {
  final _descriptionFN = FocusNode();
  final _currencyFN = FocusNode();
  final _form = GlobalKey<FormState>();
  final _textEdit = TextEditingController();
  var _initialTrip = Trip(
    id: null,
    name: '',
    currency: '',
    description: '',
    participants: [],
  );
  var _initValues = {
    'title': '',
    'description': '',
    'currency': '',
  };

  var _part = Participant(
    pId: null,
    participant: '',
  );
  List<Participant> _participants = [];
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final String tripId = ModalRoute.of(context).settings.arguments;
      if (tripId != null) {
        _initialTrip = Provider.of<Trips>(context, listen: false)
            .items
            .firstWhere((tri) => tri.id == tripId);
        _initValues = {
          'title': _initialTrip.name,
          'description': _initialTrip.description,
          'currency': _initialTrip.currency,
        };
        _participants = _initialTrip.participants;
      }
    }

    _isInit = false;
  }

  void _addParticipants() {
    if (_part.participant.trim() == null || _part.participant.trim().isEmpty) {
      return;
    }
    _part = Participant(
        pId: DateTime.now().toString(), participant: _part.participant.trim());
    _participants.add(_part);
    _initialTrip = Trip(
      id: _initialTrip.id,
      name: _initialTrip.name,
      description: _initialTrip.description,
      currency: _initialTrip.currency,
      participants: _participants,
    );
    _textEdit.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFN.dispose();
    _currencyFN.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_initialTrip.id != null) {
      Provider.of<Trips>(context, listen: false)
          .updateTrip(_initialTrip.id, _initialTrip);
    } else {
      Provider.of<Trips>(context, listen: false).addTrip(_initialTrip);
    }
    Navigator.of(context).pop();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add a trip'),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                height: mediaQuery.size.height * 0.286,
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _form,
                  child: Card(
                    elevation: 10,
                    shadowColor: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              initialValue: _initValues['title'],
                              decoration: InputDecoration(
                                labelText: 'Title',
                              ),
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value.trim() == null || value == '') {
                                  return 'Please Provide a title.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_descriptionFN);
                              },
                              onSaved: (value) {
                                _initialTrip = Trip(
                                  id: _initialTrip.id,
                                  name: value.trim(),
                                  currency: _initialTrip.currency,
                                  description: _initialTrip.description,
                                  participants: _initialTrip.participants,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['description'],
                              decoration:
                                  InputDecoration(labelText: 'Description'),
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.sentences,
                              focusNode: _descriptionFN,
                              validator: (value) {
                                if (value.trim() == null) {
                                  return 'Please Provide a description.';
                                }
                                if (value.length <= 4) {
                                  return 'Enter a valid description more than 4 letters.';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_currencyFN);
                              },
                              onSaved: (value) {
                                _initialTrip = Trip(
                                  id: _initialTrip.id,
                                  name: _initialTrip.name,
                                  currency: _initialTrip.currency,
                                  description: value.trim(),
                                  participants: _initialTrip.participants,
                                );
                              },
                            ),
                            TextFormField(
                              initialValue: _initValues['currency'],
                              decoration: InputDecoration(
                                labelText: 'Currency',
                                hintText: 'eg: INR',
                              ),
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.characters,
                              focusNode: _currencyFN,
                              validator: (value) {
                                if (value == null) {
                                  return 'Please Provide a currency.';
                                }
                                if (value.length > 3) {
                                  return 'Please provide a valid currency.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _initialTrip = Trip(
                                  id: _initialTrip.id,
                                  name: _initialTrip.name,
                                  currency: value.trim(),
                                  description: _initialTrip.description,
                                  participants: _initialTrip.participants,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: mediaQuery.size.height * 0.126,
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  shadowColor: Theme.of(context).accentColor,
                  borderOnForeground: false,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    trailing: FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        size: 40,
                      ),
                      onPressed: () {
                        _addParticipants();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    title: TextField(
                      controller: _textEdit,
                      decoration: InputDecoration(
                        labelText: 'Add Participants',
                      ),
                      onChanged: (value) {
                        _part = Participant(
                          pId: null,
                          participant: value.trim(),
                        );
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(3),
                height: mediaQuery.size.height * 0.026,
                child: Text(
                  'Participants',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.5,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                height: mediaQuery.size.height * 0.562,
                child: (_participants.length == 0)
                    ? Center(
                        child: Text(
                          'No Participants added yet.',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _participants.length,
                        itemBuilder: (ctx, i) {
                          return Card(
                            elevation: 10,
                            shadowColor: Theme.of(context).accentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                ' ${_participants[i].participant}',
                                style: TextStyle(fontSize: 18),
                              ),
                              leading: CircleAvatar(
                                child: Text(
                                  (i + 1).toString(),
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: (_initValues['title'].isNotEmpty)
                                      ? null
                                      : Colors.red,
                                ),
                                onPressed: (_initValues['title'].isNotEmpty)
                                    ? null
                                    : () {
                                        setState(() {
                                          _participants.removeWhere((part) =>
                                              part.pId == _participants[i].pId);
                                        });
                                      },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
