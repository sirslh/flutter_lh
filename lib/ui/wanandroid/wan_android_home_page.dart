import 'package:flutter/material.dart';
import 'package:orange/common/component_index.dart';
import 'package:orange/blocs/wan_android_blocs/home_blocs.dart';

class WanAndroidHomePager extends StatelessWidget {
  const WanAndroidHomePager({Key key, this.labelId}) : super(key: key);

  final String labelId;

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = new RefreshController();

    HomeBlocs homeBlocs = BlocProvider.of<HomeBlocs>(context);

    return new StreamBuilder(
        stream: null,
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            controller: refreshController,
            isLoading: snapshot.data ==null,
            enablePullUp: false,
            onRefresh: (){
              return homeBlocs.onRefresh(labelId: labelId);
            },
            child: new ListView(),
          );
        });
  }
}
