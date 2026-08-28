import 'package:hive/hive.dart';

part 'food_item.g.dart';

@HiveType(typeId: 0)
class FoodItem extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  DateTime storeTime;

  @HiveField(2)
  int keepDays;

  @HiveField(3)
  int notifyId;

  FoodItem({
    required this.name,
    required this.storeTime,
    required this.keepDays,
    required this.notifyId,
  });
}