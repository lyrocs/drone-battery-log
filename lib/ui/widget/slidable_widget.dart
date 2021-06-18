import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { chage, discharge, stock, clone, edit, delete }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    required this.child,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    child: child,

    /// left side
    actions: <Widget>[
      IconSlideAction(
        caption: 'Charge',
        color: Colors.green,
        icon: Icons.battery_charging_full,
        onTap: () => onDismissed(SlidableAction.chage),
      ),
      IconSlideAction(
        caption: 'Discharge',
        color: Colors.red,
        icon: Icons.battery_alert,
        onTap: () => onDismissed(SlidableAction.discharge),
      ),
      IconSlideAction(
        caption: 'Stock',
        color: Colors.amber,
        icon: Icons.move_to_inbox,
        onTap: () => onDismissed(SlidableAction.stock),
      ),
    ],

    /// right side
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Clone',
        color: Colors.black45,
        icon: Icons.copy,
        onTap: () => onDismissed(SlidableAction.clone),
      ),
      IconSlideAction(
        caption: 'Edit',
        color: Colors.blueAccent,
        icon: Icons.create,
        onTap: () => onDismissed(SlidableAction.edit),
      ),
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => onDismissed(SlidableAction.delete),
      ),
    ],
  );
}