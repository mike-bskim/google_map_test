import 'dart:convert';

/// business_status : "OPERATIONAL"
/// geometry : {"location":{"lat":37.5400379,"lng":126.9683323},"viewport":{"northeast":{"lat":37.54138772989272,"lng":126.9696821298927},"southwest":{"lat":37.53868807010728,"lng":126.9669824701073}}}
/// icon : "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png"
/// icon_background_color : "#FF9E67"
/// icon_mask_base_uri : "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet"
/// name : "날개베이커리"
/// place_id : "ChIJQRVGCBOifDURf5AsME26XaA"
/// plus_code : {"compound_code":"GXR9+28 서울특별시 대한민국","global_code":"8Q98GXR9+28"}
/// rating : 0
/// reference : "ChIJQRVGCBOifDURf5AsME26XaA"
/// scope : "GOOGLE"
/// types : ["bakery","food","store","point_of_interest","establishment"]
/// user_ratings_total : 0
/// vicinity : "용산구 원효로1가 46-5"

ModelGoogleJsonDart modelGoogleJsonDartFromJson(String str) =>
    ModelGoogleJsonDart.fromJson(json.decode(str));

String modelGoogleJsonDartToJson(ModelGoogleJsonDart data) =>
    json.encode(data.toJson());

class ModelGoogleJsonDart {
  String? businessStatus;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  String? placeId;
  PlusCode? plusCode;
  int? rating;
  String? reference;
  String? scope;
  List<String>? types;
  int? userRatingsTotal;
  String? vicinity;

  ModelGoogleJsonDart({
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

  ModelGoogleJsonDart.fromJson(dynamic json) {
    businessStatus = json['business_status'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plusCode']) : null;
    rating = json['rating'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'] != null ? json['types'].cast<String>() : [];
    userRatingsTotal = json['user_ratings_total'];
    vicinity = json['vicinity'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['business_status'] = businessStatus;
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    map['icon'] = icon;
    map['icon_background_color'] = iconBackgroundColor;
    map['icon_mask_base_uri'] = iconMaskBaseUri;
    map['name'] = name;
    map['place_id'] = placeId;
    if (plusCode != null) {
      map['plus_code'] = plusCode?.toJson();
    }
    map['rating'] = rating;
    map['reference'] = reference;
    map['scope'] = scope;
    map['types'] = types;
    map['user_ratings_total'] = userRatingsTotal;
    map['vicinity'] = vicinity;
    return map;
  }
}

/// compound_code : "GXR9+28 서울특별시 대한민국"
/// global_code : "8Q98GXR9+28"

PlusCode plusCodeFromJson(String str) => PlusCode.fromJson(json.decode(str));

String plusCodeToJson(PlusCode data) => json.encode(data.toJson());

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  PlusCode.fromJson(dynamic json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  String? compoundCode;
  String? globalCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compound_code'] = compoundCode;
    map['global_code'] = globalCode;
    return map;
  }
}

/// location : {"lat":37.5400379,"lng":126.9683323}
/// viewport : {"northeast":{"lat":37.54138772989272,"lng":126.9696821298927},"southwest":{"lat":37.53868807010728,"lng":126.9669824701073}}

Geometry geometryFromJson(String str) => Geometry.fromJson(json.decode(str));

String geometryToJson(Geometry data) => json.encode(data.toJson());

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Geometry.fromJson(dynamic json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Location? location;
  Viewport? viewport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    if (viewport != null) {
      map['viewport'] = viewport?.toJson();
    }
    return map;
  }
}

/// northeast : {"lat":37.54138772989272,"lng":126.9696821298927}
/// southwest : {"lat":37.53868807010728,"lng":126.9669824701073}

Viewport viewportFromJson(String str) => Viewport.fromJson(json.decode(str));

String viewportToJson(Viewport data) => json.encode(data.toJson());

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Viewport.fromJson(dynamic json) {
    northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    southwest = json['southwest'] != null
        ? Southwest.fromJson(json['southwest'])
        : null;
  }

  Northeast? northeast;
  Southwest? southwest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (northeast != null) {
      map['northeast'] = northeast?.toJson();
    }
    if (southwest != null) {
      map['southwest'] = southwest?.toJson();
    }
    return map;
  }
}

/// lat : 37.53868807010728
/// lng : 126.9669824701073

Southwest southwestFromJson(String str) => Southwest.fromJson(json.decode(str));

String southwestToJson(Southwest data) => json.encode(data.toJson());

class Southwest {
  Southwest({
    this.lat,
    this.lng,
  });

  Southwest.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  double? lat;
  double? lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}

/// lat : 37.54138772989272
/// lng : 126.9696821298927

Northeast northeastFromJson(String str) => Northeast.fromJson(json.decode(str));

String northeastToJson(Northeast data) => json.encode(data.toJson());

class Northeast {
  Northeast({
    this.lat,
    this.lng,
  });

  Northeast.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  double? lat;
  double? lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}

/// lat : 37.5400379
/// lng : 126.9683323

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  Location({
    this.lat,
    this.lng,
  });

  Location.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  double? lat;
  double? lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}
