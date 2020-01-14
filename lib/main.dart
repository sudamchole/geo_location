import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cirrus_map_view/map_view.dart';
import 'package:flutter/material.dart';
import 'package:geo_location/Model/Geometry.dart';
import 'package:latlong/latlong.dart';
var myKey = 'AIzaSyDuLQta4bmLunan6nyUIcQcQf1Og-rfnpg';

void main() {
  MapView.setApiKey(myKey);
  runApp(new MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var allDataList = new List<dynamic>();
  List<Geomerty> geomertyList = new List();
  MapView mapView = new MapView();

 /* change latLng values to check diffrent geolocation are within area or not*/
  LatLng tap=LatLng(50.840473, -0.146755);
  @override
  void initState() {
    super.initState();
    Timer.run(() {loadJson();});

  }

  // ignore: missing_return
  Future<String> loadJson() async {
    //add new json in to -assets and .yml file and change name below to check in the new json
    String configJson = await DefaultAssetBundle.of(context).loadString("assets/hub3.json");
    var list =  json.decode(configJson);
    allDataList.addAll(list['results']['geometry'][0]);
    for(var i=0;i<allDataList.length;i++){
      geomertyList.add(new Geomerty.fromJson(allDataList[i]));
    }
    isLocationWithinArea(tap,geomertyList);

    //uncomment below to print output on console
    print(isLocationWithinArea(LatLng(50.8404969, -0.1504184),geomertyList));
    accuracy();


  }
  bool isLocationWithinArea(LatLng tap, Geomerty) {
    int intersectCount = 0;
    for (int j = 0; j < geomertyList.length - 1; j++) {
      if (rayCastIntersect(tap, geomertyList[j], geomertyList[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, Geomerty vertA, Geomerty vertB) {

    double aY = vertA.lat;
    double bY = vertB.lat;
    double aX = vertA.lng;
    double bX = vertB.lng;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY)
        || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }
  void accuracy(){
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) *
              (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
    double totalDistance = 0;
    for(var i = 0; i < geomertyList.length-1; i++){
      totalDistance += calculateDistance(geomertyList[i].lat, geomertyList[i].lng, geomertyList[i+1].lat, geomertyList[i+1].lng);
    }
    print(totalDistance);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Google Maps'),
      ),
      body: new Center(
        child: Container(
          child: RaisedButton(
            child: Text('Tap me'),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 7.0,
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
