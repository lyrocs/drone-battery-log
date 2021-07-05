import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/model/log.model.dart';
import 'package:drone_battery_log/ui/widget/selectTension_widget.dart';
import 'package:drone_battery_log/ui/widget/slidable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BatteryLogPage extends StatefulWidget {

  @override
  _BatteryLogPageState createState() => _BatteryLogPageState();
}

class _BatteryLogPageState extends State<BatteryLogPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    RoutesArguments args =
        ModalRoute.of(context)!.settings.arguments as RoutesArguments;
    batteryBloc.currentBatteryId = args.id;
      return Consumer<BatteryBloc>(
          builder: (context, model, child) {
            if (model.battery != null) {
              return _buildLog(model.battery, context);
            } else {
              return Text('');
            }

          }
      );
  }

  @override
  Widget _buildLog(battery, BuildContext context) {
    Battery aBattery = battery;

    Color backgroundCard = Color(0xff2a9d8f);
    if (aBattery.percent != null) {
      if (aBattery.percent! < 20) {
        backgroundCard = Color(0xffe76f51);
      } else if (aBattery.percent! < 70) {
        backgroundCard = Color(0xfff4a261);
      }
    }

    return Scaffold(
      key: _key,
      backgroundColor: Color(0xff000000),
      appBar: AppBar(
        toolbarHeight: 35,
        title: Text('Drone battery log',
            style: TextStyle(fontFamily: 'Bangers', fontSize: 30)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff000000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [_selectPopup(aBattery)],
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(5.0)),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 120,
            decoration: new BoxDecoration(
                color: backgroundCard,
                borderRadius: new BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tagInfo(aBattery),
                        Text(
                          '  ${aBattery.cells}S ${aBattery.capacity}mAh ${aBattery.brand}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: aBattery.cycle != null &&
                                aBattery.volts != null &&
                                aBattery.percent != null,
                            child: Text(
                                '${aBattery.cycle} ${AppLocalizations.of(context)!.cycles} ${aBattery.volts}V  ${aBattery.percent}%',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.white)))
                      ],
                    )),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(AppLocalizations.of(context)!.lastModifications)),
          Expanded(
            child: _buildLogList(batteryBloc.batteryLogs),
          ),
        ],
      ),
    );
  }

  Widget _selectPopup(aBattery) => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: SlidableAction.chage.index,
            child: Text(AppLocalizations.of(context)!.charge),
          ),
          PopupMenuItem(
            value: SlidableAction.discharge.index,
            child: Text(AppLocalizations.of(context)!.discharge),
          ),
          PopupMenuItem(
            value: SlidableAction.stock.index,
            child: Text(AppLocalizations.of(context)!.stock),
          ),
          PopupMenuItem(
            value: SlidableAction.clone.index,
            child: Text(AppLocalizations.of(context)!.clone),
          ),
          PopupMenuItem(
            value: SlidableAction.edit.index,
            child: Text(AppLocalizations.of(context)!.edit),
          ),
          PopupMenuItem(
            value: SlidableAction.delete.index,
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
        onSelected: (value) async {
          switch (value) {
            case 0:
              // double parse + toStringAsFixed fix 3*4.2 = 12.600000000000001
              await batteryBloc.createLog(
                  aBattery.id,
                  double.parse((aBattery.cells! * 4.2).toStringAsFixed(2)),
                  100);
              break;
            case 1:
              openModal(aBattery, false, context);
              break;
            case 2:
              openModal(aBattery, true, context);
              break;
            case 3:
              await batteryBloc.clone(aBattery);
              Navigator.pushNamed(context, '/battery/form');
              break;
            case 4:
              batteryBloc.tempBattery = aBattery;
              Navigator.pushNamed(context, '/battery/form');
              break;
            case 5:
              setState(() {
                batteryBloc.deleteBattery(aBattery.id);
                Navigator.pushNamed(context, '/battery/list');
              });
              break;
          }
        },
        icon: Icon(Icons.more_vert),
      );

  ListView _buildLogList(List<Log> snapshot) {
    List<Log> logList = snapshot..sort((Log a, Log b) {
      return b.date!.compareTo(a.date!);
    });
    return new ListView(
      children: logList.map((Log document) {
        Log aLog = document;
        var color = Colors.green;
        if (aLog.percent! < 20.0) {
          color = Colors.red;
        } else if (aLog.percent! < 90.0) {
          color = Colors.orange;
        }
        return new Card(
          color: Color(0xff264653),
          child: ListTile(
            leading: Container(
              width: 10,
              color: color,
            ),
            title: Text(
                '${aLog.volts}V ${aLog.percent}%  ${lastLogUpdateText(aLog.date)}'),
          ),
        );
      }).toList(),
    );
  }

  Widget RowInfo(label, value) {
    return Card(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 10)),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String lastLogUpdateText(aDate) {
    var today = DateTime.now();
    String lastLogUpdateText = '';
    if (aDate != null) {
      var lastLogUpdate =
          DateTime.fromMicrosecondsSinceEpoch(aDate);
      if (today.difference(lastLogUpdate).inDays > 0) {
        lastLogUpdateText = AppLocalizations.of(context)!
            .lastUpdateDays(today.difference(lastLogUpdate).inDays.toString());
      } else if (today.difference(lastLogUpdate).inHours > 0) {
        lastLogUpdateText = AppLocalizations.of(context)!.lastUpdateHours(
            today.difference(lastLogUpdate).inHours.toString());
      } else if (today.difference(lastLogUpdate).inMinutes > 0) {
        lastLogUpdateText = AppLocalizations.of(context)!.lastUpdateMinutes(
            today.difference(lastLogUpdate).inMinutes.toString());
      } else {
        lastLogUpdateText = AppLocalizations.of(context)!.now;
      }
    }
    return lastLogUpdateText;
  }

  Widget tagInfo(aBattery) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white),
        shape: BoxShape.circle,
        // You can use like this way or like the below line
        //borderRadius: new BorderRadius.circular(30.0),
        color: Color(0xffe9c46a),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(aBattery.tag!,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
