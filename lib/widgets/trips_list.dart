import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/tabs_screen.dart';

import '../providers/trips.dart';
//import 'package:random_color/random_color.dart';

class TripsList extends StatelessWidget {
  final String name;
  final String description;
  final String tripId;

  TripsList(
    this.tripId,
    this.name,
    this.description,
  );

  @override
  Widget build(BuildContext context) {
    //print(tripId);
    //final RandomColor _randomColor = RandomColor();
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Theme.of(context).accentColor,
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(TabsScreen.routeName, arguments: tripId);
        },
        trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
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
                        Provider.of<Trips>(context, listen: false)
                            .deleteTrip(tripId);
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
