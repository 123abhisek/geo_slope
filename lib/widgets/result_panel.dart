import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';
import '../utils/math_utils.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        if (provider.lines.length < 2) {
          return Center(
            child: Text(
              'Add at least 2 lines to see analysis',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final relations = provider.getRelations();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Slopes Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slopes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...provider.lines.map((line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: line.color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                line.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${line.equation}  →  m = ${line.slope.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Relations Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Line Relations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...relations.map((relation) => _buildRelationCard(context, relation)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Conclusion Card
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Conclusion',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _generateConclusion(provider, relations),
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRelationCard(BuildContext context, relation) {
    IconData icon;
    Color color;
    String label;

    if (relation.isParallel) {
      icon = Icons.drag_handle;
      color = Colors.blue;
      label = 'PARALLEL';
    } else if (relation.isPerpendicular) {
      icon = Icons.add;
      color = Colors.green;
      label = 'PERPENDICULAR';
    } else {
      icon = Icons.close;
      color = Colors.grey;
      label = 'NEITHER';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                'Line ${relation.line1} & Line ${relation.line2}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Chip(
                label: Text(label),
                backgroundColor: color,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            relation.explanation,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  String _generateConclusion(LineProvider provider, List relations) {
    final parallelCount = relations.where((r) => r.isParallel).length;
    final perpendicularCount = relations.where((r) => r.isPerpendicular).length;

    String conclusion = 'From the analysis of ${provider.lines.length} lines:\n\n';

    if (parallelCount > 0) {
      conclusion += '• Found $parallelCount parallel line pair(s). Lines are parallel when they have equal slopes (m₁ = m₂).\n\n';
    }

    if (perpendicularCount > 0) {
      conclusion += '• Found $perpendicularCount perpendicular line pair(s). Lines are perpendicular when the product of their slopes equals -1 (m₁ × m₂ = -1).\n\n';
    }

    if (parallelCount == 0 && perpendicularCount == 0) {
      conclusion += '• No parallel or perpendicular line pairs found in this graph.\n\n';
    }

    conclusion += 'This verifies the mathematical properties of straight lines in coordinate geometry.';

    return conclusion;
  }
}
