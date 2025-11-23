import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActionCodeInfo {
  final String Function(BuildContext context) status;
  final IconData icon;
  final Color backgroundColor;

  const ActionCodeInfo({
    required this.status,
    required this.icon,
    required this.backgroundColor,
  });
}

final Map<String, ActionCodeInfo> actionCodeMap = {
  "CW_INBOUND": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_warehouse_processing,
    icon: Icons.inventory,
    backgroundColor: Colors.purple,
  ),
  "GWMS_ACCEPT": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_order_received,
    icon: Icons.assignment_turned_in,
    backgroundColor: Colors.grey,
  ),
  "GWMS_PACKAGE": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_order_received,
    icon: Icons.assignment_turned_in,
    backgroundColor: Colors.grey,
  ),
  "PU_PICKUP_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_warehouse_processing,
    icon: Icons.inventory_2,
    backgroundColor: Colors.purpleAccent,
  ),
  "GWMS_OUTBOUND": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_warehouse_processing,
    icon: Icons.inventory_2,
    backgroundColor: Colors.purpleAccent,
  ),
  "CW_COMMON_PROCESSING1": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_warehouse_processing,
    icon: Icons.warehouse,
    backgroundColor: Colors.purpleAccent,
  ),
  "SC_INBOUND_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_sorting_center,
    icon: Icons.sync_alt,
    backgroundColor: Colors.deepPurpleAccent,
  ),
  "SC_OUTBOUND_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_sorting_center,
    icon: Icons.sync_alt,
    backgroundColor: Colors.deepPurpleAccent,
  ),
  "PRE_READY_TO_SHIP": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_ready_to_ship,
    icon: Icons.all_inbox,
    backgroundColor: Colors.deepPurpleAccent,
  ),
  "CC_EX_START": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_export_customs,
    icon: Icons.flight_takeoff,
    backgroundColor: Colors.indigo,
  ),
  "CC_EX_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_export_customs,
    icon: Icons.flight_takeoff,
    backgroundColor: Colors.indigo,
  ),
  "LH_HO_IN_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_in_transit,
    icon: Icons.airplane_ticket,
    backgroundColor: Colors.blue,
  ),
  "LH_HO_AIRLINE": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_in_transit,
    icon: Icons.airplane_ticket,
    backgroundColor: Colors.blue,
  ),
  "LH_DEPART": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_in_transit,
    icon: Icons.airplane_ticket,
    backgroundColor: Colors.blue,
  ),
  "LH_ARRIVE": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_arrived_destination,
    icon: Icons.flag_circle,
    backgroundColor: Colors.teal,
  ),
  "COMMON_INTRANSIT": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_arrived_destination,
    icon: Icons.location_city,
    backgroundColor: Colors.teal,
  ),
  "CC_HO_IN_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_import_customs,
    icon: Icons.gavel,
    backgroundColor: Colors.deepPurple,
  ),
  "CC_IM_START": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_import_customs,
    icon: Icons.gavel,
    backgroundColor: Colors.deepPurple,
  ),
  "CC_IM_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_import_customs,
    icon: Icons.gavel,
    backgroundColor: Colors.deepPurple,
  ),
  "CC_HO_OUT_SUCCESS": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_import_customs,
    icon: Icons.gavel,
    backgroundColor: Colors.deepPurple,
  ),
  "GTMS_ACCEPT": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_received_local_courier,
    icon: Icons.local_shipping,
    backgroundColor: Colors.orange,
  ),
  "GTMS_DO_DEPART": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_out_for_delivery,
    icon: Icons.delivery_dining,
    backgroundColor: Colors.deepOrange,
  ),
  "GTMS_STA_SIGN_FAILURE": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_delivery_failed,
    icon: Icons.report_problem,
    backgroundColor: Colors.redAccent,
  ),
  "GSTA_INFORM_BUYER": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_available_pickup,
    icon: Icons.store_mall_directory,
    backgroundColor: Colors.lightGreen,
  ),
  "GTMS_WAIT_SELF_PICK": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_available_pickup,
    icon: Icons.store_mall_directory,
    backgroundColor: Colors.lightGreen,
  ),
  "GTMS_STA_SIGNED": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_available_pickup,
    icon: Icons.store_mall_directory,
    backgroundColor: Colors.lightGreen,
  ),
  "GTMS_SIGNED": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_delivered,
    icon: Icons.mark_email_read,
    backgroundColor: Colors.green,
  ),
  "EXCEPTION": ActionCodeInfo(
    status: (ctx) => AppLocalizations.of(ctx)!.status_exception,
    icon: Icons.error,
    backgroundColor: Colors.red,
  ),
};
