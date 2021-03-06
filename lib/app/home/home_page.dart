import 'package:flutter/material.dart';
import 'package:wodka/app/home/cupertino_home_scaffold.dart';

import 'package:wodka/app/home/tab_item.dart';
import 'package:wodka/app/home/wods/my_stats.dart';
import 'package:wodka/app/home/wods/wods_page.dart';
import 'account/account_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.wods;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.wods: GlobalKey<NavigatorState>(),
    TabItem.myStats: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.wods: (_) => WodsPage(),
      TabItem.myStats: (_) => MyStats(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
