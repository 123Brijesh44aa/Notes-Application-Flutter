

import 'package:hive/hive.dart';
import 'package:learn_hive/model/notes_model.dart';

class Boxes{

  static Box<NotesModel> getData() => Hive.box<NotesModel>("notes");
}