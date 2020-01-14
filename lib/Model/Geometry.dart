class Geomerty{
final double lat;
final double lng;
Geomerty({this.lat,this.lng});

factory Geomerty.fromJson(Map json) {
  return Geomerty(
    lat: json['lat'],
    lng: json['lon'],
  );
}
}