import 'package:cloud_firestore/cloud_firestore.dart';

class Battery {
  String? id;
  String? userID;
  String? tag;
  String? brand;
  int? capacity;
  int? cells;
  double? volts;
  double? percent;
  String? status;
  Timestamp? lastLogUpdate;
  int? cycle;

  Battery({this.id, this.userID, this.tag, this.brand, this.capacity, this.cells, this.volts,
      this.percent, this.status, this.lastLogUpdate, this.cycle});

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
        cycle = parsedJson['cycle'];

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
      'cycle': cycle
    };
  }
}
