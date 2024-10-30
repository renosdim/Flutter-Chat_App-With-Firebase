dynamic findValue(Map map, String desiredKey) {
  int saved = 0;
  for (String key in map.keys.toList()) {
    dynamic value = map[key];
    if (value is Map) {
      // If the nested map contains the desired key, print the value
      if (value.containsKey(desiredKey)) {
        print('Found value: ${value[desiredKey]}');

        // Return the value directly
        return value[desiredKey];
      } else {
        // Recursively search in the nested map
        saved = findValue(value, desiredKey);

        // If a value is found in the recursive call, break out of the loop
        if (saved != 0) {
          break;
        }
      }
    }
  }


  return saved;
}

List<String> getUniqueList(List<String> list){

  Set<String> uniqueSet = Set<String>.from(list);

  // Convert the set back to a list
  List<String> resultList = uniqueSet.toList();
  return resultList;
}
int compare(dynamic a ,dynamic b){
  DateTime otherTimestamp = DateTime.fromMillisecondsSinceEpoch(b.timestamp);
  DateTime thisTimestamp = DateTime.fromMillisecondsSinceEpoch(a.timestamp);
  return thisTimestamp.compareTo(otherTimestamp);

}


Future<String> retryWithExponentialBackoff(int maxRetries, Future Function() operation) async {
  int retryAttempt = 0;
  const maxDelay = Duration(seconds: 16);

  while (retryAttempt < maxRetries) {
    try {
      await operation();
      return 'success';
    } catch (e) {
      print('Error: $e');
      if (retryAttempt==maxRetries){
        return e.runtimeType.toString();
      }
      retryAttempt++;
      // Exponential backoff with a maximum delay of 16 seconds
      await Future.delayed(Duration(seconds: 2 * retryAttempt), () {});
    }

  }
  return 'failure';

    print('Max retries reached. Operation failed.');
}

String calculateTimeDifference(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} s';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} m';
  } else if (difference.inHours < 1.5) {
    int hours = difference.inHours;
    return '${hours} ${hours == 1 ? 'h' : 'h'}';
  } else if(difference.inHours<23.5){
    int roundedHours = (difference.inHours / 1.5).ceil();
    return '${roundedHours} ${roundedHours == 1 ? 'h' : 'h'} ';
  }
  else{
    return '${difference.inDays} ${difference.inDays== 1 ? 'd' : 'd'}';
  }
}

