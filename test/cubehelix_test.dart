import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

void main() {
  test("Cubehelix.from(…) returns an instance of cubehelix and color", () {
    final c = Cubehelix.from("steelblue");
    expect(c, isA<Cubehelix>());
    expect(c, isA<Color>());
  });
}
