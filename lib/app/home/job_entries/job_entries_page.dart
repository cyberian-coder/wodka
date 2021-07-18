import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wodka/app/home/job_entries/entry_list_item.dart';
import 'package:wodka/app/home/job_entries/entry_page.dart';
import 'package:wodka/app/home/jobs/edit_wod_page.dart';
import 'package:wodka/app/home/jobs/list_items_builder.dart';
import 'package:wodka/app/home/models/entry.dart';
import 'package:wodka/app/home/models/job.dart';
import 'package:wodka/common_widgets/show_exception_alert_dialog.dart';
import 'package:wodka/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.wod});
  final Database database;
  final Wod wod;

  static Future<void> show(BuildContext context, Wod wod) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, wod: wod),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
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
    return StreamBuilder<Wod>(
        stream: database.wodStream(wodId: wod.id),
        builder: (context, snapshot) {
          final wod = snapshot.data;
          final wodName = wod?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(wodName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () =>
                      EditWodPage.show(context, database: database, wod: wod),
                ),
                IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () => EntryPage.show(
                        context: context, database: database, job: wod)),
              ],
            ),
            body: _buildContent(context, wod),
          );
        });
  }

  Widget _buildContent(BuildContext context, Wod job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(wod: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
