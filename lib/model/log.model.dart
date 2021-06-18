import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String? id;
  String? userID;
  String? batteryId;
  Timestamp? date;
  double? volts;
  double? percent;


  Log({this.id, this.userID, this.batteryId, this.date, this.volts, this.percent});

  Log.fromJson(String logId ,Map<String, dynamic> parsedJson) :
        id = logId,
        userID = parsedJson['userID'],
        batteryId = parsedJson['batteryId'],
        date = parsedJson['date'],
        volts = parsedJson['volts']?.toDouble(),
        percent = parsedJson['percent']?.toDouble();

  Map<String, Object?> toJson() {
    return {
      'userID': userID,
      'batteryId': batteryId,
      'date': date,
      'volts': volts,
      'percent': percent
    };
  }
}
