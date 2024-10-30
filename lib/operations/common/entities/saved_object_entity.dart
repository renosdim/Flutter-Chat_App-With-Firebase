class SavedObject<T>{
  final T object;
  final DateTime timestamp;
  const SavedObject({required this.timestamp,required this.object});
  bool isCurrent(Duration duration) {

    bool result = DateTime.now().difference(timestamp).abs()< duration;

    return result;
  }
  SavedObject<T> copyWith(T object){
    return SavedObject(timestamp: DateTime.now(), object: object);
  }
}