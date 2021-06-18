import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/ui/widget/textform_widget.dart';
import 'package:flutter/material.dart';

class BatteryFormPage extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<BatteryFormPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController tagController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController cellsController = TextEditingController();
  TextEditingController cycleController = TextEditingController();

  initValues() {
    if (batteryBloc.currentBattery == null) {
      batteryBloc.initEmptyBattery();
    }
    var currentBattery = batteryBloc.currentBattery!;
    tagController.text = currentBattery.tag != null ? currentBattery.tag.toString(): '';
    brandController.text = currentBattery.brand != null ? currentBattery.brand.toString(): '';
    capacityController.text =  currentBattery.capacity != null ? currentBattery.capacity.toString(): '';
    cellsController.text =   currentBattery.cells != null ? currentBattery.cells.toString(): '';
    cycleController.text = currentBattery.cycle != null ? currentBattery.cycle.toString() : '';
  }

  @override
  void initState() {
    initValues();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: Color(0xff000000),
        appBar: AppBar(
          title: Text('Drone battery log'),
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff000000),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child:
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyTextField(label: 'Tag',controller:  tagController,textInputType:  TextInputType.text, placeholder: '', onChange: (value) {}),
                    MyTextField(label: 'Brand',controller: brandController,textInputType:  TextInputType.text,placeholder:  '', onChange: (value) {}),
                    MyTextField(label: 'Cells (S)',controller:  cellsController,textInputType:  TextInputType.number,placeholder:  '', onChange: (value) {}),
                    MyTextField(label: 'Capacity (mAh)',controller:  capacityController,textInputType:  TextInputType.number,placeholder:  '', onChange: (value) {}),
                    MyTextField(label: 'Cycle', controller: cycleController,textInputType:  TextInputType.number,placeholder:  '', onChange: (value) {}),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            batteryBloc.currentBattery!.tag = tagController.text.toString();
                            batteryBloc.currentBattery!.brand = brandController.text.toString();
                            batteryBloc.currentBattery!.cells = int.parse(cellsController.text);
                            batteryBloc.currentBattery!.capacity = int.parse(capacityController.text);
                            batteryBloc.currentBattery!.cycle = int.parse(cycleController.text);
                            await batteryBloc.upsert();
                            Navigator.pushNamed(context, '/battery/list');
                          }
                        },
                        child: Text('Submit')
                    )
                  ],
                ),
              )
          ),
        ),

    );
  }
}