import 'package:flutter/material.dart';
import 'package:orange/ui/wanandroid/wan_android_page.dart';
import 'package:orange/common/component_index.dart';

void main() => runApp(MyApp());

const _MyHomePage = MyHomePage();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ThemeColorUtils.getThemeColor(),

      ),
      home: _MyHomePage,
      routes: {
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: new _BottomNavigationBarExampleStateful(),
      ),
    );
  }
}

class _BottomNavigationBarExampleStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationBarExampleState();
  }
}

const _bottomNavBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('WAN')),
  BottomNavigationBarItem(icon: Icon(Icons.border_all), title: Text('应用')),
];

const appWanAndroidPage = WanAndroidPage();

const appWanAndroidPage_ = WanAndroidPage();

final _appHomePage = <Widget>[appWanAndroidPage, appWanAndroidPage_];

class _BottomNavigationBarExampleState
    extends State<_BottomNavigationBarExampleStateful> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    assert(_bottomNavBarItems.length == _appHomePage.length);
    final bottomNavBar = BottomNavigationBar(
      items: _bottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      body: _appHomePage[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}