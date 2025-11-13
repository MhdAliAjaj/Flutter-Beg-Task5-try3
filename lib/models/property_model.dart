class PropertyModel {
  final String id;
  final String title;
  final String type;
  final String location;
  final double price;
  final String description;
  final String imageUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'location': location,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory PropertyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PropertyModel(
      id: documentId,
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      location: map['location'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
