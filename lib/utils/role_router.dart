import 'package:flutter/material.dart';
import 'package:maintenance_app/models/crew_member.dart';
import 'package:maintenance_app/screens/dashboard_screen.dart';
import 'package:maintenance_app/screens/park_selection_screen.dart';

Widget homeScreenForRole(CrewMember crewMember) {
  return crewMember.role == CrewRole.administrator ||
          crewMember.role == CrewRole.inspector
      ? ParkSelectionScreen(crewMember: crewMember)
      : DashboardScreen(crewMember: crewMember);
}
