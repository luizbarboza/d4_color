import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  test("Hsl(…) returns an instance of hsl and color", () {
    final c = Hsl(120, 0.4, 0.5);
    expect(c, isA<Hsl>());
    expect(c, isA<Color>());
  });

  test("Hsl.from(…) exposes h, s, and l channel values and opacity", () {
    expect(
        Hsl.from("#abc"),
        HasHslValues(
            [210.00000000000003, 0.25000000000000017, 0.7333333333333334, 1]));
    expect(
        Hsl.from("hsla(60, 100%, 20%, 0.4)"), HasHslValues([60, 1, 0.2, 0.4]));
  });

  test("hsl.toString() converts to RGB and formats as rgb(…) or rgba(…)", () {
    expect(Hsl.from("#abcdef").toString(), "rgb(171, 205, 239)");
    expect(Hsl.from("moccasin").toString(), "rgb(255, 228, 181)");
    expect(Hsl.from("hsl(60, 100%, 20%)").toString(), "rgb(102, 102, 0)");
    expect(Hsl.from("hsla(60, 100%, 20%, 0.4)").toString(),
        "rgba(102, 102, 0, 0.4)");
    expect(Hsl.from("rgb(12, 34, 56)").toString(), "rgb(12, 34, 56)");
    expect(Hsl.from(Rgb(12, 34, 56)).toString(), "rgb(12, 34, 56)");
    expect(Hsl.from(Hsl(60, 1, 0.2)).toString(), "rgb(102, 102, 0)");
    expect(Hsl.from(Hsl(60, 1, 0.2, 0.4)).toString(), "rgba(102, 102, 0, 0.4)");
  });

  test("hsl.formatRgb() formats as rgb(…) or rgba(…)", () {
    expect(Hsl.from("#abcdef").formatRgb(), "rgb(171, 205, 239)");
    expect(Hsl.from("hsl(60, 100%, 20%)").formatRgb(), "rgb(102, 102, 0)");
    expect(Hsl.from("rgba(12%, 34%, 56%, 0.4)").formatRgb(),
        "rgba(31, 87, 143, 0.4)");
    expect(Hsl.from("hsla(60, 100%, 20%, 0.4)").formatRgb(),
        "rgba(102, 102, 0, 0.4)");
  });

  test("hsl.formatHsl() formats as hsl(…) or hsla(…)", () {
    expect(Hsl.from("#abcdef").formatHsl(),
        "hsl(210.0, 68.0%, 80.3921568627451%)");
    expect(Hsl.from("hsl(60, 100%, 20%)").formatHsl(), "hsl(60, 100%, 20.0%)");
    expect(Hsl.from("rgba(12%, 34%, 56%, 0.4)").formatHsl(),
        "hsla(210.0, 64.70588235294117%, 34.0%, 0.4)");
    expect(Hsl.from("hsla(60, 100%, 20%, 0.4)").formatHsl(),
        "hsla(60, 100%, 20.0%, 0.4)");
  });

  test("hsl.formatHsl() clamps to the expected range", () {
    expect(Hsl(180, -100, -50).formatHsl(), "hsl(180, 0%, 0%)");
    expect(Hsl(180, 150, 200).formatHsl(), "hsl(180, 100%, 100%)");
    expect(Hsl(-90, 50, 50).formatHsl(), "hsl(270, 100%, 100%)");
    expect(Hsl(420, 50, 50).formatHsl(), "hsl(60, 100%, 100%)");
  });

  test("hsl.formatHex() formats as #rrggbb", () {
    expect(Hsl.from("#abcdef").formatHex(), "#abcdef");
    expect(Hsl.from("hsl(60, 100%, 20%)").formatHex(), "#666600");
    expect(Hsl.from("rgba(12%, 34%, 56%, 0.4)").formatHex(), "#1f578f");
    expect(Hsl.from("hsla(60, 100%, 20%, 0.4)").formatHex(), "#666600");
  });

  test("hsl.toString() reflects h, s and l channel values and opacity", () {
    final c = Hsl.from("#abc");
    c.h += 10;
    c.s += 0.01;
    c.l -= 0.01;
    c.opacity = 0.4;
    expect(c.toString(), "rgba(166, 178, 203, 0.4)");
  });

  test("hsl.toString() treats undefined channel values as 0", () {
    expect(Hsl.from("invalid").toString(), "rgb(0, 0, 0)");
    expect(Hsl.from("#000").toString(), "rgb(0, 0, 0)");
    expect(Hsl.from("#ccc").toString(), "rgb(204, 204, 204)");
    expect(Hsl.from("#fff").toString(), "rgb(255, 255, 255)");
    expect(Hsl(double.nan, 0.5, 0.4).toString(),
        "rgb(102, 102, 102)"); // equivalent to hsl(*, 0, 0.4)
    expect(Hsl(120, double.nan, 0.4).toString(), "rgb(102, 102, 102)");
    expect(Hsl(double.nan, double.nan, 0.4).toString(), "rgb(102, 102, 102)");
    expect(Hsl(120, 0.5, double.nan).toString(),
        "rgb(0, 0, 0)"); // equivalent to hsl(120, 0.5, 0)
  });

  test("hsl.toString() treats undefined opacity as 1", () {
    final c = Hsl.from("#abc");
    c.opacity = double.nan;
    expect(c.toString(), "rgb(170, 187, 204)");
  });

  test("Hsl(h, s, l) does not wrap hue to [0,360)", () {
    expect(Hsl(-10, 0.4, 0.5), HasHslValues([-10, 0.4, 0.5, 1]));
    expect(Hsl(0, 0.4, 0.5), HasHslValues([0, 0.4, 0.5, 1]));
    expect(Hsl(360, 0.4, 0.5), HasHslValues([360, 0.4, 0.5, 1]));
    expect(Hsl(370, 0.4, 0.5), HasHslValues([370, 0.4, 0.5, 1]));
  });

  test("Hsl(h, s, l) does not clamp s and l channel values to [0,1]", () {
    expect(Hsl(120, -0.1, 0.5), HasHslValues([120, -0.1, 0.5, 1]));
    expect(Hsl(120, 1.1, 0.5), HasHslValues([120, 1.1, 0.5, 1]));
    expect(Hsl(120, 0.2, -0.1), HasHslValues([120, 0.2, -0.1, 1]));
    expect(Hsl(120, 0.2, 1.1), HasHslValues([120, 0.2, 1.1, 1]));
  });

  test("Hsl(h, s, l).clamp() clamps channel values", () {
    expect(Hsl(120, -0.1, -0.2).clamp(), HasHslValues([120, 0, 0, 1]));
    expect(Hsl(120, 1.1, 1.2).clamp(), HasHslValues([120, 1, 1, 1]));
    expect(Hsl(120, 2.1, 2.2).clamp(), HasHslValues([120, 1, 1, 1]));
    expect(Hsl(420, -0.1, -0.2).clamp(), HasHslValues([60, 0, 0, 1]));
    expect(Hsl(-420, -0.1, -0.2).clamp(), HasHslValues([300, 0, 0, 1]));
    expect(Hsl(-420, -0.1, -0.2, double.nan).clamp().opacity, 1);
    expect(Hsl(-420, -0.1, -0.2, 0.5).clamp().opacity, 0.5);
    expect(Hsl(-420, -0.1, -0.2, -1).clamp().opacity, 0);
    expect(Hsl(-420, -0.1, -0.2, 2).clamp().opacity, 1);
  });

  test("Hsl(h, s, l, opacity) does not clamp opacity to [0,1]", () {
    expect(Hsl(120, 0.1, 0.5, -0.2), HasHslValues([120, 0.1, 0.5, -0.2]));
    expect(Hsl(120, 0.9, 0.5, 1.2), HasHslValues([120, 0.9, 0.5, 1.2]));
  });

  test("Hsl(h, s, l) preserves explicit hue, even for grays", () {
    expect(Hsl(0, 0, 0), HasHslValues([0, 0, 0, 1]));
    expect(Hsl(42, 0, 0.5), HasHslValues([42, 0, 0.5, 1]));
    expect(Hsl(118, 0, 1), HasHslValues([118, 0, 1, 1]));
  });

  test("Hsl(h, s, l) preserves explicit saturation, even for white or black",
      () {
    expect(Hsl(0, 0, 0), HasHslValues([0, 0, 0, 1]));
    expect(Hsl(0, 0.18, 0), HasHslValues([0, 0.18, 0, 1]));
    expect(Hsl(0, 0.42, 1), HasHslValues([0, 0.42, 1, 1]));
    expect(Hsl(0, 1, 1), HasHslValues([0, 1, 1, 1]));
  });

  test("Hsl.from(format) parses the specified format and converts to HSL", () {
    expect(
        Hsl.from("#abcdef"), HasHslValues([210, 0.68, 0.803921568627451, 1]));
    expect(
        Hsl.from("#abc"),
        HasHslValues(
            [210.00000000000003, 0.25000000000000017, 0.7333333333333334, 1]));
    expect(Hsl.from("rgb(12, 34, 56)"),
        HasHslValues([210, 0.6470588235294118, 0.13333333333333333, 1]));
    expect(Hsl.from("rgb(12%, 34%, 56%)"),
        HasHslValues([210, 0.6470588235294118, 0.34, 1]));
    expect(Hsl.from("hsl(60,100%,20%)"), HasHslValues([60, 1, 0.2, 1]));
    expect(Hsl.from("hsla(60,100%,20%,0.4)"), HasHslValues([60, 1, 0.2, 0.4]));
    expect(
        Hsl.from("aliceblue"), HasHslValues([208, 1, 0.9705882352941176, 1]));
    expect(Hsl.from("transparent"),
        HasHslValues([double.nan, double.nan, double.nan, 0]));
  });

  test("Hsl.from(format) ignores the hue if the saturation is <= 0", () {
    expect(Hsl.from("hsl(120,0%,20%)"), HasHslValues([double.nan, 0, 0.2, 1]));
    expect(Hsl.from("hsl(120,-10%,20%)"),
        HasHslValues([double.nan, -0.1, 0.2, 1]));
  });

  test(
      "Hsl.from(format) ignores the hue and saturation if the lightness is <= 0 or >= 1",
      () {
    expect(Hsl.from("hsl(120,20%,-10%)"),
        HasHslValues([double.nan, double.nan, -0.1, 1]));
    expect(Hsl.from("hsl(120,20%,0%)"),
        HasHslValues([double.nan, double.nan, 0.0, 1]));
    expect(Hsl.from("hsl(120,20%,100%)"),
        HasHslValues([double.nan, double.nan, 1.0, 1]));
    expect(Hsl.from("hsl(120,20%,120%)"),
        HasHslValues([double.nan, double.nan, 1.2, 1]));
  });

  test("Hsl.from(format) ignores all channels if the alpha is <= 0", () {
    expect(Hsl.from("hsla(120,20%,10%,0)"),
        HasHslValues([double.nan, double.nan, double.nan, 0]));
    expect(Hsl.from("hsla(120,20%,10%,-0.1)"),
        HasHslValues([double.nan, double.nan, double.nan, -0.1]));
  });

  test("Hsl.from(format) does not lose precision when parsing HSL formats", () {
    expect(Hsl.from("hsl(325,50%,40%)"), HasHslValues([325, 0.5, 0.4, 1]));
  });

  test("Hsl.from(format) returns undefined channel values for unknown formats",
      () {
    expect(Hsl.from("invalid"),
        HasHslValues([double.nan, double.nan, double.nan, double.nan]));
  });

  test("Hsl.from(hsl) copies an HSL color", () {
    final c1 = Hsl.from("hsla(120,30%,50%,0.4)");
    final c2 = Hsl.from(c1);
    expect(c1, HasHslValues([120, 0.3, 0.5, 0.4]));
    c1.h = c1.s = c1.l = c1.opacity = 0;
    expect(c1, HasHslValues([0, 0, 0, 0]));
    expect(c2, HasHslValues([120, 0.3, 0.5, 0.4]));
  });

  test("Hsl.from(rgb) converts from RGB", () {
    expect(Hsl.from(Rgb(255, 0, 0, 0.4)), HasHslValues([0, 1, 0.5, 0.4]));
  });

  test(
      "Hsl.from(color) returns undefined hue and zero saturation for grays (but not white and black)",
      () {
    expect(
        Hsl.from("gray"), HasHslValues([double.nan, 0, 0.5019607843137255, 1]));
    expect(Hsl.from("#ccc"), HasHslValues([double.nan, 0, 0.8, 1]));
    expect(Hsl.from(Rgb.from("gray")),
        HasHslValues([double.nan, 0, 0.5019607843137255, 1]));
  });

  test(
      "Hsl.from(color) returns undefined hue and saturation for black and white",
      () {
    expect(Hsl.from("black"), HasHslValues([double.nan, double.nan, 0, 1]));
    expect(Hsl.from("#000"), HasHslValues([double.nan, double.nan, 0, 1]));
    expect(Hsl.from("white"), HasHslValues([double.nan, double.nan, 1, 1]));
    expect(Hsl.from("#fff"), HasHslValues([double.nan, double.nan, 1, 1]));
    expect(Hsl.from(Rgb.from("#fff")),
        HasHslValues([double.nan, double.nan, 1, 1]));
  });

  test("Hsl(color) converts from another colorspace via rgb()", () {
    expect(Hsl.from(TestColor()),
        HasHslValues([210, 0.6470588235294118, 0.13333333333333333, 0.4]));
  });

  test(
      "hsl.displayable() returns true if the color is within the RGB gamut and the opacity is in [0,1]",
      () {
    expect(Hsl.from("white").displayable(), true);
    expect(Hsl.from("red").displayable(), true);
    expect(Hsl.from("black").displayable(), true);
    expect(Hsl.from("invalid").displayable(), false);
    expect(Hsl(double.nan, double.nan, 1).displayable(), true);
    expect(Hsl(double.nan, double.nan, 1.5).displayable(), false);
    expect(Hsl(120, -0.5, 0).displayable(), false);
    expect(Hsl(120, 1.5, 0).displayable(), false);
    expect(Hsl(0, 1, 1, 0).displayable(), true);
    expect(Hsl(0, 1, 1, 1).displayable(), true);
    expect(Hsl(0, 1, 1, -0.2).displayable(), false);
    expect(Hsl(0, 1, 1, 1.2).displayable(), false);
  });

  test("hsl.brighter(k) returns a brighter color if k > 0", () {
    final c = Hsl.from("rgba(165, 42, 42, 0.4)");
    expect(c.brighter(0.5),
        HasHslValues([0, 0.5942028985507247, 0.48512220025925384, 0.4]));
    expect(c.brighter(1),
        HasHslValues([0, 0.5942028985507247, 0.5798319327731093, 0.4]));
    expect(c.brighter(2),
        HasHslValues([0, 0.5942028985507247, 0.8283313325330133, 0.4]));
  });

  test("hsl.brighter(k) returns a copy", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1);
    expect(
        c1, HasHslValues([207.27272727272728, 0.44, 0.4901960784313726, 0.4]));
    expect(
        c2, HasHslValues([207.27272727272728, 0.44, 0.700280112044818, 0.4]));
  });

  test("hsl.brighter() is equivalent to hsl.brighter(1)", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter();
    final c3 = c1.brighter(1);
    expect(c2, HasHslValues([c3.h, c3.s, c3.l, 0.4]));
  });

  test("hsl.brighter(k) is equivalent to hsl.darker(-k)", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1.5);
    final c3 = c1.darker(-1.5);
    expect(c2.h, c3.h);
    expect(c2.s, c3.s);
    expect(c2.l, closeTo(c3.l, 1e-15));
  });

  test("Hsl.from(\"black\").brighter() still returns black", () {
    final c1 = Hsl.from("black");
    final c2 = c1.brighter(1);
    expect(c1, HasHslValues([double.nan, double.nan, 0, 1]));
    expect(c2, HasHslValues([double.nan, double.nan, 0, 1]));
  });

  test("hsl.darker(k) returns a darker color if k > 0", () {
    final c = Hsl.from("rgba(165, 42, 42, 0.4)");
    expect(c.darker(0.5),
        HasHslValues([0, 0.5942028985507247, 0.33958554018147774, 0.4]));
    expect(c.darker(1),
        HasHslValues([0, 0.5942028985507247, 0.28411764705882353, 0.4]));
    expect(c.darker(2),
        HasHslValues([0, 0.5942028985507247, 0.19888235294117645, 0.4]));
  });

  test("hsl.darker(k) returns a copy", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1);
    expect(
        c1, HasHslValues([207.27272727272728, 0.44, 0.4901960784313726, 0.4]));
    expect(
        c2, HasHslValues([207.27272727272728, 0.44, 0.3431372549019608, 0.4]));
  });

  test("hsl.darker() is equivalent to hsl.darker(1)", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker();
    final c3 = c1.darker(1);
    expect(c2, HasHslValues([c3.h, c3.s, c3.l, 0.4]));
  });

  test("hsl.darker(k) is equivalent to hsl.brighter(-k)", () {
    final c1 = Hsl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1.5);
    final c3 = c1.brighter(-1.5);
    expect(c2.h, c3.h);
    expect(c2.s, c3.s);
    expect(c2.l, closeTo(c3.l, 1e-15));
  });

  test("hsl.rgb() converts to RGB", () {
    final c = Hsl(120, 0.3, 0.5, 0.4);
    expect(c.rgb(), HasApproxRgbValues([89, 166, 89, 0.4]));
  });

  test("hsl.copy(…) returns a new hsl with the specified channel values", () {
    final c = Hsl(120, 0.3, 0.5, 0.4);
    expect(c.copy(), isA<Hsl>());
    expect(c.copy().formatHsl(), "hsla(120, 30.0%, 50.0%, 0.4)");
    expect(c.copyWith(opacity: 1).formatHsl(), "hsl(120, 30.0%, 50.0%)");
    expect(c.copyWith(h: 20).formatHsl(), "hsla(20, 30.0%, 50.0%, 0.4)");
    expect(
        c.copyWith(h: 20, s: 0.4).formatHsl(), "hsla(20, 40.0%, 50.0%, 0.4)");
  });
}

class TestColor extends Color {
  @override
  copy() => throw UnimplementedError();

  @override
  brighter([num k = 1]) => throw UnimplementedError();

  @override
  darker([num k = 1]) => throw UnimplementedError();

  @override
  rgb() => Rgb(12, 34, 56, 0.4);

  @override
  toString() => throw "should use rgb, not toString";
}
