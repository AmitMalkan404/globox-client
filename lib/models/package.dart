class Package {
  final String id;
  final String address;
  final String description;
  final String status;
  final List<double> coordinates;

  Package(
      {required this.id,
      required this.address,
      required this.description,
      required this.status,
      required this.coordinates});
}
