import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wodka/app/home/models/wod.dart';
import 'package:wodka/app/home/wods/edit_wod_page.dart';
import 'package:wodka/app/home/wods/list_items_builder.dart';
import 'package:wodka/app/home/wods/wod_list_tile.dart';
import 'package:wodka/common_widgets/show_exception_alert_dialog.dart';
import 'package:wodka/services/database.dart';

class WodsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Wod wod) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteWod(wod);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WODs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () => EditWodPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Wod>>(
      stream: database.wodsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Wod>(
          snapshot: snapshot,
          itemBuilder: (context, wod) => Dismissible(
            key: Key('wod-${wod.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, wod),
            confirmDismiss: (DismissDirection direction) async {
              return await _confirmDismissDialog(context);
            },
            child: WodListTile(
              wod: wod,
              onTap: () =>
                  EditWodPage.show(context, database: database, wod: wod),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _confirmDismissDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
