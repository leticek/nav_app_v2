import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_app/resources/models/place_suggestion.dart';
import 'dart:convert';
import '../resources/api_keys.dart';
import '../resources/constants.dart';
import 'package:latlong/latlong.dart';

class OpenRouteService with ChangeNotifier {
  http.Client _client;

  List<dynamic> _suggestions;

  OpenRouteService.instance() {
    _client = http.Client();
    _suggestions = [];
  }

  List<dynamic> get suggestions => _suggestions;

  void clearList() {
    _suggestions = [];
    notifyListeners();
  }

  void getSuggestion(String query) async {
    print('call sugg');
    if (query.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }
    final Uri _request =
        Uri.https('api.openrouteservice.org', '/geocode/autocomplete', {
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
      if (_apiResponse.statusCode == 200) {
        if (_parseSuggestions(_apiResponse.body)) {}
      }
    } catch (e) {}
  }

  bool _parseSuggestions(String response) {
    Map<dynamic, dynamic> _decodedResponse = json.decode(response);
    if (_decodedResponse['features'].length == 0) {
      print(_decodedResponse['features'].length);
      return false;
    }
    try {
      _suggestions = _decodedResponse['features']
          .map((feature) => PlaceSuggestion(
                feature['properties']['label'],
                LatLng(feature['geometry']['coordinates'][1].toDouble() ?? 0.0,
                    feature['geometry']['coordinates'][0].toDouble() ?? 0.0),
              ))
          .toList() as List<dynamic>;
      print(_suggestions.length);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
