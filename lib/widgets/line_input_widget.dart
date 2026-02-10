
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';
import 'math_keyboard.dart';

class LineInputWidget extends StatefulWidget {
  const LineInputWidget({super.key});

  @override
  State<LineInputWidget> createState() => _LineInputWidgetState();
}

class _LineInputWidgetState extends State<LineInputWidget> {
  final _equationController = TextEditingController();
  bool _showKeyboard = false;

  @override
  void dispose() {
    _equationController.dispose();
    super.dispose();
  }

  void _addLine() {
    final equation = _equationController.text.trim();
    if (equation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter an equation'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    try {
      context.read<LineProvider>().addEquation(equation);
      _equationController.clear();
      setState(() => _showKeyboard = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Equation added successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF388E3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main Input Card
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.functions,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter Equation',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Linear: y=2x+3  •  Trig: y=sin(x)  •  Fraction: y=1/2*x',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Equation Input
                TextField(
                  controller: _equationController,
                  readOnly: true,
                  onTap: () => setState(() => _showKeyboard = !_showKeyboard),
                  decoration: InputDecoration(
                    hintText: 'y = 2x + 3',
                    prefixIcon: const Icon(Icons.edit_outlined),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(_showKeyboard ? Icons.keyboard_hide : Icons.keyboard),
                          onPressed: () => setState(() => _showKeyboard = !_showKeyboard),
                          tooltip: 'Toggle Keyboard',
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: _addLine,
                          color: Theme.of(context).colorScheme.primary,
                          tooltip: 'Add',
                        ),
                      ],
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Quick Examples
                Text(
                  'Quick Examples',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPresetChip('y=2x+1', Icons.show_chart),
                      _buildPresetChip('y=-1/2*x+3', Icons.trending_down),
                      _buildPresetChip('y=sin(x)', Icons.waves),
                      _buildPresetChip('y=cos(x)', Icons.graphic_eq),
                      _buildPresetChip('y=x^2', Icons.architecture),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Lines List
                _buildLinesList(),
                
                const SizedBox(height: 16),
                
                // Preset Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPresetButton(
                        context,
                        'Parallel',
                        Icons.drag_handle,
                        () => context.read<LineProvider>().addPresetParallelLines(),
                      ),
                      const SizedBox(width: 8),
                      _buildPresetButton(
                        context,
                        'Perpendicular',
                        Icons.add,
                        () => context.read<LineProvider>().addPresetPerpendicularLines(),
                      ),
                      const SizedBox(width: 8),
                      _buildPresetButton(
                        context,
                        'Intersecting',
                        Icons.close,
                        () => context.read<LineProvider>().addPresetIntersectingLines(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Mathematical Keyboard
        if (_showKeyboard)
          MathKeyboard(
            controller: _equationController,
            onSubmit: _addLine,
          ),
      ],
    );
  }

  Widget _buildPresetChip(String equation, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(equation),
        onPressed: () {
          _equationController.text = equation;
        },
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildLinesList() {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        if (provider.lines.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No equations yet. Add your first equation above!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(provider.lines.length, (index) {
            final line = provider.lines[index];
            return Chip(
              avatar: CircleAvatar(
                backgroundColor: line.color,
                radius: 12,
                child: Text(
                  line.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              label: Text(line.equation),
              onDeleted: () => provider.removeLine(index),
              deleteIcon: const Icon(Icons.close, size: 18),
            );
          }),
        );
      },
    );
  }
}
