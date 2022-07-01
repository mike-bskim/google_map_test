class Place {
  final String description;
  final String placeId;
  final String name;

  Place({
    required this.description,
    required this.placeId,
    required this.name,
  });

  // Place.fromJson(Map<String, dynamic> json)
  //     : description = json['description'],
  //       placeId = json['place_id'];
  //
  factory Place.fromJson(Map<String, dynamic> json) => Place(
        description: json['description'],
        placeId: json['place_id'],
        name: json['structured_formatting']['main_text'],
      );

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'placeId': placeId,
    };
  }
}

class PlaceDetail {
  final String placeId;
  final String formattedAddress;
  final String formattedPhoneNumber;
  final String name;
  final double rating;
  final String vicinity;
  final String website;
  final double lat;
  final double lng;

  PlaceDetail({
    required this.placeId,
    required this.formattedAddress,
    required this.formattedPhoneNumber,
    required this.name,
    required this.rating,
    required this.vicinity,
    this.website = '',
    required this.lat,
    required this.lng,
  });

  PlaceDetail.fromJson(Map<String, dynamic> json)
      : placeId = json['place_id'] ?? '',
        formattedAddress = json['formatted_address'] ?? '',
        formattedPhoneNumber = json['formatted_phone_number'] ?? '',
        name = json['name'] ?? '',
        rating = json['rating'].toDouble() ?? 0.0,
        vicinity = json['vicinity'] ?? '',
        website = json['website'] ?? '',
        lat = json['geometry']['location']['lat'] ?? 0.0,
        lng = json['geometry']['location']['lng'] ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'formateedAddress': formattedAddress,
      'formateedPhoneNumber': formattedPhoneNumber,
      'name': name,
      'rating': rating,
      'vicinity': vicinity,
      'website': website,
      'lat': lat,
      'lng': lng,
    };
  }
}
