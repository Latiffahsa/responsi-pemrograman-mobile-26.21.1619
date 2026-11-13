class Note {
  /// Membuat objek [Note].
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  factory Note.fromMeta(Map<String, dynamic> meta, String content) {
    return Note(
      id: meta['id'] as String,
      title: meta['title'] as String,
      content: content,
      createdAt: DateTime.parse(meta['date'] as String),
    );
  }

  Map<String, dynamic> toMeta() => {
    'id': id,
    'title': title,
    'date': createdAt.toIso8601String(),
  };
}
