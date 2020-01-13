import 'dart:async';

import 'package:cirrus_map_view/figure_joint_type.dart';
import 'package:cirrus_map_view/map_view.dart';
import 'package:cirrus_map_view/polygon.dart';
import 'package:flutter/material.dart';
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

  MapView mapView = new MapView();

  List<Marker> markers = <Marker>[
    new Marker("1", "Great",50.8404969, -0.15041841,
        color: Colors.green, draggable: true)
  ];
  @override
  void initState() {
    super.initState();
    Timer.run(() {isPointInPolygon;});

  }

  List<Polygon> polygons = <Polygon>[
    new Polygon(
        "Nice one",
        <Location>[
          new Location(50.8404969, -0.1504184),
          new Location(50.8400879, -0.1499697),
          new Location(50.8397147,-0.149544),
          new Location(50.8395274,-0.149197),
          new Location(50.8391651,-0.1484959),
          new Location(50.8390762 ,-0.1483239),
        ],
        jointType: FigureJointType.round,
        strokeColor: Colors.blue,
        strokeWidth: 10.0,
        fillColor: Colors.blue.withOpacity(0.1))


  ];

  displayMap() {
    mapView.show(new MapOptions(
        mapViewType: MapViewType.normal,
        initialCameraPosition:
        new CameraPosition(new Location(50.8364603, -0.1510933), 14.0),
        showUserLocation: false,
        title: 'Google Map'));

    mapView.onMapTapped.listen((tapped) {
      mapView.setMarkers(markers);
      mapView.setPolygons(polygons);
      mapView.zoomToFit(padding: 100);
    });
  }

  List vertices=new List<LatLng>();

  bool isPointInPolygon(LatLng tap,vertices) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.size() - 1; j++) {
      if (rayCastIntersect(tap, vertices.get(j), vertices.get(j + 1))) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }
  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {

    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
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
            onPressed: displayMap,
          ),
        ),
      ),
    );
  }
}
