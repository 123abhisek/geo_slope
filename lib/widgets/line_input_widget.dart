
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
  InputMode _inputMode = InputMode.expression;
  OverlayEntry? _keyboardOverlay;

  @override
  void dispose() {
    _removeKeyboard();
    _equationController.dispose();
    super.dispose();
  }

  void _toggleKeyboard() {
    if (_showKeyboard) {
      _removeKeyboard();
    } else {
      _showFloatingKeyboard();
    }
    setState(() => _showKeyboard = !_showKeyboard);
  }

  void _showFloatingKeyboard() {
    _keyboardOverlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          elevation: 8,
          child: MathKeyboard(
            controller: _equationController,
            onSubmit: () {
              _addLine();
              _toggleKeyboard();
            },
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_keyboardOverlay!);
  }

  void _removeKeyboard() {
    _keyboardOverlay?.remove();
    _keyboardOverlay = null;
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

  void _showInputModeMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.functions),
              title: const Text('Expression'),
              subtitle: const Text('Enter mathematical expressions'),
              onTap: () {
                setState(() => _inputMode = InputMode.expression);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Text'),
              subtitle: const Text('Add text labels'),
              onTap: () {
                setState(() => _inputMode = InputMode.text);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help'),
              subtitle: const Text('View commands and documentation'),
              onTap: () {
                Navigator.pop(context);
                _showHelpDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mathematical Commands'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpSection('Basic Functions', [
                'sin(x), cos(x), tan(x)',
                'ln(x), log10(x)',
                'sqrt(x), abs(x)',
                'exp(x) = e^x',
              ]),
              const SizedBox(height: 16),
              _buildHelpSection('Linear Equations', [
                'y = 2x + 3',
                'y = -1/2*x + 1',
                'y = 0.5x - 2',
              ]),
              const SizedBox(height: 16),
              _buildHelpSection('Trigonometric', [
                'y = sin(x)',
                'y = cos(2x)',
                'y = tan(x/2)',
              ]),
              const SizedBox(height: 16),
              _buildHelpSection('Powers & Exponentials', [
                'y = x^2',
                'y = 2^x',
                'y = e^x',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 4),
          child: Text('• $item', style: const TextStyle(fontSize: 13)),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
      ),
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.functions,
                      color: Colors.white,
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
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Equation Input Field
              TextField(
                controller: _equationController,
                readOnly: true,
                onTap: _toggleKeyboard,
                decoration: InputDecoration(
                  hintText: _inputMode == InputMode.expression 
                      ? 'y = 2x + 3' 
                      : 'Enter text...',
                  prefixIcon: Icon(
                    _inputMode == InputMode.expression 
                        ? Icons.functions 
                        : Icons.text_fields,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: _showInputModeMenu,
                        tooltip: 'Input Mode',
                      ),
                      IconButton(
                        icon: Icon(_showKeyboard ? Icons.keyboard_hide : Icons.keyboard),
                        onPressed: _toggleKeyboard,
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPresetChip('y=2x+1', Icons.show_chart),
                    _buildPresetChip('y=-1/2*x+3', Icons.trending_down),
                    _buildPresetChip('y=sin(x)', Icons.waves),
                    _buildPresetChip('y=cos(x)', Icons.graphic_eq),
                    _buildPresetChip('y=x^2', Icons.architecture),
                    _buildPresetChip('y=sqrt(x)', Icons.square_foot),
                    _buildPresetChip('y=ln(x)', Icons.insights),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              Text(
                'Input Expressions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
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
    );
  }

  Widget _buildPresetChip(String equation, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(equation, style: const TextStyle(fontSize: 12)),
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
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No equations yet. Add your first equation above!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(provider.lines.length, (index) {
            final line = provider.lines[index];
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    line.color.withOpacity(0.15),
                    line.color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: line.color.withOpacity(0.3)),
              ),
              child: Chip(
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
                label: Text(
                  line.equation,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onDeleted: () => provider.removeLine(index),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: Colors.transparent,
              ),
            );
          }),
        );
      },
    );
  }
}

enum InputMode { expression, text }
