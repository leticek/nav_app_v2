import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';

import '../resources/api_keys.dart';
import '../resources/constants.dart';

class OpenRouteService with ChangeNotifier {
  http.Client _client;
  List<dynamic> _suggestions;
  bool isLoading = false;

  OpenRouteService.instance() {
    _client = http.Client();
    _suggestions = [];
  }

  List<dynamic> get suggestions => _suggestions;

  void clearList() {
    _suggestions = [];
    notifyListeners();
  }

  void setIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<String> searchRoute(List points) async {
    final Uri _request = Uri.https(
        'api.openrouteservice.org', '/v2/directions/foot-hiking/geojson');
    final Map<String, String> _header = {
      "Authorization": ORS_API_KEY,
      "Accept":
          "application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8",
      "Content-Type": "application/json; charset=utf-8"
    };
    final Map<String, dynamic> _body = {
      'coordinates': points,
      'elevation': 'true',
      'preference': 'recommended'
    };
    print(_body);
    try {
      setIsLoading();
      final _apiResponse = await _client.post(_request,
          headers: _header, body: json.encode(_body));
      print(_apiResponse.statusCode);
      if (_apiResponse.statusCode == 200) {
        return _apiResponse.body;
      }
      dynamic _parsedResponse = json.decode(_apiResponse.body);
      if (_parsedResponse['error']['code'] as int == 2010) {
        return null;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void getSuggestion(String query) async {
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    final Uri _request =
        Uri.https('api.openrouteservice.org', '/geocode/search', {
      'api_key': ORS_API_KEY,
      'text': query,
      'boundary.rect.min_lon': MIN_LON,
      'boundary.rect.min_lat': MIN_LAT,
      'boundary.rect.max_lon': MAX_LON,
      'boundary.rect.max_lat': MAX_LAT,
      'sources': SOURCES,
      'size': '10'
    });

    try {
      final _apiResponse = await _client.get(_request);
      if (_apiResponse.statusCode == 200) _parseSuggestions(_apiResponse.body);
    } catch (e) {
      print('suggestion ors excep');
    }
  }

  void _parseSuggestions(String response) {
    Map<dynamic, dynamic> _decodedResponse = json.decode(response);
    if (_decodedResponse['features'].length == 0) {
      return;
    }
    try {
      _suggestions = _decodedResponse['features']
          .map((feature) => NamedPoint(
                feature['properties']['label'],
                LatLng(feature['geometry']['coordinates'][1].toDouble() ?? 0.0,
                    feature['geometry']['coordinates'][0].toDouble() ?? 0.0),
              ))
          .toList() as List<dynamic>;
      notifyListeners();
      return;
    } catch (e) {
      print(e);
      return;
    }
  }
}