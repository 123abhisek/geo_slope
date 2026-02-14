

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';
import '../widgets/line_input_widget.dart';
import '../widgets/graph_canvas.dart';
import '../widgets/result_panel.dart';
import '../widgets/observation_table.dart';
import '../widgets/table_values_widget.dart';
import '../widgets/slider_controls.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
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
              bottom: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(icon: Icon(Icons.show_chart), text: 'Graph'),
                  Tab(icon: Icon(Icons.analytics), text: 'Analysis'),
                  Tab(icon: Icon(Icons.table_chart), text: 'Table'),
                  Tab(icon: Icon(Icons.list), text: 'Values'),
                  Tab(icon: Icon(Icons.tune), text: 'Transform'),
                ],
              ),
            ),
            body: Column(
              children: [
                // Scrollable Content Area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Line Input Section (without keyboard)
                        const LineInputWidget(),
                        
                        // Tab Content
                        SizedBox(
                          height: 500,
                          child: TabBarView(
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
          ),
        );
      },
    );
  }
}
