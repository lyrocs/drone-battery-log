import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        caption: AppLocalizations.of(context)!.charge,
        color: Colors.green,
        icon: Icons.battery_charging_full,
        onTap: () => onDismissed(SlidableAction.chage),
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.discharge,
        color: Colors.red,
        icon: Icons.battery_alert,
        onTap: () => onDismissed(SlidableAction.discharge),
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.stock,
        color: Colors.amber,
        icon: Icons.move_to_inbox,
        onTap: () => onDismissed(SlidableAction.stock),
      ),
    ],

    /// right side
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: AppLocalizations.of(context)!.clone,
        color: Colors.black45,
        icon: Icons.copy,
        onTap: () => onDismissed(SlidableAction.clone),
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.edit,
        color: Colors.blueAccent,
        icon: Icons.create,
        onTap: () => onDismissed(SlidableAction.edit),
      ),
      IconSlideAction(
        caption: AppLocalizations.of(context)!.delete,
        color: Colors.red,
        icon: Icons.delete,
        onTap: () => onDismissed(SlidableAction.delete),
      ),
    ],
  );
}