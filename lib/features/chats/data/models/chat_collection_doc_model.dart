final class ChatCollectionDocModel {
  const ChatCollectionDocModel(this.collection, this.doc);

  final String collection;
  final String doc;

  @override
  bool operator ==(Object other) {
    return other is ChatCollectionDocModel &&
        collection == other.collection &&
        doc == other.doc;
  }

  @override
  int get hashCode => collection.hashCode + doc.hashCode;
}
