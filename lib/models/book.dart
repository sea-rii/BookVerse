import 'dart:typed_data';

enum ReadingStatus { toRead, reading, finished }

extension ReadingStatusLabel on ReadingStatus {
  String get label {
    switch (this) {
      case ReadingStatus.toRead:
        return 'To Read';
      case ReadingStatus.reading:
        return 'Reading';
      case ReadingStatus.finished:
        return 'Finished';
    }
  }
}

class Book {
  final String id;
  String title;
  String author;
  String coverUrl;
  Uint8List? coverBytes;

  String description;
  ReadingStatus status;

  final List<String> notes;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.status,
    this.coverBytes,
    List<String>? notes,
  }) : notes = notes ?? [];
}
