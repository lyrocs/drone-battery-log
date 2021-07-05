import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/ui/widget/textform_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


computePercent(double tension, Battery aBattery) {
  double max = aBattery.cells!.toDouble() * 4.4;
  double min = aBattery.cells!.toDouble() * 3.4;
  if (tension == 0 || tension < min || tension > max) {
    return null;
  }
  tension = tension / aBattery.cells!;
  int percent = (((tension - 3.6) * 100) / (4.2 - 3.6)).round();

  if (percent > 100) {
    percent = 100;
  } else if (percent < 0) {
    percent = 0;
  }
  return percent;
}

Future<void> openModal(Battery aBattery, bool isStock, context) async {
  TextEditingController voltsController = TextEditingController();
  TextEditingController percentController = TextEditingController();


  if (isStock) {
    double tension = aBattery.cells!.toDouble() * 3.8;
    voltsController.text = tension.toStringAsFixed(2);
    int? percent = computePercent(tension, aBattery);
    if (percent != null) {
      percentController.text = percent.toString();
    }
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.selectVoltage),
          children: <Widget>[
            MyTextField(
                controller: voltsController,
                label: AppLocalizations.of(context)!.voltage,
                placeholder: AppLocalizations.of(context)!.volts,
                textInputType: TextInputType.numberWithOptions(decimal: true),
                onChange: (value) {
                  int? percent = computePercent(double.parse(value.replaceAll(',', '.')), aBattery);
                  if (percent != null) {
                    percentController.text = percent.toString();
                  }
                }),
            MyTextField(
              controller: percentController,
              label: AppLocalizations.of(context)!.percent,
              placeholder: '%',
              textInputType: TextInputType.numberWithOptions(decimal: true),
              onChange: (value) {},
            ),
            ElevatedButton(
                onPressed: () {
                  if (voltsController.text != '' &&
                      percentController.text != '') {
                    batteryBloc.createLog(
                        aBattery.id,
                        double.parse(voltsController.text.replaceAll(',', '.')),
                        double.parse(
                            percentController.text.replaceAll(',', '.')));
                    // Navigator.pushNamed(context, '/battery/list');
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.submit)),
          ],
        );
      });
}
