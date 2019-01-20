import 'package:orange/common/component_index.dart';

class LanguageUtils{
    static String getString(String id){
        if(!zhValue.containsKey(id)){
          throw Exception("getString key is null");
        }
        return zhValue[id];
    }
}