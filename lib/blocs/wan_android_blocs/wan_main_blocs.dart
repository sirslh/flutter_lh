import 'dart:collection';

import 'package:orange/blocs/bloc_provider.dart';
import 'package:orange/data/models/models.dart';
import 'package:orange/data/repository/wan_repository.dart';
import 'package:orange/event/event.dart';
import 'package:orange/common/component_index.dart';
import 'package:orange/utils/http_utils.dart';


class WanMainBlocs extends BlocBase {

  HttpUtils httpUtils = new HttpUtils();

  // ignore: close_sinks
  BehaviorSubject<List<BannerModel>> _banner = BehaviorSubject<List<BannerModel>>();

  Stream<List<BannerModel>> get bannerStream => _banner.stream;

  // ignore: close_sinks
  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Stream<StatusEvent> get homeEventStream => _homeEvent.stream.asBroadcastStream();

  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;

  ComModel hotRecModel;

  // ignore: close_sinks
  BehaviorSubject<ComModel> _recItem = BehaviorSubject<ComModel>();

  Sink<ComModel> get _recItemSink => _recItem.sink;

  Stream<ComModel> get recItemStream => _recItem.stream.asBroadcastStream();

  // ignore: close_sinks
  BehaviorSubject<List<ReposModel>> _recRepos = BehaviorSubject<List<ReposModel>>();

  Stream<List<ReposModel>> get recReposStream => _recRepos.stream;

  Sink<List<ReposModel>> get _recReposSink => _recRepos.sink;

  Sink<List<ReposModel>> get _recWxArticleSink => _recWxArticle.sink;

  // ignore: close_sinks
  BehaviorSubject<List<ReposModel>> _recWxArticle = BehaviorSubject<List<ReposModel>>();

  Stream<List<ReposModel>> get recWxArticleStream => _recWxArticle.stream;

  Sink<List<BannerModel>> get _bannerSink => _banner.sink;


  WanRepository wanRepository = new WanRepository();

  Future getHotRecItem() async {
    httpUtils.getRecItem().then((model) {
      hotRecModel = model;
      _recItemSink.add(hotRecModel);
    });
  }
  Future getHomeData(String labelId) {
    getRecRepos(labelId);
    getRecWxArticle(labelId);
    return getBanner(labelId);
  }

  Future getRecRepos(String labelId) async {
    ComReq _comReq = new ComReq(402);
    wanRepository.getProjectList(data: _comReq.toJson()).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _recReposSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getRecWxArticle(String labelId) async {
    int _id = 408;
    wanRepository.getWxArticleList(id: _id).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _recWxArticleSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getBanner(String labelId) {
    return wanRepository.getBanner().then((list) {
      _bannerSink.add(UnmodifiableListView<BannerModel>(list));
    });
  }

//  Future getArticleListProject(String labelId, int page) {
//    return wanRepository.getArticleListProject(page).then((list) {
//      if (_reposList == null) {
//        _reposList = new List();
//      }
//      if (page == 0) {
//        _reposList.clear();
//      }
//      _reposList.addAll(list);
//      _reposSink.add(UnmodifiableListView<ReposModel>(_reposList));
//      _homeEventSink.add(new StatusEvent(
//          labelId,
//          ObjectUtil.isEmpty(list)
//              ? RefreshStatus.noMore
//              : RefreshStatus.idle));
//    }).catchError(() {
//      _reposPage--;
//      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
//    });
//  }
//
//  Future getArticleListProject(String labelId, int page) {
//    return wanRepository.getArticleListProject(page).then((list) {
//      if (_reposList == null) {
//        _reposList = new List();
//      }
//      if (page == 0) {
//        _reposList.clear();
//      }
//      _reposList.addAll(list);
//      _reposSink.add(UnmodifiableListView<ReposModel>(_reposList));
//      _homeEventSink.add(new StatusEvent(
//          labelId,
//          ObjectUtil.isEmpty(list)
//              ? RefreshStatus.noMore
//              : RefreshStatus.idle));
//    }).catchError(() {
//      _reposPage--;
//      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
//    });
//  }
//
//  Future getArticleList(String labelId, int page) {
//    return wanRepository.getArticleList(page: page).then((list) {
//      if (_eventsList == null) {
//        _eventsList = new List();
//      }
//      if (page == 0) {
//        _eventsList.clear();
//      }
//      _eventsList.addAll(list);
//      _eventsSink.add(UnmodifiableListView<ReposModel>(_eventsList));
//      _homeEventSink.add(new StatusEvent(
//          labelId,
//          ObjectUtil.isEmpty(list)
//              ? RefreshStatus.noMore
//              : RefreshStatus.idle));
//    }).catchError(() {
//      _eventsPage--;
//      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
//    });
//  }
//
//  Future getTree(String labelId) {
//    return wanRepository.getTree().then((list) {
//      if (_treeList == null) {
//        _treeList = new List();
//      }
//
//      for (int i = 0, length = list.length; i < length; i++) {
//        String tag = Utils.getPinyin(list[i].name);
//        if (RegExp("[A-Z]").hasMatch(tag)) {
//          list[i].tagIndex = tag;
//        } else {
//          list[i].tagIndex = "#";
//        }
//      }
//      SuspensionUtil.sortListBySuspensionTag(list);
//
//      _treeList.clear();
//      _treeList.addAll(list);
//      _treeSink.add(UnmodifiableListView<TreeModel>(_treeList));
//      _homeEventSink.add(new StatusEvent(
//          labelId,
//          ObjectUtil.isEmpty(list)
//              ? RefreshStatus.noMore
//              : RefreshStatus.idle));
//    }).catchError(() {
//      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
//    });
//  }

  @override
  Future getData({String labelId, int page}) {
    switch (labelId) {
      case IDs.titleHome:
        return getHomeData(labelId);
        break;
      case IDs.titleRepos:
      //  return getArticleListProject(labelId, page);
        break;
      case IDs.titleEvents:
      //  return getArticleList(labelId, page);
        break;
      case IDs.titleSystem:
       // return getTree(labelId);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  void dispose() {
    _banner.close();
    _recRepos.close();
    _recWxArticle.close();
  //  _repos.close();
  //  _events.close();
   // _tree.close();
    _homeEvent.close();
   // _version.close();
    _recItem.close();
   // _recList.close();
  }

  int _reposPage = 0;

  int _eventsPage = 0;

  @override
  Future onLoadMore({String labelId}) {
    int _page = 0;
    switch (labelId) {
      case IDs.titleHome:
        break;
      case IDs.titleRepos:
        _page = ++_reposPage;
        break;
      case IDs.titleEvents:
        _page = ++_eventsPage;
        break;
      case IDs.titleSystem:
        break;
      default:
        break;
    }
    LogUtil.e("onLoadMore labelId: $labelId" +
        "   _page: $_page" +
        "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: _page);
  }

  @override
  Future onRefresh({String labelId}) {
    switch (labelId) {
      case IDs.titleHome:
        getHotRecItem();
        break;
      case IDs.titleRepos:
        _reposPage = 0;
        break;
      case IDs.titleEvents:
        _eventsPage = 0;
        break;
      case IDs.titleSystem:
        break;
      default:
        break;
    }
    LogUtil.e("onRefresh labelId: $labelId" + "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: 0);
  }
}
