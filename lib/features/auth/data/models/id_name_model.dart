final class IdNameModel {
  const IdNameModel(this.name, [this.id]);

  final int? id;
  final String name;

  factory IdNameModel.fromMap(Map<String, dynamic> map) =>
      IdNameModel(map['name'], map['id']);

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) {
    return other is IdNameModel && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
