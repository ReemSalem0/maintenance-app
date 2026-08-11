import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:maintenance_app/screens/add_crew_member_screen.dart';
import 'package:maintenance_app/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maintenance App',
      home: const LoginScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _statusMessage = 'No data written yet.';

  Future<void> _writeTestDocument() async {
    setState(() {
      _statusMessage = 'Writing...';
    });

    try {
      await FirebaseFirestore.instance.collection('test_rides').add({
        'name': 'Test Roller Coaster',
        'status': 'Operational',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _statusMessage = 'Write succeeded! Check the stream below.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error writing: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _writeTestDocument,
              child: const Text('Write Test Ride to Firestore'),
            ),
            const SizedBox(height: 12),
            Text(_statusMessage),
            const Divider(height: 32),
            const Text(
              'Live data from Firestore:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('test_rides')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Text('No rides yet.');
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name'] ?? 'Unnamed'),
                        subtitle: Text(data['status'] ?? 'Unknown'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}