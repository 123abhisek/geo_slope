import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';

class SliderControls extends StatelessWidget {
  const SliderControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transformations',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: provider.resetSliders,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSlider(
                  context,
                  'Amplitude (a)',
                  provider.aValue,
                  -5,
                  5,
                  (value) => provider.updateSliders(a: value),
                ),
                _buildSlider(
                  context,
                  'Frequency (b)',
                  provider.bValue,
                  -5,
                  5,
                  (value) => provider.updateSliders(b: value),
                ),
                _buildSlider(
                  context,
                  'Horizontal Shift (c)',
                  provider.cValue,
                  -10,
                  10,
                  (value) => provider.updateSliders(c: value),
                ),
                _buildSlider(
                  context,
                  'Vertical Shift (d)',
                  provider.dValue,
                  -10,
                  10,
                  (value) => provider.updateSliders(d: value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) * 10).toInt(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
