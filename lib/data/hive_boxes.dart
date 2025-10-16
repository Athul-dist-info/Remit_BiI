import 'package:hive/hive.dart';

class HiveBoxes {
  static Box get userBox => Hive.box('userBox');
}
