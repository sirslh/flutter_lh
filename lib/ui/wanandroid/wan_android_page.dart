import 'package:flutter/material.dart';
import 'package:orange/common/component_index.dart';
import 'package:orange/ui/wanandroid/wan_android_home_page.dart';

class _WanPager {
  final String pageId;

  _WanPager(this.pageId);
}

final List<_WanPager> _allWanPager = <_WanPager>[
  new _WanPager(IDs.wan_home_ids),
  new _WanPager(IDs.wan_project_ids),
  new _WanPager(IDs.wan_event_ids),
  new _WanPager(IDs.wan_system_ids),
];

class WanAndroidPage extends StatelessWidget {
  const WanAndroidPage();

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: _allWanPager.length,
      child: Scaffold(
        appBar: new AppBar(
          title: new _TabView(),
        ),
        body: _TabLayout(),
      ),
    );
  }
}

class _TabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (new TabBar(
        isScrollable: true,
        labelPadding: EdgeInsets.all(12.0),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: new TextStyle(fontSize: Dimens.font_sp16),
        unselectedLabelColor: Colors.black87,
        unselectedLabelStyle: new TextStyle(fontSize: Dimens.font_sp12),
        tabs: _allWanPager.map((_WanPager pager) {
          return new Tab(
            text: LanguageUtils.getString(pager.pageId),
          );
        }).toList()));
  }
}

class _TabLayout extends StatelessWidget {
  Widget buildTabLayout(BuildContext context, _WanPager pager) {
    final String pageId = pager.pageId;

    switch (pageId) {
      case IDs.wan_home_ids:
        return WanAndroidHomePager(labelId: pageId);
      case IDs.wan_project_ids:
        return Container();
      case IDs.wan_event_ids:
        return Container();
      case IDs.wan_system_ids:
        return Container();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new TabBarView(
        children: _allWanPager.map((_WanPager pager) {
      return buildTabLayout(context, pager);
    }).toList());
  }
}
