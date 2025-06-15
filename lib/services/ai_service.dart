class AIService {
  // Mock responses for study plans and motivation tips
  final List<Map<String, String>> _mockResponses = [
    {
      'query': 'study plan',
      'response':
          'Here’s a study plan for 4 subjects in 10 days:\n'
          '- Day 1-2: Subject 1 (4 hours/day)\n'
          '- Day 3-4: Subject 2 (4 hours/day)\n'
          '- Day 5-6: Subject 3 (4 hours/day)\n'
          '- Day 7-8: Subject 4 (4 hours/day)\n'
          '- Day 9-10: Review all subjects (2 hours each)\n'
          'Take 10-minute breaks every hour!',
    },
    {
      'query': 'motivation',
      'response':
          'You’ve got this! Break your tasks into small chunks, and reward yourself after each study session. Keep your goals in sight!',
    },
    {
      'query': 'revise CN',
      'response':
          'To revise Computer Networks in 2 days:\n'
          '- Day 1: Focus on OSI model, TCP/IP, and networking protocols (4 hours).\n'
          '- Day 2: Study routing algorithms and network security (4 hours).\n'
          'Use diagrams to visualize concepts!',
    },
  ];

  String getResponse(String query) {
    final lowerQuery = query.toLowerCase();
    final response = _mockResponses.firstWhere(
      (r) => lowerQuery.contains(r['query']!),
      orElse:
          () => {
            'response':
                'I’m not sure how to help with that yet. Try asking for a study plan or motivation tips!',
          },
    );
    return response['response']!;
  }
}
