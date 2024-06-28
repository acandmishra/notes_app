// This function is used in notes_service.dart file to extract only those notes for which userId and note.userId are same

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
