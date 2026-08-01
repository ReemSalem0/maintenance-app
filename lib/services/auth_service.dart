import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> createCrewMemberAccount(String email, String password) async {
    //step 1: create a temporary secondery Firebase app
    FirebaseApp tempApp = await Firebase.initializeApp(
      name: 'tempApp',
      options: Firebase.app().options,
    );

    //step 2: get an Auth instance tied to that temporary app, not the main one
    FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

    //step 3: create the new user using the temporary auth instance
    final userCredential = await tempAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final String uniqueID = userCredential.user!.uid;

    //step 4: clean up: delete the temporary app now that we're done with it
    await tempApp.delete();

    return uniqueID;
  }
}
