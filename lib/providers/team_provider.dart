import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredTeamsProvider = Provider<List<Team>>((ref) {
  final allTeams = ref.watch(teamProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  if (query.isEmpty) return allTeams;
  return allTeams.where((team) {
    return team.name.toLowerCase().contains(query) ||
           team.problemTitle.toLowerCase().contains(query) ||
           team.college.toLowerCase().contains(query);
  }).toList();
});

final teamProvider = StateNotifierProvider<TeamNotifier, List<Team>>((ref) {
  return TeamNotifier();
});

class TeamNotifier extends StateNotifier<List<Team>> {
  TeamNotifier() : super([]) {
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      final String response = await rootBundle.loadString('assets/data/final_db.json');
      final List<dynamic> data = json.decode(response);
      state = data.map((t) => Team.fromJson(t)).toList();
    } catch (e) {
      print("CRITICAL_ERR: DATA_LOAD_FAILED: $e");
    }
  }

  void addHistoryEntry(String teamName, int roundNumber, String handle, String remarks) {
    final teamIndex = state.indexWhere((t) => t.name == teamName);
    if (teamIndex != -1) {
      final team = state[teamIndex];
      team.history.insert(0, EvaluationRound(
        roundNumber: roundNumber,
        mentorName: handle,
        remarks: remarks,
        evaluationTime: DateTime.now(),
      ));
      state = [...state];
    }
  }

  void toggleFailureStatus(String teamName, int failureIndex) {
    final teamIndex = state.indexWhere((t) => t.name == teamName);
    if (teamIndex != -1) {
      final team = state[teamIndex];
      final failure = team.failures[failureIndex];
      failure.status = (failure.status == 'pending') ? 'resolved' : 'pending';
      state = [...state];
    }
  }
}
