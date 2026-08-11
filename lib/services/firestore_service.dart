import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/services/auth_service.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'dart:math';

String _generateTemporaryPassword() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(12, (index) => chars[random.nextInt(chars.length)]).join();
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCrewMember(CrewMember member) async {
    await _db.collection('crewMembers').doc(member.uid).set(member.toMap());
  }

  Future<void> addCrewMember(
    AuthService auth,
    String name,
    String email,
    CrewRole role,
  ) async {
    // step 1: create the Auth account, get back the uid
    final String uid = await auth.createCrewMemberAccount(email, _generateTemporaryPassword());

    // step 2: build a CrewMember object 
    final CrewMember newCrewMember = CrewMember(uid: uid, name: name, email: email, role: role, accountActivated: false);

    // step 3: save it using saveCrewMember
    await saveCrewMember(newCrewMember);
  }

  Future<CrewMember?> getCrewMember(String uid) async {
    final doc = await _db.collection('crewMembers').doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return CrewMember.fromMap(doc.data()!);
  }
}
