import 'dart:math';

class DataGenerator {
  DataGenerator._();
  static final _rng = Random();

  static List<double> generateSeries({
    int count = 12,
    double min = 10,
    double max = 100,
    double? seed,
  }) {
    double current = seed ?? (min + (max - min) * 0.5);
    final List<double> series = [];
    for (int i = 0; i < count; i++) {
      final delta = (_rng.nextDouble() - 0.48) * (max - min) * 0.15;
      current = (current + delta).clamp(min, max);
      series.add(double.parse(current.toStringAsFixed(2)));
    }
    return series;
  }

  static List<double> mutateSeries(List<double> existing, {double volatility = 0.08}) {
    return existing.map((v) {
      final delta = (_rng.nextDouble() - 0.48) * v * volatility * 2;
      return (v + delta).clamp(0.1, double.infinity);
    }).toList();
  }

  static double randomBetween(double min, double max) {
    return min + _rng.nextDouble() * (max - min);
  }

  static int randomInt(int min, int max) {
    return min + _rng.nextInt(max - min);
  }

  static double percentChange(double prev, double curr) {
    if (prev == 0) return 0;
    return ((curr - prev) / prev) * 100;
  }

  static List<double> generatePieData(int segments) {
    final rawList = List.generate(segments, (_) => _rng.nextDouble() + 0.2);
    final total = rawList.fold(0.0, (a, b) => a + b);
    return rawList.map((v) => (v / total) * 100).toList();
  }

  static List<String> get monthLabels =>
      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  static List<String> get weekLabels =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
}
