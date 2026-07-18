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
  final DateTime? lastSMSSync; // שדה חדש למעקב אחרי עדכוני SMS

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
    this.lastSMSSync,
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
        'lastSMSSync': lastSMSSync?.toIso8601String(),
      };

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        packageId: json['packageId'] ?? '',
        // מהשרת זה מגיע כ-'id', מקומית כ-'firestoreId'
        firestoreId: json['id'] ?? json['firestoreId'] ?? '',
        address: json['address'] ?? '',
        description: json['description'] ?? '',
        postOfficeCode: json['postOfficeCode'] ?? '',
        pickupPointName: json['pickupPointName'] ?? '',
        coordinates: _parseCoordinates(json['coordinates']),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
        // מהשרת זה מגיע כ-'arrivalMsg', מקומית כ-'arrivalMessage'
        arrivalMessage: json['arrivalMsg'] ?? json['arrivalMessage'] ?? '',
        eStatus: json['eStatus'],
        statusDesc: json['statusDesc'],
        statusDetailedDesc: json['statusDetailedDesc'],
        time: _parseTime(json['time']),
        actionCode: json['actionCode'],
        contact: json['contact'],
        contactDetails: json['contactDetails'],
        originCountry: json['originCountry'],
        destCountry: json['destCountry'],
        lastSMSSync: json['lastSMSSync'] != null
            ? DateTime.tryParse(json['lastSMSSync'])
            : null,
      );

  // --- פונקציות עזר פרטיות לטיפול במידע קשוח ---

  static List<double> _parseCoordinates(dynamic coords) {
    if (coords == null) return [];
    if (coords is List) {
      return coords.map((c) => (c as num).toDouble()).toList();
    }
    if (coords is Map) {
      return [
        (coords['lat'] ?? 0 as num).toDouble(),
        (coords['lng'] ?? 0 as num).toDouble()
      ];
    }
    return [];
  }

  static String? _parseTime(dynamic timeVal) {
    if (timeVal == null || timeVal == 0) return null;
    if (timeVal is int) {
      return DateTime.fromMillisecondsSinceEpoch(timeVal).toIso8601String();
    }
    return timeVal.toString();
  }
}
