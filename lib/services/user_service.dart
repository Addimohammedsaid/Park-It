import 'package:firebase_database/firebase_database.dart';
import 'package:parkIt/models/user.model.dart';

class UserService {
  // reference to Users
  final databaseRealtimeUsers =
      FirebaseDatabase.instance.reference().child("users");

  // get user
  Stream<User> getUser(String uid) {
    return this.databaseRealtimeUsers.child(uid).onValue.map((event) {
      return User.fromMap(event.snapshot.value, event.snapshot.key);
    });
  }

  Future<User> updateUser(User user) {
    return this.databaseRealtimeUsers.child(user.uid).update(user.toMap());
  }
}
