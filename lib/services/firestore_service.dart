import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_app/services/auth_service.dart';
import '../models/crew_member.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCrewMember(CrewMember member) async {
    await _db.collection('crewMembers').doc(member.uid).set(member.toMap());
  }

  Future<void> addCrewMember(
    AuthService auth,
    String name,
    String email,
    String password,
    CrewRole role,
  ) async {
    // step 1: create the Auth account, get back the uid
    final String uid = await auth.createCrewMemberAccount(email, password);

    // step 2: build a CrewMember object 
    final CrewMember newCrewMember = CrewMember(uid: uid, name: name, email: email, role: role, accountActivated: false);

    // step 3: save it using saveCrewMember
    await saveCrewMember(newCrewMember);
  }
}
