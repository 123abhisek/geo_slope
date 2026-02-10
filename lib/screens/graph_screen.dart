
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';
import '../widgets/line_input_widget.dart';
import '../widgets/graph_canvas.dart';
import '../widgets/result_panel.dart';
import '../widgets/observation_table.dart';
import '../widgets/table_values_widget.dart';
import '../widgets/slider_controls.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Text('Graph Calculator'),
            actions: [
              IconButton(
                icon: Icon(provider.showGrid ? Icons.grid_on : Icons.grid_off),
                onPressed: () => provider.toggleGrid(),
                tooltip: 'Grid',
              ),
              IconButton(
                icon: Icon(provider.showSpecialPoints ? Icons.visibility : Icons.visibility_off),
                onPressed: () => provider.toggleSpecialPoints(),
                tooltip: 'Points',
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  if (provider.lines.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear All?'),
                        content: const Text('This will remove all equations.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              provider.clearAllLines();
                              Navigator.pop(context);
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                tooltip: 'Clear All',
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Share feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                tooltip: 'Share',
              ),
            ],
          ),
          body: Column(
            children: [
              // Line Input Section (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const LineInputWidget(),
                      
                      // Tab Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              _buildTab('Graph', 0, Icons.show_chart),
                              _buildTab('Analysis', 1, Icons.analytics),
                              _buildTab('Table', 2, Icons.table_chart),
                              _buildTab('Values', 3, Icons.list),
                              _buildTab('Transform', 4, Icons.tune),
                            ],
                          ),
                        ),
                      ),
                      
                      // Content Area with Fixed Height
                      SizedBox(
                        height: 500, // Fixed height for content
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: const [
                            GraphCanvas(),
                            ResultPanel(),
                            ObservationTable(),
                            TableValuesWidget(),
                            SliderControls(),
                          ],
                        ),
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

  Widget _buildTab(String title, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
                ? colorScheme.primaryContainer 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected 
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
