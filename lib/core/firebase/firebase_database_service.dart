import 'package:firebase_database/firebase_database.dart';

import '../constants/key_enums.dart';
import 'firebase_keys.dart';

final class FirebaseDatabaseService {
  const FirebaseDatabaseService();

  static final _usersRef = FirebaseDatabase.instance.ref(
    FirebaseCollections.users,
  );

  void changeActiveStatusWhenConnectionChanged(int thisUserId) {
    final onlineRef = presenceRef(thisUserId);
    onlineRef.onDisconnect().set(UserPresence.offline.name);
  }

  Stream<DatabaseEvent> activeStatusStream(int id) => presenceRef(id).onValue;

  void updateActiveStatus(int id, UserPresence presence) =>
      presenceRef(id).set(presence.name);

  DatabaseReference presenceRef(int id) =>
      _usersRef.child('$id').child(FirebaseFields.presence);
}
