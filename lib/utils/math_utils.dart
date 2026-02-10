class MathUtils {
  static bool isParallel(double m1, double m2) {
    return (m1 - m2).abs() < 0.0001;
  }

  static bool isPerpendicular(double m1, double m2) {
    double product = m1 * m2;
    return (product + 1).abs() < 0.0001;
  }

  static String getRelationExplanation(double m1, double m2, String line1, String line2) {
    if (isParallel(m1, m2)) {
      return '$line1 ∥ $line2\nm₁ = m₂ = ${m1.toStringAsFixed(2)}';
    } else if (isPerpendicular(m1, m2)) {
      return '$line1 ⊥ $line2\nm₁ × m₂ = ${m1.toStringAsFixed(2)} × ${m2.toStringAsFixed(2)} = ${(m1 * m2).toStringAsFixed(2)}';
    }
    return '$line1 and $line2 are neither parallel nor perpendicular';
  }
}
