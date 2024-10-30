import 'dart:convert';
import 'dart:io';
class ClubMapper {
  late Map<String, dynamic> _clubsMap;

  ClubMapper() {
    try {
      // Read the content of the JSON file
      String jsonString = File('${Directory.current.path}/').readAsStringSync();

      // Parse the JSON string
      _clubsMap = json.decode(jsonString);
    } catch (e) {
      print('Error reading or parsing the JSON file: $e');
      _clubsMap = {};
    }
  }

  String getPlaceId(String placeName) {
    return _clubsMap[placeName] ?? 'Place not found';
  }
}