import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/ui/widget/selectTension_widget.dart';
import 'package:drone_battery_log/ui/widget/slidable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BatteryListPage extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<BatteryListPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late final SlidableController slidableController;

  void initState() {
    // batteryBloc.getLocalBatteryList();
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Color(0xff090909),
      appBar: AppBar(
        // elevation: 0,
        toolbarHeight: 35,
        title: Text('Drone battery log',
            style: TextStyle(fontFamily: 'Bangers', fontSize: 30)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff000000),
          leading: Text('')
      ),
      body: WillPopScope(
          onWillPop: () async => false,
          child: _buildBatteryList()

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          batteryBloc.initEmptyBattery();
          Navigator.pushNamed(context, '/battery/form');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Consumer<BatteryBloc> _buildBatteryList() {
      return Consumer<BatteryBloc>(
        builder: (context, model, child) {
          if (model.batteries.length == 0) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(AppLocalizations.of(context)!.noBatteryFound,
                    style: Theme.of(context)
                .textTheme
                .headline2),
                Padding(padding: EdgeInsets.only(top: 20)),
                Text(AppLocalizations.of(context)!.clickToAddBattery, style: Theme.of(context)
                    .textTheme
                    .headline2)
              ]));
          }
          return ListView.builder(
              itemCount: model.batteries.length,
              itemBuilder: (BuildContext ctx, int index) {
                return _buildBatteryListItem(model.batteries[index]);
              }
          );
        }
      );
  }

  SlidableWidget _buildBatteryListItem(Battery aBattery) {
    Color backgroundCard = Color(0xff2a9d8f);
    if (aBattery.percent != null) {
      if (aBattery.percent! < 20) {
        backgroundCard = Color(0xffe76f51);
      } else if (aBattery.percent! < 70) {
        backgroundCard = Color(0xfff4a261);
      }
    }

    return SlidableWidget(
      child: GestureDetector(
        onTap: () async {
          batteryBloc.currentBatteryId = aBattery.id;
          Navigator.pushNamed(context, '/battery/log',
              arguments: RoutesArguments(aBattery.id.toString()));
        },
        child: Card(
            color: backgroundCard,
            child: Padding(
              padding:
              EdgeInsets.only(top: 2, bottom: 5, left: 8, right: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Tag
                      Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: tagInfo(aBattery)),
                      // Separator
                      Container(width: 1, height: 60, color: Colors.grey),
                      // Brand, Cells, Capacity
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('${aBattery.brand}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2)
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                  '${aBattery.cells}S ${aBattery.capacity}mAh',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2)),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Vols
                      Visibility(
                          visible: aBattery.volts != null,
                          child: Text('${aBattery.volts}V',
                              style:
                              Theme.of(context).textTheme.headline2)),
                      // Percent
                      Visibility(
                          visible: aBattery.percent != null,
                          child: Text('${aBattery.percent}%',
                              style:
                              Theme.of(context).textTheme.headline2)),
                      // Cycles
                      Visibility(
                          visible: aBattery.cycle != null,
                          child: Text('${aBattery.cycle} ${AppLocalizations.of(context)!.cycles}',
                              style:
                              Theme.of(context).textTheme.headline2)),
                      // Lastlogupdate
                      lastLogUpdateText(aBattery),
                    ],
                  ),
                ],
              ),
            )),
      ),
      onDismissed: (action) =>
          dismissSlidableItem(context, aBattery, action),
    );
  }



  void dismissSlidableItem(
      BuildContext context, Battery aBattery, SlidableAction action) async {
    switch (action) {
      case SlidableAction.chage:
        // double parse + toStringAsFixed fix 3*4.2 = 12.600000000000001
        batteryBloc.createLog(aBattery.id,
            double.parse((aBattery.cells! * 4.2).toStringAsFixed(2)), 100);
        // setState(() {});
        break;
      case SlidableAction.discharge:
        openModal(aBattery, false, context);
        break;
      case SlidableAction.stock:
        openModal(aBattery, true, context);
        break;
      case SlidableAction.clone:
        await batteryBloc.clone(aBattery);
        Navigator.pushNamed(context, '/battery/form');
        break;
      case SlidableAction.edit:
        batteryBloc.tempBattery = aBattery;
        Navigator.pushNamed(context, '/battery/form');
        break;
      case SlidableAction.delete:
        batteryBloc.deleteBattery(aBattery.id);
        break;
    }
  }


  Widget tagInfo(aBattery) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
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

  Widget lastLogUpdateText(aBattery) {
    var today = DateTime.now();
    String lastLogUpdateText = '';
    if (aBattery.lastLogUpdate != null) {
      var lastLogUpdate = DateTime.fromMicrosecondsSinceEpoch(
          aBattery.lastLogUpdate!);
      if (today.difference(lastLogUpdate).inDays > 0) {
        lastLogUpdateText =
            '${today.difference(lastLogUpdate).inDays.toString()} ${AppLocalizations.of(context)!.days}';
      } else if (today.difference(lastLogUpdate).inHours > 0) {
        lastLogUpdateText =
            '${today.difference(lastLogUpdate).inHours.toString()} ${AppLocalizations.of(context)!.hours}';
      } else if (today.difference(lastLogUpdate).inMinutes > 0) {
        lastLogUpdateText =
            '${today.difference(lastLogUpdate).inMinutes.toString()} ${AppLocalizations.of(context)!.minutes}';
      } else {
        lastLogUpdateText = AppLocalizations.of(context)!.now;
      }
    }
    return Text(lastLogUpdateText,
        style: Theme.of(context).textTheme.headline2);
  }
}
