import 'package:flutter/material.dart';
import 'package:orange/common/component_index.dart';
import 'package:orange/blocs/wan_android_blocs/wan_main_blocs.dart';
import 'package:orange/ui/wanandroid/article_item.dart';
import 'package:orange/ui/wanandroid/repos_item.dart';
import 'package:orange/ui/widget/header_item.dart';


bool isHomeInit = true;

class WanAndroidHomePager extends StatelessWidget {
  const WanAndroidHomePager({Key key, this.labelId}) : super(key: key);

  final String labelId;


  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Swiper(
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        indicator: NumberSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              LogUtil.e("BannerModel: " + model.toString());
              NavigatorUtil.pushWeb(context,
                  title: model.title, url: model.url);
            },
            child: new CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: model.imagePath,
              placeholder: new ProgressView(),
              errorWidget: new Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget buildWxArticle(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ArticleItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      titleColor: Colors.green,
      leftIcon: Icons.library_books,
      titleId: IDs.recWxArticle,
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: IDs.titleWxArticleTree, titleId: IDs.titleWxArticleTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget buildRepos(BuildContext context, List<ReposModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return new ReposItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
      leftIcon: Icons.book,
      titleId: IDs.recRepos,
      onTap: () {
        NavigatorUtil.pushTabPage(context,
            labelId: IDs.titleReposTree, titleId: IDs.titleReposTree);
      },
    ));
    children.addAll(_children);
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController = new RefreshController();

    WanMainBlocs homeBlocs = BlocProvider.of<WanMainBlocs>(context);

    homeBlocs.homeEventStream.listen((event){
      if(labelId == event.labelId){
        _refreshController.sendBack(false, event.status);
      }
    });

    if(isHomeInit){
      isHomeInit = false;
      Observable.just(1).delay(new Duration(microseconds: 500)).listen((_){
        homeBlocs.onRefresh(labelId: labelId);
        homeBlocs.getHotRecItem();
       // homeBlocs.getVersion();
      });

    }


    return new StreamBuilder(
        stream: homeBlocs.bannerStream,
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          return new RefreshScaffold(
            labelId: labelId,
            controller: _refreshController,
            isLoading: snapshot.data ==null,
            enablePullUp: false,
            onRefresh: (){
              return homeBlocs.onRefresh(labelId: labelId);
            },
            child: new ListView(
              children: <Widget>[
                new StreamBuilder(
                    stream: homeBlocs.recItemStream,
                    builder: null),
                buildBanner(context, snapshot.data),
                new StreamBuilder(
                    stream: homeBlocs.recReposStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildRepos(context, snapshot.data);
                    }),
                new StreamBuilder(
                    stream: homeBlocs.recWxArticleStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ReposModel>> snapshot) {
                      return buildWxArticle(context, snapshot.data);
                    })
              ],
            ),
          );
        });
  }
}

class NumberSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 10.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}
