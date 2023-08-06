import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  test("Hcl(…) returns an instance of hcl and color", () {
    final c = Hcl(120, 40, 50);
    expect(c, isA<Hcl>());
    expect(c, isA<Color>());
  });

  test("Hcl.from(…) exposes h, c, and l channel values", () {
    expect(
        Hcl.from("#abc"),
        HasHclValues(
            [252.37145234745182, 11.223567114593477, 74.96879980931759, 1]));
  });

  test(
      "Hcl.from(…) returns defined hue and undefined chroma for black and white",
      () {
    expect(Hcl.from("black"), HasHclValues([double.nan, double.nan, 0, 1]));
    expect(Hcl.from("#000"), HasHclValues([double.nan, double.nan, 0, 1]));
    expect(Hcl.from(Lab.from("#000")),
        HasHclValues([double.nan, double.nan, 0, 1]));
    expect(Hcl.from("white"), HasHclValues([double.nan, double.nan, 100, 1]));
    expect(Hcl.from("#fff"), HasHclValues([double.nan, double.nan, 100, 1]));
    expect(Hcl.from(Lab.from("#fff")),
        HasHclValues([double.nan, double.nan, 100, 1]));
  });

  test("Hcl.from(…) returns undefined hue and zero chroma for gray", () {
    expect(
        Hcl.from("gray"), HasHclValues([double.nan, 0, 53.585013452169036, 1]));
    expect(Hcl.from(Lab.from("gray")),
        HasHclValues([double.nan, 0, 53.585013452169036, 1]));
  });

  test("hcl.toString() converts to RGB and formats as hexadecimal", () {
    expect(Hcl.from("#abcdef").toString(), "rgb(171, 205, 239)");
    expect(Hcl.from("moccasin").toString(), "rgb(255, 228, 181)");
    expect(Hcl.from("hsl(60, 100%, 20%)").toString(), "rgb(102, 102, 0)");
    expect(Hcl.from("rgb(12, 34, 56)").toString(), "rgb(12, 34, 56)");
    expect(Hcl.from(Rgb(12, 34, 56)).toString(), "rgb(12, 34, 56)");
    expect(Hcl.from(Hsl(60, 1, 0.2)).toString(), "rgb(102, 102, 0)");
  });

  test("hcl.toString() reflects h, c and l channel values", () {
    final c = Hcl.from("#abc");
    c.h += 10;
    c.c += 1;
    c.l -= 1;
    expect(c.toString(), "rgb(170, 183, 204)");
  });

  test("hcl.toString() treats undefined opacity as 1", () {
    final c = Hcl.from("#abc");
    c.opacity = double.nan;
    expect(c.toString(), "rgb(170, 187, 204)");
  });

  test("hcl.toString() treats undefined channel values as 0", () {
    expect(Hcl.from("invalid").toString(), "rgb(0, 0, 0)");
    expect(Hcl.from("#000").toString(), "rgb(0, 0, 0)");
    expect(Hcl.from("#ccc").toString(), "rgb(204, 204, 204)");
    expect(Hcl.from("#fff").toString(), "rgb(255, 255, 255)");
    expect(Hcl(double.nan, 20, 40).toString(),
        "rgb(94, 94, 94)"); // equivalent to hcl(*, *, 40)
    expect(Hcl(120, double.nan, 40).toString(), "rgb(94, 94, 94)");
    expect(Hcl(0, double.nan, 40).toString(), "rgb(94, 94, 94)");
    expect(Hcl(120, 50, double.nan).toString(),
        "rgb(0, 0, 0)"); // equivalent to hcl(*, *, 0)
    expect(Hcl(0, 50, double.nan).toString(), "rgb(0, 0, 0)");
    expect(Hcl(120, 0, double.nan).toString(), "rgb(0, 0, 0)");
  });

  test("Hcl.from(yellow) is displayable", () {
    expect(Hcl.from("yellow").displayable(), true);
    expect(Hcl.from("yellow").toString(), "rgb(255, 255, 0)");
  });

  test("Hcl(h, c, l) does not wrap hue to [0,360)", () {
    expect(Hcl(-10, 40, 50), HasHclValues([-10, 40, 50, 1]));
    expect(Hcl(0, 40, 50), HasHclValues([0, 40, 50, 1]));
    expect(Hcl(360, 40, 50), HasHclValues([360, 40, 50, 1]));
    expect(Hcl(370, 40, 50), HasHclValues([370, 40, 50, 1]));
  });

  test("Hcl(h, c, l) does not clamp l channel value", () {
    expect(Hcl(120, 20, -10), HasHclValues([120, 20, -10, 1]));
    expect(Hcl(120, 20, 0), HasHclValues([120, 20, 0, 1]));
    expect(Hcl(120, 20, 100), HasHclValues([120, 20, 100, 1]));
    expect(Hcl(120, 20, 110), HasHclValues([120, 20, 110, 1]));
  });

  test("Hcl(h, c, l, opacity) does not clamp opacity to [0,1]", () {
    expect(Hcl(120, 20, 100, -0.2), HasHclValues([120, 20, 100, -0.2]));
    expect(Hcl(120, 20, 110, 1.2), HasHclValues([120, 20, 110, 1.2]));
  });

  test("Hcl.from(format) parses the specified format and converts to HCL", () {
    expect(
        Hcl.from("#abcdef"),
        HasHclValues(
            [254.0079700170605, 21.62257586147983, 80.77135418262527, 1]));
    expect(
        Hcl.from("#abc"),
        HasHclValues(
            [252.37145234745182, 11.223567114593477, 74.96879980931759, 1]));
    expect(
        Hcl.from("rgb(12, 34, 56)"),
        HasHclValues(
            [262.8292023352897, 17.30347233219686, 12.404844123471648, 1]));
    expect(
        Hcl.from("rgb(12%, 34%, 56%)"),
        HasHclValues(
            [266.117653326772, 37.03612078188506, 35.48300043476593, 1]));
    expect(
        Hcl.from("rgba(12%, 34%, 56%, 0.4)"),
        HasHclValues(
            [266.117653326772, 37.03612078188506, 35.48300043476593, 0.4]));
    expect(
        Hcl.from("hsl(60,100%,20%)"),
        HasHclValues(
            [99.57458688693686, 48.327323183108916, 41.97125732118659, 1]));
    expect(
        Hcl.from("hsla(60,100%,20%,0.4)"),
        HasHclValues(
            [99.57458688693686, 48.327323183108916, 41.97125732118659, 0.4]));
    expect(
        Hcl.from("aliceblue"),
        HasHclValues(
            [247.7353849904697, 4.681732046417135, 97.12294991108756, 1]));
  });

  test("Hcl.from(format) returns undefined channel values for unknown formats",
      () {
    expect(Hcl.from("invalid"),
        HasHclValues([double.nan, double.nan, double.nan, double.nan]));
  });

  test("Hcl.from(hcl) copies an HCL color", () {
    final c1 = Hcl(120, 30, 50, 0.4);
    final c2 = Hcl.from(c1);
    expect(c1, HasHclValues([120, 30, 50, 0.4]));
    c1.h = c1.c = c1.l = c1.opacity = 0;
    expect(c1, HasHclValues([0, 0, 0, 0]));
    expect(c2, HasHclValues([120, 30, 50, 0.4]));
  });

  test("Hcl.from(lab) returns h = double.nan if a and b are zero", () {
    expect(
        Hcl.from(Lab(0, 0, 0)), HasHclValues([double.nan, double.nan, 0, 1]));
    expect(Hcl.from(Lab(50, 0, 0)), HasHclValues([double.nan, 0, 50, 1]));
    expect(Hcl.from(Lab(100, 0, 0)),
        HasHclValues([double.nan, double.nan, 100, 1]));
    expect(Hcl.from(Lab(0, 10, 0)), HasHclValues([0, 10, 0, 1]));
    expect(Hcl.from(Lab(50, 10, 0)), HasHclValues([0, 10, 50, 1]));
    expect(Hcl.from(Lab(100, 10, 0)), HasHclValues([0, 10, 100, 1]));
    expect(Hcl.from(Lab(0, 0, 10)), HasHclValues([90, 10, 0, 1]));
    expect(Hcl.from(Lab(50, 0, 10)), HasHclValues([90, 10, 50, 1]));
    expect(Hcl.from(Lab(100, 0, 10)), HasHclValues([90, 10, 100, 1]));
  });

  test("Hcl.from(rgb) converts from RGB", () {
    expect(
        Hcl.from(Rgb(255, 0, 0, 0.4)),
        HasHclValues(
            [40.85261277607024, 106.83899941284552, 54.29173376861782, 0.4]));
  });

  test("Hcl.from(color) converts from another colorspace via rgb()", () {
    expect(
        Hcl.from(TestColor()),
        HasHclValues(
            [262.8292023352897, 17.30347233219686, 12.404844123471648, 0.4]));
  });

  test("hcl.brighter(k) returns a brighter color if k > 0", () {
    final c = Hcl.from("rgba(165, 42, 42, 0.4)");
    expect(
        c.brighter(0.5),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 47.149667346714935, 0.4]));
    expect(
        c.brighter(1),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 56.149667346714935, 0.4]));
    expect(
        c.brighter(2),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 74.14966734671493, 0.4]));
  });

  test("hcl.brighter(k) returns a copy", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1);
    expect(
        c1,
        HasHclValues(
            [255.71009124439382, 33.88100417355615, 51.98624890550498, 0.4]));
    expect(
        c2,
        HasHclValues(
            [255.71009124439382, 33.88100417355615, 69.98624890550498, 0.4]));
  });

  test("hcl.brighter() is equivalent to hcl.brighter(1)", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter();
    final c3 = c1.brighter(1);
    expect(c2, HasHclValues([c3.h, c3.c, c3.l, 0.4]));
  });

  test("hcl.brighter(k) is equivalent to hcl.darker(-k)", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1.5);
    final c3 = c1.darker(-1.5);
    expect(c2, HasHclValues([c3.h, c3.c, c3.l, 0.4]));
  });

  test("hcl.darker(k) returns a darker color if k > 0", () {
    final c = Hcl.from("rgba(165, 42, 42, 0.4)");
    expect(
        c.darker(0.5),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 29.149667346714935, 0.4]));
    expect(
        c.darker(1),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 20.149667346714935, 0.4]));
    expect(
        c.darker(2),
        HasHclValues(
            [32.28342524928155, 59.60231039142763, 2.149667346714935, 0.4]));
  });

  test("hcl.darker(k) returns a copy", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1);
    expect(
        c1,
        HasHclValues(
            [255.71009124439382, 33.88100417355615, 51.98624890550498, 0.4]));
    expect(
        c2,
        HasHclValues(
            [255.71009124439382, 33.88100417355615, 33.98624890550498, 0.4]));
  });

  test("hcl.darker() is equivalent to hcl.darker(1)", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker();
    final c3 = c1.darker(1);
    expect(c2, HasHclValues([c3.h, c3.c, c3.l, 0.4]));
  });

  test("hcl.darker(k) is equivalent to hcl.brighter(-k)", () {
    final c1 = Hcl.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1.5);
    final c3 = c1.brighter(-1.5);
    expect(c2, HasHclValues([c3.h, c3.c, c3.l, 0.4]));
  });

  test("hcl.rgb() converts to RGB", () {
    final c = Hcl(120, 30, 50, 0.4);
    expect(c.rgb(), HasApproxRgbValues([105, 126, 73, 0.4]));
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
