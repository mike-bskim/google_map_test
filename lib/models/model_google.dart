// To parse this JSON data, do
//
//     final modelGoogle = modelGoogleFromJson(jsonString);

// import 'dart:convert';

// ModelGoogle modelGoogleFromJson(String str) => ModelGoogle.fromJson(json.decode(str));
// String modelGoogleToJson(ModelGoogle data) => json.encode(data.toJson());

class ModelGoogle {

  String businessStatus;
  Geometry geometry;
  String icon;
  String iconBackgroundColor;
  String iconMaskBaseUri;
  String name;
  String placeId;
  PlusCode plusCode;
  double rating;// int => double
  String reference;
  String scope;
  List<String> types;
  int userRatingsTotal;
  String vicinity;

  ModelGoogle({
    required this.businessStatus,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.plusCode,
    required this.rating,
    required this.reference,
    required this.scope,
    required this.types,
    required this.userRatingsTotal,
    required this.vicinity,
  });

  factory ModelGoogle.fromJson(Map<String, dynamic> json) => ModelGoogle(
    businessStatus: json["business_status"],
    geometry: Geometry.fromJson(json["geometry"]),
    icon: json["icon"],
    iconBackgroundColor: json["icon_background_color"],
    iconMaskBaseUri: json["icon_mask_base_uri"],
    name: json["name"],
    placeId: json["place_id"],
    plusCode: PlusCode.fromJson(json["plus_code"]),
    rating: json["rating"].toDouble(),
    reference: json["reference"],
    scope: json["scope"],
    types: List<String>.from(json["types"].map((x) => x)),
    userRatingsTotal: json["user_ratings_total"],
    vicinity: json["vicinity"],
  );

  Map<String, dynamic> toJson() => {
    "business_status": businessStatus,
    "geometry": geometry.toJson(),
    "icon": icon,
    "icon_background_color": iconBackgroundColor,
    "icon_mask_base_uri": iconMaskBaseUri,
    "name": name,
    "place_id": placeId,
    "plus_code": plusCode.toJson(),
    "rating": rating,
    "reference": reference,
    "scope": scope,
    "types": List<dynamic>.from(types.map((x) => x)),
    "user_ratings_total": userRatingsTotal,
    "vicinity": vicinity,
  };
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  Location location;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "viewport": viewport.toJson(),
  };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  Location northeast;
  Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  String compoundCode;
  String globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}
