import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/trip.dart';
import '../models/participant.dart';
import '../models/transaction.dart';
import '../models/participant_acct.dart';
import '../providers/transactions.dart';

class AddTransactionsScreen extends StatefulWidget {
  static const routeName = '/add-transactions';

  @override
  _AddTransactionsScreenState createState() => _AddTransactionsScreenState();
}

class _AddTransactionsScreenState extends State<AddTransactionsScreen> {
  final _form = GlobalKey<FormState>();
  DateTime _selectedDate;
  ValueSetter<bool> onSelectAll;
  List<Participant> selectedParticipant;
  List<ParticipantAcct> partAcct;

  @override
  void initState() {
    super.initState();

    selectedParticipant = [];
    partAcct = [];
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
      print(_selectedDate);
    });
  }

  onSelectedRow(bool selected, Participant user) async {
    setState(() {
      if (selected) {
        selectedParticipant.add(user);
      } else {
        selectedParticipant.remove(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Trip tripData = ModalRoute.of(context).settings.arguments;
    var _newTransacData = Transaction(
      tId: tripData.id,
      tranId: null,
      transTitle: null,
      paidBy: null,
      date: null,
      amount: null,
      parAcct: [],
    );

    void _saveForm() {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      }

      _form.currentState.save();
      if (_selectedDate == null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Date not selected'),
            content: Text(
              'Please select a date',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      if (selectedParticipant == [] ||
          selectedParticipant.isEmpty ||
          selectedParticipant == null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Share not specified'),
            content: Text(
              'Please select share among',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
        return;
      }

      for (int i = 0; i < tripData.participants.length; i++) {
        partAcct.add(
          ParticipantAcct(
              pid: tripData.participants[i].pId, amtToPay: 0, amtPaid: 0),
        );
      }

      for (int i = 0; i < partAcct.length; i++) {
        if (partAcct[i].pid == _newTransacData.paidBy.pId) {
          partAcct[i] = ParticipantAcct(
            pid: partAcct[i].pid,
            amtToPay: double.parse(partAcct[i].amtToPay.toStringAsFixed(2)),
            amtPaid: double.parse(partAcct[i].amtPaid.toStringAsFixed(2)) +
                double.parse(_newTransacData.amount.toStringAsFixed(2)),
          );
        }

        for (int j = 0; j < selectedParticipant.length; j++) {
          if (selectedParticipant[j].pId == partAcct[i].pid) {
            partAcct[i] = ParticipantAcct(
              pid: partAcct[i].pid,
              amtToPay: double.parse(
                  (_newTransacData.amount / selectedParticipant.length)
                      .toStringAsFixed(2)),
              amtPaid: double.parse(partAcct[i].amtPaid.toStringAsFixed(2)),
            );
          }
        }
      }

      _newTransacData = Transaction(
        tId: _newTransacData.tId,
        tranId: null,
        transTitle: _newTransacData.transTitle,
        paidBy: _newTransacData.paidBy,
        date: _selectedDate,
        amount: _newTransacData.amount,
        parAcct: partAcct,
      );
      print(_newTransacData.date);
      Provider.of<Transactions>(context, listen: false)
          .addTransaction(_newTransacData);
      Navigator.of(context).pop();
      FocusScope.of(context).unfocus();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trasaction'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                child: Form(
                  key: _form,
                  child: Card(
                    shadowColor: Theme.of(context).accentColor,
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            onSaved: (value) {
                              _newTransacData = Transaction(
                                tId: _newTransacData.tId,
                                tranId: _newTransacData.tranId,
                                transTitle: value,
                                paidBy: _newTransacData.paidBy,
                                date: _newTransacData.date,
                                amount: _newTransacData.amount,
                                parAcct: _newTransacData.parAcct,
                              );
                            },
                            validator: (value) {
                              if (value.trim() == null ||
                                  value == '' ||
                                  value.trim().isEmpty) {
                                return 'Please Provide a title.';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          DropdownButtonFormField(
                            hint: Text('Paid By'),
                            items: tripData.participants
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(e.participant),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please Select a person.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _newTransacData = Transaction(
                                tId: _newTransacData.tId,
                                tranId: _newTransacData.tranId,
                                transTitle: _newTransacData.transTitle,
                                paidBy: value,
                                date: _newTransacData.date,
                                amount: _newTransacData.amount,
                                parAcct: _newTransacData.parAcct,
                              );
                            },
                            onChanged: (value) {
                              _newTransacData = Transaction(
                                tId: _newTransacData.tId,
                                tranId: _newTransacData.tranId,
                                transTitle: _newTransacData.transTitle,
                                paidBy: value,
                                date: _newTransacData.date,
                                amount: _newTransacData.amount,
                                parAcct: _newTransacData.parAcct,
                              );
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Amount',
                            ),
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              _newTransacData = Transaction(
                                tId: _newTransacData.tId,
                                tranId: _newTransacData.tranId,
                                transTitle: _newTransacData.transTitle,
                                paidBy: _newTransacData.paidBy,
                                date: _newTransacData.date,
                                amount: double.parse(
                                    double.parse(value).toStringAsFixed(2)),
                                parAcct: _newTransacData.parAcct,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          Container(
                            height: 70,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    (_selectedDate == null)
                                        ? 'No Date Chosen'
                                        : 'Picked Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                                  ),
                                ),
                                FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    'Choose Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    _presentDatePicker();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                //margin: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Card(
                  shadowColor: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  child: DataTable(
                    horizontalMargin: 30,
                    headingRowHeight: 70,
                    dividerThickness: 2,
                    showCheckboxColumn: true,
                    columns: const <DataColumn>[
                      DataColumn(
                        tooltip: 'All',
                        label: Text(
                          'Share Among',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                    rows: tripData.participants
                        .map(
                          (e) => DataRow(
                            selected: selectedParticipant.contains(e),
                            onSelectChanged: (selected) {
                              print('row-selected: ${e.participant}');
                              onSelectedRow(selected, e);
                            },
                            cells: [
                              DataCell(
                                Text(e.participant),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                    onSelectAll: onSelectAll,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
