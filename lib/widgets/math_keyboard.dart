

import 'package:flutter/material.dart';

class MathKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;

  const MathKeyboard({
    super.key,
    required this.controller,
    this.onSubmit,
  });

  @override
  State<MathKeyboard> createState() => _MathKeyboardState();
}

class _MathKeyboardState extends State<MathKeyboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() => _currentTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _insertText(String text) {
    final currentText = widget.controller.text;
    final selection = widget.controller.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + text.length,
      ),
    );
  }

  void _backspace() {
    final currentText = widget.controller.text;
    final selection = widget.controller.selection;
    if (selection.start > 0) {
      final newText = currentText.replaceRange(
        selection.start - 1,
        selection.end,
        '',
      );
      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start - 1,
        ),
      );
    }
  }

  void _clear() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mathematical Keyboard',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Help'),
                        content: const Text(
                          'Use this keyboard to enter mathematical expressions.\n\n'
                          '• Numbers: Basic numeric input\n'
                          '• Operators: +, −, ×, ÷, ^\n'
                          '• Functions: sin, cos, tan, log, ln\n'
                          '• Variables: x, y, π, e\n'
                          '• Symbols: Special math symbols',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: '123'),
              Tab(text: 'f(x)'),
              Tab(text: 'abc'),
              Tab(text: '#&~'),
            ],
          ),
          
          // Tab Content
          SizedBox(
            height: 280,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNumbersTab(),
                _buildFunctionsTab(),
                _buildVariablesTab(),
                _buildSymbolsTab(),
              ],
            ),
          ),
          
          // Control buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _clear,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _backspace,
                    icon: const Icon(Icons.backspace_outlined, size: 18),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: widget.onSubmit,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Done'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Numbers Tab
  Widget _buildNumbersTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildKeyRow([
            _KeyButton('7', () => _insertText('7'), type: _KeyType.number),
            _KeyButton('8', () => _insertText('8'), type: _KeyType.number),
            _KeyButton('9', () => _insertText('9'), type: _KeyType.number),
            _KeyButton('÷', () => _insertText('/'), type: _KeyType.operator),
            _KeyButton('x²', () => _insertText('^2'), type: _KeyType.operator),
          ]),
          _buildKeyRow([
            _KeyButton('4', () => _insertText('4'), type: _KeyType.number),
            _KeyButton('5', () => _insertText('5'), type: _KeyType.number),
            _KeyButton('6', () => _insertText('6'), type: _KeyType.number),
            _KeyButton('×', () => _insertText('*'), type: _KeyType.operator),
            _KeyButton('√', () => _insertText('sqrt('), type: _KeyType.operator),
          ]),
          _buildKeyRow([
            _KeyButton('1', () => _insertText('1'), type: _KeyType.number),
            _KeyButton('2', () => _insertText('2'), type: _KeyType.number),
            _KeyButton('3', () => _insertText('3'), type: _KeyType.number),
            _KeyButton('−', () => _insertText('-'), type: _KeyType.operator),
            _KeyButton('xⁿ', () => _insertText('^'), type: _KeyType.operator),
          ]),
          _buildKeyRow([
            _KeyButton('0', () => _insertText('0'), type: _KeyType.number),
            _KeyButton('.', () => _insertText('.'), type: _KeyType.number),
            _KeyButton('=', () => _insertText('='), type: _KeyType.operator),
            _KeyButton('+', () => _insertText('+'), type: _KeyType.operator),
            _KeyButton('( )', () => _insertText('()'), type: _KeyType.operator),
          ]),
        ],
      ),
    );
  }

  // Functions Tab
  Widget _buildFunctionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Basic Trigonometry
          _buildKeyRow([
            _KeyButton('sin', () => _insertText('sin('), type: _KeyType.function),
            _KeyButton('cos', () => _insertText('cos('), type: _KeyType.function),
            _KeyButton('tan', () => _insertText('tan('), type: _KeyType.function),
          ]),
          const SizedBox(height: 8),
          
          // Inverse Trigonometry
          _buildKeyRow([
            _KeyButton('sin⁻¹', () => _insertText('asin('), type: _KeyType.function),
            _KeyButton('cos⁻¹', () => _insertText('acos('), type: _KeyType.function),
            _KeyButton('tan⁻¹', () => _insertText('atan('), type: _KeyType.function),
          ]),
          const SizedBox(height: 8),
          
          // Logarithms
          _buildKeyRow([
            _KeyButton('ln', () => _insertText('ln('), type: _KeyType.function),
            _KeyButton('log₁₀', () => _insertText('log10('), type: _KeyType.function),
            _KeyButton('logₓ', () => _insertText('log('), type: _KeyType.function),
          ]),
          const SizedBox(height: 8),
          
          // Powers & Roots
          _buildKeyRow([
            _KeyButton('eˣ', () => _insertText('exp('), type: _KeyType.function),
            _KeyButton('10ˣ', () => _insertText('10^'), type: _KeyType.function),
            _KeyButton('√', () => _insertText('sqrt('), type: _KeyType.function),
          ]),
          const SizedBox(height: 8),
          
          // Calculus
          _buildKeyRow([
            _KeyButton('d/dx', () => _insertText('diff('), type: _KeyType.function),
            _KeyButton('∫', () => _insertText('int('), type: _KeyType.function),
            _KeyButton('∑', () => _insertText('sum('), type: _KeyType.function),
          ]),
          const SizedBox(height: 8),
          
          // Other Functions
          _buildKeyRow([
            _KeyButton('|x|', () => _insertText('abs('), type: _KeyType.function),
            _KeyButton('⌊x⌋', () => _insertText('floor('), type: _KeyType.function),
            _KeyButton('⌈x⌉', () => _insertText('ceil('), type: _KeyType.function),
          ]),
        ],
      ),
    );
  }

  // Variables Tab
  Widget _buildVariablesTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Basic Variables
          _buildKeyRow([
            _KeyButton('x', () => _insertText('x'), type: _KeyType.variable),
            _KeyButton('y', () => _insertText('y'), type: _KeyType.variable),
            _KeyButton('z', () => _insertText('z'), type: _KeyType.variable),
            _KeyButton('t', () => _insertText('t'), type: _KeyType.variable),
            _KeyButton('n', () => _insertText('n'), type: _KeyType.variable),
          ]),
          const SizedBox(height: 8),
          
          // Greek Letters
          _buildKeyRow([
            _KeyButton('π', () => _insertText('pi'), type: _KeyType.variable),
            _KeyButton('θ', () => _insertText('theta'), type: _KeyType.variable),
            _KeyButton('α', () => _insertText('alpha'), type: _KeyType.variable),
            _KeyButton('β', () => _insertText('beta'), type: _KeyType.variable),
            _KeyButton('γ', () => _insertText('gamma'), type: _KeyType.variable),
          ]),
          const SizedBox(height: 8),
          
          // Constants
          _buildKeyRow([
            _KeyButton('e', () => _insertText('e'), type: _KeyType.variable),
            _KeyButton('∞', () => _insertText('inf'), type: _KeyType.variable),
            _KeyButton('i', () => _insertText('i'), type: _KeyType.variable),
          ]),
          const SizedBox(height: 8),
          
          // Subscripts
          _buildKeyRow([
            _KeyButton('x₁', () => _insertText('x_1'), type: _KeyType.variable),
            _KeyButton('x₂', () => _insertText('x_2'), type: _KeyType.variable),
            _KeyButton('xₙ', () => _insertText('x_n'), type: _KeyType.variable),
          ]),
        ],
      ),
    );
  }

  // Symbols Tab
  Widget _buildSymbolsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Comparison
          _buildKeyRow([
            _KeyButton('<', () => _insertText('<'), type: _KeyType.operator),
            _KeyButton('>', () => _insertText('>'), type: _KeyType.operator),
            _KeyButton('≤', () => _insertText('<='), type: _KeyType.operator),
            _KeyButton('≥', () => _insertText('>='), type: _KeyType.operator),
            _KeyButton('≠', () => _insertText('!='), type: _KeyType.operator),
          ]),
          const SizedBox(height: 8),
          
          // Logic
          _buildKeyRow([
            _KeyButton('∧', () => _insertText('and'), type: _KeyType.operator),
            _KeyButton('∨', () => _insertText('or'), type: _KeyType.operator),
            _KeyButton('¬', () => _insertText('not'), type: _KeyType.operator),
          ]),
          const SizedBox(height: 8),
          
          // Brackets
          _buildKeyRow([
            _KeyButton('( )', () => _insertText('()'), type: _KeyType.operator),
            _KeyButton('[ ]', () => _insertText('[]'), type: _KeyType.operator),
            _KeyButton('{ }', () => _insertText('{}'), type: _KeyType.operator),
            _KeyButton('| |', () => _insertText('||'), type: _KeyType.operator),
          ]),
          const SizedBox(height: 8),
          
          // Special Symbols
          _buildKeyRow([
            _KeyButton('±', () => _insertText('+-'), type: _KeyType.operator),
            _KeyButton('∓', () => _insertText('-+'), type: _KeyType.operator),
            _KeyButton('×', () => _insertText('*'), type: _KeyType.operator),
            _KeyButton('÷', () => _insertText('/'), type: _KeyType.operator),
          ]),
          const SizedBox(height: 8),
          
          // Fractions & More
          _buildKeyRow([
            _KeyButton('½', () => _insertText('1/2'), type: _KeyType.number),
            _KeyButton('⅓', () => _insertText('1/3'), type: _KeyType.number),
            _KeyButton('¼', () => _insertText('1/4'), type: _KeyType.number),
            _KeyButton('⅔', () => _insertText('2/3'), type: _KeyType.number),
            _KeyButton('¾', () => _insertText('3/4'), type: _KeyType.number),
          ]),
          const SizedBox(height: 8),
          
          // Arrows
          _buildKeyRow([
            _KeyButton('→', () => _insertText('->'), type: _KeyType.operator),
            _KeyButton('←', () => _insertText('<-'), type: _KeyType.operator),
            _KeyButton('↔', () => _insertText('<->'), type: _KeyType.operator),
          ]),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<Widget> buttons) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: buttons.map((button) => Expanded(child: button)).toList(),
      ),
    );
  }
}

enum _KeyType { number, operator, variable, function }

class _KeyButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final _KeyType type;

  const _KeyButton(
    this.label,
    this.onPressed, {
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case _KeyType.variable:
        bgColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        break;
      case _KeyType.function:
        bgColor = Theme.of(context).colorScheme.secondaryContainer;
        textColor = Theme.of(context).colorScheme.onSecondaryContainer;
        break;
      case _KeyType.operator:
        bgColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = Theme.of(context).colorScheme.onPrimaryContainer;
        break;
      case _KeyType.number:
        bgColor = Theme.of(context).colorScheme.surfaceVariant;
        textColor = Theme.of(context).colorScheme.onSurface;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: type == _KeyType.function || label.length > 3 ? 12 : 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
