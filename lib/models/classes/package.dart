import 'package:globox/models/enums/shipment_status.dart';

class Package {
  final String packageId;
  final String address;
  final String description;
  final ShipmentStatus status;
  final List<double> coordinates;
  final DateTime? createdAt;

  Package(
      {required this.packageId,
      required this.address,
      required this.description,
      required this.status,
      required this.coordinates,
      this.createdAt});
}
