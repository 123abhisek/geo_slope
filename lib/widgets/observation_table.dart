import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';

class ObservationTable extends StatelessWidget {
  const ObservationTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        if (provider.lines.isEmpty) {
          return Center(
            child: Text(
              'Add lines to see observation table',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final relations = provider.getRelations();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observation Table',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primaryContainer,
                          ),
                          columns: const [
                            DataColumn(label: Text('Line', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Equation', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Slope (m)', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Parallel To', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Perpendicular To', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: provider.lines.map((line) {
                            final parallelTo = relations
                                .where((r) => 
                                    r.isParallel && 
                                    (r.line1 == line.name || r.line2 == line.name))
                                .map((r) => r.line1 == line.name ? r.line2 : r.line1)
                                .join(', ');

                            final perpendicularTo = relations
                                .where((r) => 
                                    r.isPerpendicular && 
                                    (r.line1 == line.name || r.line2 == line.name))
                                .map((r) => r.line1 == line.name ? r.line2 : r.line1)
                                .join(', ');

                            return DataRow(
                              cells: [
                                DataCell(
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: line.color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        line.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(line.equation)),
                                DataCell(Text(line.slope.toStringAsFixed(2))),
                                DataCell(Text(parallelTo.isEmpty ? '—' : parallelTo)),
                                DataCell(Text(perpendicularTo.isEmpty ? '—' : perpendicularTo)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.file_download),
                label: const Text('Export as PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
