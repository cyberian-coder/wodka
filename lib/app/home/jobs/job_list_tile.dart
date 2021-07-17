import 'package:flutter/material.dart';
import 'package:wodka/app/home/job_entries/format.dart';
import 'package:wodka/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(
                child: Text('${Format.dayOfWeek(date)}, ${Format.date(date)}')),
          ),
          Divider(),
          ListTile(
              title: Text(
            job.wodDescription,
            style: TextStyle(fontSize: 14),
          )),
          Divider(),
          ListTile(
            //dense: true,
            title: Text('My score: A) ${job.myScore}'),
            trailing: Icon(Icons.chevron_right),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
