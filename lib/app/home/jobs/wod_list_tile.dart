import 'package:flutter/material.dart';
import 'package:wodka/app/home/models/job.dart';

class WodListTile extends StatelessWidget {
  const WodListTile({Key key, @required this.wod, this.onTap})
      : super(key: key);
  final Wod wod;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text(wod.name)),
          ),
          ListTile(
              dense: true,
              title: Text(
                wod.wodDescription,
                style: TextStyle(fontSize: 14),
              )),
          Divider(),
          ListTile(
            dense: true,
            leading: Text('My Score:'),
            title: Text(
              '${wod.myScore}',
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
