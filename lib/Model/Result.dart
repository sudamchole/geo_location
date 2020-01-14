import './Geometry.dart';

class Result{
  List<Geomerty> geomertyList;
  Result({this.geomertyList});

  factory Result.fromJson(Map json) {
    return Result(
      geomertyList:new List<Geomerty>.from(json['result']['geometry'][0].map((model) => Geomerty.fromJson(model)).toList()),
    );
  }
}