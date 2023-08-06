import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  test("Lab.gray(l[, opacity]) is an alias for lab(l, 0, 0[, opacity])", () {
    expect(Lab.gray(120), HasLabValues([120, 0, 0, 1]));
    expect(Lab.gray(120, 0.5), HasLabValues([120, 0, 0, 0.5]));
  });
}
