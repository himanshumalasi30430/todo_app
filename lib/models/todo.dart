import '../Database/database_helper.dart';

class Todo {
  int id;
  String title;
  String subtitle;
  bool isFavorite;

  Todo({this.id, this.isFavorite, this.subtitle, this.title});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnSubtitle: subtitle,
      DatabaseHelper.columnIsFavorite: isFavorite ? 1 : 0,
    };

    if (id != null) {
      map[DatabaseHelper.columnId] = id;
    }

    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.columnId];
    title = map[DatabaseHelper.columnTitle];
    subtitle = map[DatabaseHelper.columnSubtitle];
    isFavorite = map[DatabaseHelper.columnIsFavorite] == 1;
  }
}
