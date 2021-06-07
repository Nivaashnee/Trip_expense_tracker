import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_trips_screen.dart';

import '../widgets/trips_list.dart';
import '../providers/trips.dart';

class TripsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final tripsData = Provider.of<Trips>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trips',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        //actions: <Widget>[
        //  IconButton(
        //    icon: Icon(Icons.more_vert),
        //    onPressed: () {},
        //  ),
        //],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          Navigator.of(context).pushNamed(AddTripsScreen.routeName);
        },
      ),
      body: FutureBuilder(
        future: Provider.of<Trips>(context, listen: false).fetchAndSetTrips(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Trips>(
                    child: Center(
                      child: Text('Got no trips yet, start adding some'),
                    ),
                    builder: (ctx, tripsData, ch) => tripsData.items.length <= 0
                        ? ch
                        : Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[100],
                            child: ListView.builder(
                                itemCount: tripsData.items.length,
                                itemBuilder: (_, i) {
                                  return TripsList(
                                    tripsData.items[tripsData.items.length -i -1].id,
                                    tripsData.items[tripsData.items.length -i -1].name,
                                    tripsData.items[tripsData.items.length -i -1].description,
                                  );
                                }),
                          ),
                  ),
      ),
    );
  }
}
