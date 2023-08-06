import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

class HasRgbValues extends CustomMatcher {
  HasRgbValues(matcher)
      : super("Rgb which when represented as [r, g, b, opacity] is equal to",
            "a representation", matcher);

  @override
  featureValueOf(actual) =>
      [(actual as Rgb).r, actual.g, actual.b, actual.opacity];
}

class HasApproxRgbValues extends CustomMatcher {
  HasApproxRgbValues(List<num> values)
      : super(
            "Rgb which when represented as [r, g, b, opacity] is approximately equal to",
            "a representation",
            equals(values.map((v) => v.isNaN ? isNaN : v.round()).toList()));

  @override
  featureValueOf(actual) => [
        (actual as Rgb).r.isNaN ? actual.r : actual.r.round(),
        actual.g.isNaN ? actual.g : actual.g.round(),
        actual.b.isNaN ? actual.b : actual.b.round(),
        actual.opacity.isNaN ? actual.opacity : actual.opacity.round()
      ];
}

class HasHclValues extends CustomMatcher {
  HasHclValues(List<num> values)
      : super(
            "Hcl which when represented as [h, s, l, opacity] is equal to",
            "a representation",
            equals(values.map((v) => v.isNaN ? isNaN : v).toList()));

  @override
  featureValueOf(actual) =>
      [(actual as Hcl).h, actual.c, actual.l, actual.opacity];
}

class HasHslValues extends CustomMatcher {
  HasHslValues(List<num> values)
      : super(
            "Hsl which when represented as [h, s, l, opacity] is equal to",
            "a representation",
            equals(values.map((v) => v.isNaN ? isNaN : v).toList()));

  @override
  featureValueOf(actual) =>
      [(actual as Hsl).h, actual.s, actual.l, actual.opacity];
}

class HasLabValues extends CustomMatcher {
  HasLabValues(List<num> values)
      : super(
            "Hsl which when represented as [h, s, l, opacity] is equal to",
            "a representation",
            equals(values.map((v) => v.isNaN ? isNaN : v).toList()));

  @override
  featureValueOf(actual) =>
      [(actual as Lab).l, actual.a, actual.b, actual.opacity];
}
