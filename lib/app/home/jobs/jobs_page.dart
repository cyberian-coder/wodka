import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wodka/app/home/jobs/job_list_tile.dart';
import 'package:wodka/app/home/models/job.dart';
import 'package:wodka/common_widgets/show_alert_dialog.dart';
import 'package:wodka/services/auth.dart';
import 'package:wodka/services/database.dart';

import 'edit_job_page.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      cancelActionText: "Cancel",
      defaultActionText: 'Log out',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => EditJobPage.show(
          context,
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map(
                (job) => JobListTile(
                  job: job,
                  onTap: () => EditJobPage.show(context, job: job),
                ),
              )
              .toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error has occurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
