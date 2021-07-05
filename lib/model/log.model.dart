import 'package:hive/hive.dart';

part 'log.model.g.dart';

@HiveType(typeId: 2)
class Log {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? userID;
  @HiveField(2)
  String? batteryId;
  @HiveField(3)
  int? date;
  @HiveField(4)
  double? volts;
  @HiveField(5)
  double? percent;
  @HiveField(6)
  int? updatedAt;



  Log({this.id, this.userID, this.batteryId, this.date, this.volts, this.percent, this.updatedAt});

  Log.fromJson(String logId ,Map<String, dynamic> parsedJson) :
        id = logId,
        userID = parsedJson['userID'],
        batteryId = parsedJson['batteryId'],
        date = parsedJson['date'],
        volts = parsedJson['volts']?.toDouble(),
        percent = parsedJson['percent']?.toDouble(),
        updatedAt = parsedJson['updatedAt'];

  Map<String, Object?> toJson() {
    return {
      'userID': userID,
      'batteryId': batteryId,
      'date': date,
      'volts': volts,
      'percent': percent,
      'updatedAt': updatedAt
    };
  }
}
