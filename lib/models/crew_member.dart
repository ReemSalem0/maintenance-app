enum CrewRole { administrator, manager, technician, inspector }

class CrewMember {
  final String uid; //unique ID assigned by Firebase Auth when the account is created
  final String name; // crew member's (account holder) full name
  final String email; // crew member's email address
  final CrewRole role; // crewmember's assigned role within the company
  final bool accountActivated; //custom flag to indecate that the account has fully compeleted the setup

  CrewMember({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.accountActivated,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.name,
      'accountActivated': accountActivated,
    };
  }

  factory CrewMember.fromMap(Map<String, dynamic> map) {
    return CrewMember(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      role: CrewRole.values.byName(map['role']),
      accountActivated: map['accountActivated'],
    );
  }
}
