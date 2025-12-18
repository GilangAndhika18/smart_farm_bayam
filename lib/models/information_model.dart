class InformationModel {
  final String id;
  final String title;
  final String content;

  final bool pinned;
  final int order;
  final int createdAt;

  InformationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.pinned,
    required this.order,
    required this.createdAt,
  });

  factory InformationModel.fromMap(Map<dynamic, dynamic> map, String id) {
    return InformationModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',

      pinned: map['pinned'] ?? false,
      order: map['order'] ?? 999,
      createdAt: map['created_at'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'pinned': pinned,
      'order': order,
      'created_at': createdAt,
    };
  }

  InformationModel copyWith({
    String? title,
    String? content,
    bool? pinned,
    int? order,
    int? createdAt,
  }) {
    return InformationModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      pinned: pinned ?? this.pinned,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
