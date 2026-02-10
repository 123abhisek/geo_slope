import 'package:flutter/material.dart';

class MathKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;

  const MathKeyboard({
    super.key,
    required this.controller,
    this.onSubmit,
  });

  void _insertText(String text) {
    final currentText = controller.text;
    final selection = controller.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      text,
    );
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + text.length,
      ),
    );
  }

  void _backspace() {
    final currentText = controller.text;
    final selection = controller.selection;
    if (selection.start > 0) {
      final newText = currentText.replaceRange(
        selection.start - 1,
        selection.end,
        '',
      );
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start - 1,
        ),
      );
    }
  }

  void _clear() {
    controller.clear();
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
          
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Column(
              children: [
                Text(
                  'Mathematical Keyboard',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Number rows
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
                  _KeyButton('/', () => _insertText('/'), type: _KeyType.operator),
                  _KeyButton('+', () => _insertText('+'), type: _KeyType.operator),
                  _KeyButton('( )', () => _insertText('()'), type: _KeyType.operator),
                ]),
                
                const SizedBox(height: 8),
                
                // Variables
                _buildKeyRow([
                  _KeyButton('x', () => _insertText('x'), type: _KeyType.variable),
                  _KeyButton('y', () => _insertText('y'), type: _KeyType.variable),
                  _KeyButton('π', () => _insertText('pi'), type: _KeyType.variable),
                  _KeyButton('e', () => _insertText('e'), type: _KeyType.variable),
                  _KeyButton('t', () => _insertText('t'), type: _KeyType.variable),
                ]),
                
                const SizedBox(height: 8),
                
                // Functions
                _buildKeyRow([
                  _KeyButton('sin', () => _insertText('sin('), type: _KeyType.function),
                  _KeyButton('cos', () => _insertText('cos('), type: _KeyType.function),
                  _KeyButton('tan', () => _insertText('tan('), type: _KeyType.function),
                  _KeyButton('log', () => _insertText('log('), type: _KeyType.function),
                  _KeyButton('ln', () => _insertText('ln('), type: _KeyType.function),
                ]),
                
                const SizedBox(height: 12),
                
                // Control buttons
                Row(
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
                        onPressed: onSubmit,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Done'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                fontSize: type == _KeyType.function ? 13 : 16,
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
