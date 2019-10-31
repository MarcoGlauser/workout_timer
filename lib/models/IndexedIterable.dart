import 'package:get_it/get_it.dart';
import 'package:workout_timer/provider/DatabaseService.dart';

import 'IndexedObject.dart';

class IndexedIterable<T extends IndexedObject>{
  List<T> _list = [];

  int get length => _list.length;

  add(T t){
    _list.add(t);
  }

  remove(T t){
    _list.remove(t);
    for(int i = t.index; i < _list.length; i ++){
      T element = _list[i];
      element.index--;
      _saveObject(t);
    }
  }

  reorder()

  int _compare(T left, T right){
    return left.index.compareTo(right.index);
  }

  _saveObject(T t){
    DatabaseService _db = GetIt.instance.get<DatabaseService>();
    //_db.saveExercise(t);
  }
}