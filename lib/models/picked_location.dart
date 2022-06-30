class PickedLocation {
  String id;
  String comment;
  String address;
  double lat;
  double lng;

  PickedLocation({
    required this.id,
    required this.comment,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  String toString() {
    return '''
      id: $id
      comment: $comment
      address: $address
      coordinate: $lat, $lng
    ''';
  }
}
