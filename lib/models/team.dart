class Team {
  final String name;
  final String leader;
  final String college;
  final String problemTitle;
  final List<String> realityChecks;
  final List<FailureItem> failures;
  final List<String> blueprint;
  final List<EvaluationRound> history;

  Team({
    required this.name,
    this.leader = 'N/A',
    this.college = 'N/A',
    this.problemTitle = 'N/A',
    this.realityChecks = const [],
    this.failures = const [],
    this.blueprint = const [],
    required this.history,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      name: json['name'] ?? 'N/A',
      leader: json['leader'] ?? 'N/A',
      college: json['college'] ?? 'N/A',
      problemTitle: json['problemTitle'] ?? 'N/A',
      realityChecks: List<String>.from(json['reality_checks'] ?? []),
      failures: (json['failures'] as List? ?? [])
          .map((f) => FailureItem(
                description: f is String ? f : (f['desc'] ?? ''),
                status: f is String ? 'pending' : (f['status'] ?? 'pending'),
              ))
          .toList(),
      blueprint: List<String>.from(json['blueprint'] ?? []),
      history: [], // Initialize as empty list
    );
  }
}

class FailureItem {
  final String description;
  String status;

  FailureItem({required this.description, this.status = 'pending'});
}

class EvaluationRound {
  final int roundNumber;
  final String mentorName;
  final String remarks;
  final DateTime evaluationTime;

  EvaluationRound({
    required this.roundNumber,
    required this.mentorName,
    required this.remarks,
    required this.evaluationTime,
  });
}
