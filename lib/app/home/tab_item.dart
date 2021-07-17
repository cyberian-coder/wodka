import 'package:flutter/material.dart';

enum TabItem { jobs, pr, account }

class TabItemData {
  const TabItemData({@required this.label, @required this.icon});
  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(label: 'Jobs', icon: Icons.work),
    TabItem.pr: TabItemData(label: 'PRs', icon: Icons.view_headline),
    TabItem.account: TabItemData(label: 'Account', icon: Icons.person),
  };
}
