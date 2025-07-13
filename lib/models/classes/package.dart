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

  Map<String, dynamic> toJson() => {
        'packageId': packageId,
        'firestoreId': firestoreId,
        'address': address,
        'description': description,
        'postOfficeCode': postOfficeCode,
        'pickupPointName': pickupPointName,
        'coordinates': coordinates,
        'createdAt': createdAt?.toIso8601String(),
        'arrivalMessage': arrivalMessage,
        'eStatus': eStatus,
        'statusDesc': statusDesc,
        'statusDetailedDesc': statusDetailedDesc,
        'time': time,
        'actionCode': actionCode,
        'contact': contact,
        'contactDetails': contactDetails,
        'originCountry': originCountry,
        'destCountry': destCountry,
      };

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        packageId: json['packageId'],
        firestoreId: json['firestoreId'],
        address: json['address'],
        description: json['description'],
        postOfficeCode: json['postOfficeCode'],
        pickupPointName: json['pickupPointName'],
        coordinates: List<double>.from(json['coordinates']),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        arrivalMessage: json['arrivalMessage'],
        eStatus: json['eStatus'],
        statusDesc: json['statusDesc'],
        statusDetailedDesc: json['statusDetailedDesc'],
        time: json['time'],
        actionCode: json['actionCode'],
        contact: json['contact'],
        contactDetails: json['contactDetails'],
        originCountry: json['originCountry'],
        destCountry: json['destCountry'],
      );
}
