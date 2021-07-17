import 'package:flutter/material.dart';
import 'package:wodka/app/home/job_entries/format.dart';
import 'package:wodka/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap})
      : super(key: key);
  final Wod job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text(job.name)),
          ),
          ListTile(
              dense: true,
              title: Text(
                job.wodDescription,
                style: TextStyle(fontSize: 14),
              )),
          Divider(),
          ListTile(
            dense: true,
            leading: Text('My Score:'),
            title: Text(
              '${job.myScore}',
              style: TextStyle(color: Colors.teal[800], fontSize: 16),
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
