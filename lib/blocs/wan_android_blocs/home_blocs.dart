import 'package:orange/blocs/bloc_provider.dart';

class HomeBlocs extends BlocBase {
  @override
  Future getData({String labelId, int page}) {}

  @override
  void dispose() {}

  @override
  Future onLoadMore({String labelId}) {}

  @override
  Future onRefresh({String labelId}) {}
}
