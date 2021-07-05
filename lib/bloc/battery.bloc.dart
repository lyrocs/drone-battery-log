import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_battery_log/bloc/user.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/model/log.model.dart';

class BatteryBloc {
  final batteriesCollection = FirebaseFirestore.instance
      .collection('batteries')
      .withConverter<Battery>(
          fromFirestore: (snapshot, _) =>
              Battery.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (battery, _) => battery.toJson());

  final logsCollection = FirebaseFirestore.instance
      .collection('logs')
      .withConverter<Log>(
          fromFirestore: (snapshot, _) =>
              Log.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (log, _) => log.toJson());

  Battery? currentBattery;

  getBatteriesSnapshot() {
    return batteriesCollection
        .where('userID', isEqualTo: userBloc.userID)
        .snapshots();
  }

  getBatterySnapshot(batteryId) {
    return batteriesCollection
        .where(FieldPath.documentId, isEqualTo: batteryId)
        .where('userID', isEqualTo: userBloc.userID)
        .snapshots();
  }

  getById(batteryId) async {
    Battery batteryRequest = await batteriesCollection
        .doc(batteryId)
        .get()
        .then((snapshot) => snapshot.data()!);
    currentBattery = batteryRequest;
    print(currentBattery!.toJson());
  }

  clone(aBattery) async {
    initEmptyBattery();
    currentBattery?.userID = userBloc.userID;
    currentBattery?.brand = aBattery.brand;
    currentBattery?.capacity = aBattery.capacity;
    currentBattery?.cells = aBattery.cells;
    currentBattery?.cycle = aBattery.cycle;
  }

  initEmptyBattery() {
    currentBattery = new Battery(userID: userBloc.userID);
  }

  newLogEvent(batteryId, double volts, double percent) async {
    print(volts);
    print(percent);
    Battery batteryRequest = await batteriesCollection
        .doc(batteryId)
        .get()
        .then((snapshot) => snapshot.data()!);

    Timestamp lastLogUpdate = Timestamp.fromDate(DateTime.now());
    Log newLog = new Log(
        userID: userBloc.userID,
        batteryId: batteryId,
        percent: percent,
        volts: volts,
        date: lastLogUpdate);
    print(newLog.toJson());
    await logsCollection.add(newLog);

    await batteriesCollection.doc(batteryId).update({
      'volts': volts,
      'percent': percent,
      'lastLogUpdate': lastLogUpdate,
      'cycle': percent > 90 ? batteryRequest.cycle! + 1 : batteryRequest.cycle!
    });
    await getById(batteryId);
  }

  getBatteryLogsSnapshot(batteryId) {
    // return logsCollection.snapshots();

    return logsCollection
        .where('userID', isEqualTo: userBloc.userID)
        .where('batteryId', isEqualTo: batteryId)
        .orderBy('date', descending: true)
        .snapshots();
  }

  upsert() async {
    if (currentBattery == null) {
      return;
    }
    if (currentBattery!.id != null) {
      await batteriesCollection
          .doc(currentBattery!.id)
          .update(currentBattery!.toJson());
    } else {
      await batteriesCollection.add(currentBattery!);
    }
  }

  deleteBattery(batteryId) async {
    await batteriesCollection.doc(batteryId).delete();
    await logsCollection
        .where('userID', isEqualTo: userBloc.userID)
        .where('batteryId', isEqualTo: batteryId)
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((element) {
        logsCollection.doc(element.id).delete();
      });
    });
  }
}

final batteryBloc = new BatteryBloc();
