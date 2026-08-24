import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'dart:math';

//random password generator
String _generateTemporaryPassword() {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(
    12,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //saves crew member to the firestore database
  Future<void> saveCrewMember(CrewMember member) async {
    await _db.collection('crewMembers').doc(member.uid).set(member.toMap());
  }

  //updates the accountActivated field in the database
  Future<void> markAccountActivated(String uid) async {
    await _db.collection('crewMembers').doc(uid).update({
      'accountActivated': true,
    });
  }

  //creates a full crew member: Auth account, Firestore record and password setup email
  Future<void> addCrewMember(
    AuthService auth,
    String name,
    String email,
    CrewRole role,
  ) async {
    // step 1: create the Auth account, get back the uid
    final String uid = await auth.createCrewMemberAccount(
      email,
      _generateTemporaryPassword(),
    );

    // step 2: build a CrewMember object
    final CrewMember newCrewMember = CrewMember(
      uid: uid,
      name: name,
      email: email,
      role: role,
      accountActivated: false,
    );

    // step 3: save it using saveCrewMember
    await saveCrewMember(newCrewMember);

    //step 4: send a password reset email to the new crew member
    await auth.sendPasswordSetupEmail(email);
  }

  //gets the crew member from the firestore database
  Future<CrewMember?> getCrewMember(String uid) async {
    final doc = await _db.collection('crewMembers').doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return CrewMember.fromMap(doc.data()!);
  }

  Stream<List<CrewMember>> getAllCrewMembersStream() {
    return _db.collection('crewMembers').snapshots().map((snapshot){
      return snapshot.docs.map((doc) => CrewMember.fromMap(doc.data())).toList();
    });
  }

  Stream<CrewMember> getCrewMemberStream(String uid) {
    return _db.collection('crewMembers').doc(uid).snapshots().map((doc) {
      return CrewMember.fromMap(doc.data()!);
    });
  }

  Future<void> updateCrewMemberRole(String uid, CrewRole newRole) async {
    await _db.collection('crewMembers').doc(uid).update({
      'role': newRole.name,
    });
  }
}
