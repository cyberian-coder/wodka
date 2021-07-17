import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wodka/app/home/job_entries/job_entries_page.dart';
import 'package:wodka/app/home/jobs/job_list_tile.dart';
import 'package:wodka/app/home/jobs/list_items_builder.dart';
import 'package:wodka/app/home/models/job.dart';
import 'package:wodka/common_widgets/show_alert_dialog.dart';
import 'package:wodka/common_widgets/show_exception_alert_dialog.dart';
import 'package:wodka/services/auth.dart';
import 'package:wodka/services/database.dart';
import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Wod job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
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
            onPressed: () => EditJobPage.show(
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
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Wod>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            confirmDismiss: (DismissDirection direction) async {
              return await _confirmDismissDialog(context);
            },
            child: JobListTile(
              job: job,
              onTap: () =>
                  EditJobPage.show(context, database: database, job: job),
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
