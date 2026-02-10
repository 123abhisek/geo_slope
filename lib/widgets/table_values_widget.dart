import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';

class TableValuesWidget extends StatefulWidget {
  const TableValuesWidget({super.key});

  @override
  State<TableValuesWidget> createState() => _TableValuesWidgetState();
}

class _TableValuesWidgetState extends State<TableValuesWidget> {
  int selectedLineIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        if (provider.lines.isEmpty) {
          return const Center(
            child: Text('Add lines to see table of values'),
          );
        }

        final tableData = provider.getTableValues(selectedLineIndex);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Line selector
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Line',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: List.generate(provider.lines.length, (index) {
                          final line = provider.lines[index];
                          final isSelected = index == selectedLineIndex;
                          return ChoiceChip(
                            label: Text('Line ${line.name}'),
                            selected: isSelected,
                            avatar: CircleAvatar(
                              backgroundColor: line.color,
                              radius: 12,
                            ),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => selectedLineIndex = index);
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Table
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        provider.lines[selectedLineIndex].equation,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primaryContainer,
                        ),
                        columns: const [
                          DataColumn(label: Text('x', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('y', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: tableData.map((point) {
                          return DataRow(
                            cells: [
                              DataCell(Text(point['x']!.toStringAsFixed(1))),
                              DataCell(Text(point['y']!.toStringAsFixed(2))),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
