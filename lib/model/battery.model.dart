import 'package:hive/hive.dart';

part 'battery.model.g.dart';

@HiveType(typeId: 1)
class Battery {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? userID;
  @HiveField(2)
  String? tag;
  @HiveField(3)
  String? brand;
  @HiveField(4)
  int? capacity;
  @HiveField(5)
  int? cells;
  @HiveField(6)
  double? volts;
  @HiveField(7)
  double? percent;
  @HiveField(8)
  String? status;
  @HiveField(9)
  int? lastLogUpdate;
  @HiveField(10)
  int? cycle;
  @HiveField(11)
  int? updatedAt;

  Battery({this.id, this.userID, this.tag, this.brand, this.capacity, this.cells, this.volts,
      this.percent, this.status, this.lastLogUpdate, this.cycle, this.updatedAt});

  Battery.fromJson(String batteryId ,Map<String, dynamic> parsedJson) :
        id = batteryId,
        userID = parsedJson['userID'],
        tag = parsedJson['tag'],
        brand = parsedJson['brand'],
        capacity = parsedJson['capacity'],
        cells = parsedJson['cells'],
        volts = parsedJson['volts']?.toDouble(),
        percent = parsedJson['percent']?.toDouble(),
        status = parsedJson['status'],
        lastLogUpdate = parsedJson['lastLogUpdate'],
        cycle = parsedJson['cycle'],
        updatedAt = parsedJson['updatedAt'];

  Map<String, Object?> toJson() {
    return {
      'userID': userID,
      'tag': tag,
      'brand': brand,
      'capacity': capacity,
      'cells': cells,
      'volts': volts,
      'percent': percent,
      'status': status,
      'lastLogUpdate': lastLogUpdate,
      'cycle': cycle,
      'updatedAt': updatedAt
    };
  }
}
