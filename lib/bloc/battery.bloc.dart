import 'dart:math';

import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/model/log.model.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class BatteryBloc extends ChangeNotifier {

  Box? batteryBox;
  List<Battery> get batteries => batteryBox!.values.toList().cast();
  Battery? get battery => batteryBox!.values.firstWhereOrNull((element) => element.id == currentBatteryId!);
  String? currentBatteryId;
  Battery? tempBattery;

  Box? logBox;
  List<Log> get logs => logBox!.values.toList().cast();
  List<Log> get batteryLogs => logBox!.values.where((element) => element.batteryId == currentBatteryId!).toList().cast();

  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  init() async {
    batteryBox = await Hive.openBox<Battery>('batteriesBox');
    logBox = await Hive.openBox<Log>('logsBox');

    // Clear all local data
    // logBox!.deleteFromDisk();
    // batteryBox!.deleteFromDisk();
    // logBox!.clear();
    // batteryBox!.clear();
    // logBox!.close();
    // batteryBox!.close();
    // print('all closed');
  }

  clone(aBattery) async {
    initEmptyBattery();
    tempBattery?.brand = aBattery.brand;
    tempBattery?.capacity = aBattery.capacity;
    tempBattery?.cells = aBattery.cells;
    tempBattery?.cycle = aBattery.cycle;
  }

  initEmptyBattery() {
    int updatedAt = DateTime.now().microsecondsSinceEpoch;
    tempBattery = new Battery(updatedAt: updatedAt);
  }

  updateBattery(batteryId)  {
    for (int i = 0; i < batteries.length; i++) {
      if (batteries[i].id == batteryId) {
        batteryBox!.putAt(i, tempBattery);
        return;
      }
    }
  }

  createLog(batteryId, double volts, double percent) async {
    int lastLogUpdate = DateTime.now().microsecondsSinceEpoch;
    currentBatteryId = batteryId;

    tempBattery = battery;
    tempBattery!.volts = volts;
    tempBattery!.percent = percent;
    tempBattery!.lastLogUpdate = lastLogUpdate;
    tempBattery!.cycle = percent > 90 ? battery!.cycle! + 1 : battery!.cycle!;
    tempBattery!.updatedAt = lastLogUpdate;
    updateBattery(batteryId);

    Log newLog = new Log(
        id: getRandomString(10),
        userID: null,
        batteryId: batteryId,
        percent: percent,
        volts: volts,
        date: lastLogUpdate,
    updatedAt: lastLogUpdate);
    await logBox!.add(newLog);
    notifyListeners();
  }

  upsert() async {
    if (tempBattery == null) {
      return;
    }
    if (tempBattery!.id == null) {
      tempBattery!.id = getRandomString(10);
      batteryBox!.add(tempBattery);
    } else {
      updateBattery(tempBattery!.id);
    }
    notifyListeners();
  }

  deleteBattery(batteryId) {
    for (int i = 0; i < logs.length; i++) {
      if (logs[i].batteryId == batteryId) {
        logBox!.deleteAt(i);
      }
    }
    for (int i = 0; i < batteries.length; i++) {
      if (batteries[i].id == batteryId) {
        batteryBox!.deleteAt(i);
      }
    }
    notifyListeners();
  }
}

final batteryBloc = new BatteryBloc();
