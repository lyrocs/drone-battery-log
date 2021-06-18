import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/model/log.model.dart';
import 'package:drone_battery_log/ui/widget/selectTension_widget.dart';
import 'package:drone_battery_log/ui/widget/slidable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../menu.dart';

class BatteryLogPage extends StatefulWidget {
  // final String id;
  // const BatteryLogPage({Key? key, required this.id}) : super(key: key);

  @override
  _BatteryLogPageState createState() => _BatteryLogPageState();
}

class _BatteryLogPageState extends State<BatteryLogPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  // Battery aBattery = batteryBloc.currentBattery!;

  @override
  Widget build(BuildContext context) {
    RoutesArguments args = ModalRoute.of(context)!.settings.arguments as RoutesArguments;
    return StreamBuilder(
        stream: batteryBloc.getBatterySnapshot(args.id),
        builder: (context, AsyncSnapshot<QuerySnapshot<Battery>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {

            return _buildLog(snapshot.data!.docs.first.data(), context);
            return Text('Ok');
          }

          return Center(child: CircularProgressIndicator());
        });

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
        title: Text('Drone battery log', style: TextStyle(fontFamily: 'Bangers', fontSize: 30)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff000000),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          _selectPopup(aBattery)
        ],
      ),
      drawer: buildMenu(context),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(5.0)),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 120,
            decoration: new BoxDecoration(
              color: backgroundCard,


              borderRadius: new BorderRadius.all(Radius.circular(10.0))
            ),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tagInfo(aBattery),
                        Text('  ${aBattery.cells}S ${aBattery.capacity}mAh ${aBattery.brand}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      ],
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: aBattery.cycle != null && aBattery.volts != null && aBattery.percent != null,
                            child: Text('${aBattery.cycle} cycles ${aBattery.volts}V  ${aBattery.percent}%', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white))
                            )
                      ],
                    )
                ),

              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10, left: 10), child: Text('Last modifications :')),

          Expanded(child:
            StreamBuilder(
                stream: batteryBloc.getBatteryLogsSnapshot(batteryBloc.currentBattery!.id.toString()),
                builder: (context, AsyncSnapshot<QuerySnapshot<Log>> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(child: Text('No log'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // return Text('OK');
                  return _buildLogList(snapshot);
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectPopup(aBattery) => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: SlidableAction.chage.index,
        child: Text("Charge"),
      ),
      PopupMenuItem(
        value: SlidableAction.discharge.index,
        child: Text("Discharge"),
      ),
      PopupMenuItem(
        value: SlidableAction.stock.index,
        child: Text("Stock"),
      ),
      PopupMenuItem(
        value: SlidableAction.clone.index,
        child: Text("Clone"),
      ),
      PopupMenuItem(
        value: SlidableAction.edit.index,
        child: Text("Edit"),
      ),
      PopupMenuItem(
        value: SlidableAction.delete.index,
        child: Text("Delete"),
      ),
    ],
    onCanceled: () {
      print("You have canceled the menu.");
    },
    onSelected: (value) async {
      switch (value) {
        case 0:
        // double parse + toStringAsFixed fix 3*4.2 = 12.600000000000001
          await batteryBloc.newLogEvent(aBattery.id, double.parse((aBattery.cells!*4.2).toStringAsFixed(2)), 100);
          break;
        case 1:
          openModal(aBattery, context);
          break;
        case 2:
          openModal(aBattery, context);
          break;
        case 3:
          await batteryBloc.clone(aBattery);
          Navigator.pushNamed(context, '/battery/form');
          break;
        case 4:
          batteryBloc.currentBattery = aBattery;
          Navigator.pushNamed(context, '/battery/form');
          break;
        case 5:
          batteryBloc.deleteBattery(aBattery.id);
          Navigator.pushNamed(context, '/battery/list');
          break;
      }
      print("value:$value");
      setState(() {});
    },
    icon: Icon(Icons.more_vert),
  );

  ListView _buildLogList(AsyncSnapshot<QuerySnapshot<Log>> snapshot) {
    return new ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot<Log> document) {
          Log aLog = document.data()!;
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
              title: Text('${aLog.volts}V ${aLog.percent}%  ${lastLogUpdateText(aLog.date)}'),
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
      var lastLogUpdate = DateTime.fromMicrosecondsSinceEpoch(
          aDate.microsecondsSinceEpoch);
      if (today.difference(lastLogUpdate).inDays > 0) {
        lastLogUpdateText =
        '${today.difference(lastLogUpdate).inDays.toString()} days ago';
      } else if (today.difference(lastLogUpdate).inHours > 0) {
        lastLogUpdateText =
        '${today.difference(lastLogUpdate).inHours.toString()} hours ago';
      } else if (today.difference(lastLogUpdate).inMinutes > 0) {
        lastLogUpdateText =
        '${today.difference(lastLogUpdate).inMinutes.toString()} minutes ago';
      } else {
        lastLogUpdateText =
        'now';
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
          Text(aBattery.tag!, style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
