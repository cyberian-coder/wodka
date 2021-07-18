import 'package:flutter/material.dart';

enum TabItem { wods, pr, account }

class TabItemData {
  const TabItemData({@required this.label, @required this.icon});
  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.wods: TabItemData(label: 'WODs', icon: Icons.work),
    TabItem.pr: TabItemData(label: 'PRs', icon: Icons.view_headline),
    TabItem.account: TabItemData(label: 'Account', icon: Icons.person),
  };
}
