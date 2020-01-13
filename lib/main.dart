import 'package:cirrus_map_view/figure_joint_type.dart';
import 'package:cirrus_map_view/map_view.dart';
import 'package:cirrus_map_view/polygon.dart';
import 'package:flutter/material.dart';
var myKey = 'AIzaSyDuLQta4bmLunan6nyUIcQcQf1Og-rfnpg';

void main() {
  MapView.setApiKey(myKey);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
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
    new Marker("1", "Great", 18.5204, -97.7431,
        color: Colors.green, draggable: true)
  ];

  List<Polygon> polygons = <Polygon>[
    new Polygon(
        "Nice one",
        <Location>[
          new Location(35.22, -101.83),
          new Location(32.77, -96.79),
          new Location(29.76, -95.36),
          new Location(29.42, -98.49),
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
        new CameraPosition(new Location(35.22, -101.83), 14.0),
        showUserLocation: false,
        title: 'Google Map'));

    mapView.onMapTapped.listen((tapped) {
      mapView.setMarkers(markers);
      mapView.setPolygons(polygons);
      mapView.zoomToFit(padding: 100);
    });
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