import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:navigation_app/resources/models/named_point.dart';
import 'package:navigation_app/resources/providers.dart';

import '../resources/api_keys.dart';
import '../resources/constants.dart';

class OpenRouteService with ChangeNotifier {
  http.Client _client;
  List<dynamic> _suggestions;
  bool isLoading = false;
  Reader read;

  OpenRouteService.instance(this.read) {
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
    final Uri _request = Uri.https('api.openrouteservice.org',
        '/v2/directions/${read(authServiceProvider).userModel.routeProfile}/geojson');
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

    try {
      setIsLoading();
      final _apiResponse = await _client.post(_request,
          headers: _header, body: json.encode(_body));
      debugPrint(_apiResponse.statusCode.toString());
      if (_apiResponse.statusCode == 200) {
        return _apiResponse.body;
      }
      final _parsedResponse = json.decode(_apiResponse.body);
      if (_parsedResponse['error']['code'] as int == 2010) {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<void> getSuggestion(String query) async {
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
      debugPrint('suggestion ors excep');
    }
  }

  void _parseSuggestions(String response) {
    final _decodedResponse = json.decode(response);
    if (_decodedResponse['features'].length == 0) {
      return;
    }
    try {
      _suggestions = _decodedResponse['features']
          .map((feature) => NamedPoint(
                feature['properties']['label'] as String,
                LatLng(
                    feature['geometry']['coordinates'][1].toDouble()
                            as double ??
                        0.0,
                    feature['geometry']['coordinates'][0].toDouble()
                            as double ??
                        0.0),
              ))
          .toList() as List<dynamic>;
      notifyListeners();
      return;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
