class Package {
  final String packageId;
  final String firestoreId;
  final String address;
  final String description;
  final String postOfficeCode;
  final String pickupPointName;
  final List<double> coordinates;
  final DateTime? createdAt;
  final String? arrivalMessage;
  final String? eStatus;
  final String? statusDesc;
  final String? statusDetailedDesc;
  final String? time;
  final String? actionCode;
  final String? contact;
  final String? contactDetails;
  final String? originCountry;
  final String? destCountry;

  Package({
    required this.packageId,
    required this.firestoreId,
    required this.address,
    required this.description,
    required this.postOfficeCode,
    required this.pickupPointName,
    required this.coordinates,
    this.arrivalMessage,
    this.eStatus,
    this.statusDesc,
    this.statusDetailedDesc,
    this.time,
    this.actionCode,
    this.contact,
    this.contactDetails,
    this.originCountry,
    this.destCountry,
    this.createdAt,
  });
}
