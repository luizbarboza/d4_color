import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  test("Lab(…) returns an instance of lab and color", () {
    final c = Lab(120, 40, 50);
    expect(c, isA<Lab>());
    expect(c, isA<Color>());
  });

  test("Lab.from(…) exposes l, a and b channel values and opacity", () {
    expect(
        Lab.from("rgba(170, 187, 204, 0.4)"),
        HasLabValues(
            [74.96879980931759, -3.398998724348956, -10.696507207853333, 0.4]));
  });

  test("lab.toString() converts to RGB and formats as rgb(…) or rgba(…)", () {
    expect(Lab.from("#abcdef").toString(), "rgb(171, 205, 239)");
    expect(Lab.from("moccasin").toString(), "rgb(255, 228, 181)");
    expect(Lab.from("hsl(60, 100%, 20%)").toString(), "rgb(102, 102, 0)");
    expect(Lab.from("hsla(60, 100%, 20%, 0.4)").toString(),
        "rgba(102, 102, 0, 0.4)");
    expect(Lab.from("rgb(12, 34, 56)").toString(), "rgb(12, 34, 56)");
    expect(Lab.from(Rgb(12, 34, 56)).toString(), "rgb(12, 34, 56)");
    expect(Lab.from(Hsl(60, 1, 0.2)).toString(), "rgb(102, 102, 0)");
    expect(Lab.from(Hsl(60, 1, 0.2, 0.4)).toString(), "rgba(102, 102, 0, 0.4)");
  });

  test("lab.toString() reflects l, a and b channel values and opacity", () {
    final c = Lab.from("#abc");
    c.l += 10;
    c.a -= 10;
    c.b += 10;
    c.opacity = 0.4;
    expect(c.toString(), "rgba(184, 220, 213, 0.4)");
  });

  test("lab.toString() treats undefined channel values as 0", () {
    expect(Lab.from("invalid").toString(), "rgb(0, 0, 0)");
    expect(Lab(double.nan, 0, 0).toString(), "rgb(0, 0, 0)");
    expect(Lab(50, double.nan, 0).toString(), "rgb(119, 119, 119)");
    expect(Lab(50, 0, double.nan).toString(), "rgb(119, 119, 119)");
    expect(Lab(50, double.nan, double.nan).toString(), "rgb(119, 119, 119)");
  });

  test("lab.toString() treats undefined opacity as 1", () {
    final c = Lab.from("#abc");
    c.opacity = double.nan;
    expect(c.toString(), "rgb(170, 187, 204)");
  });

  test("Lab(l, a, b) does not clamp l channel value", () {
    expect(Lab(-10, 1, 2), HasLabValues([-10, 1, 2, 1]));
    expect(Lab(0, 1, 2), HasLabValues([0, 1, 2, 1]));
    expect(Lab(100, 1, 2), HasLabValues([100, 1, 2, 1]));
    expect(Lab(110, 1, 2), HasLabValues([110, 1, 2, 1]));
  });

  test("Lab(l, a, b, opacity) does not clamp opacity to [0,1]", () {
    expect(Lab(50, 10, 20, -0.2), HasLabValues([50, 10, 20, -0.2]));
    expect(Lab(50, 10, 20, 1.2), HasLabValues([50, 10, 20, 1.2]));
  });

  test("Lab.from(format) parses the specified format and converts to Lab", () {
    expect(
        Lab.from("#abcdef"),
        HasLabValues(
            [80.77135418262527, -5.957098328496224, -20.785782794739237, 1]));
    expect(
        Lab.from("#abc"),
        HasLabValues(
            [74.96879980931759, -3.398998724348956, -10.696507207853333, 1]));
    expect(
        Lab.from("rgb(12, 34, 56)"),
        HasLabValues(
            [12.404844123471648, -2.159950219712034, -17.168132391132946, 1]));
    expect(
        Lab.from("rgb(12%, 34%, 56%)"),
        HasLabValues(
            [35.48300043476593, -2.507637675606522, -36.95112983195855, 1]));
    expect(
        Lab.from("rgba(12%, 34%, 56%, 0.4)"),
        HasLabValues(
            [35.48300043476593, -2.507637675606522, -36.95112983195855, 0.4]));
    expect(
        Lab.from("hsl(60,100%,20%)"),
        HasLabValues(
            [41.97125732118659, -8.03835128380484, 47.65411917854332, 1]));
    expect(
        Lab.from("hsla(60,100%,20%,0.4)"),
        HasLabValues(
            [41.97125732118659, -8.03835128380484, 47.65411917854332, 0.4]));
    expect(
        Lab.from("aliceblue"),
        HasLabValues(
            [97.12294991108756, -1.773836604137824, -4.332680308569969, 1]));
  });

  test("Lab.from(format) returns undefined channel values for unknown formats",
      () {
    expect(Lab.from("invalid"),
        HasLabValues([double.nan, double.nan, double.nan, double.nan]));
  });

  test("Lab.from(lab) copies a Lab color", () {
    final c1 = Lab(50, 4, -5, 0.4);
    final c2 = Lab.from(c1);
    expect(c1, HasLabValues([50, 4, -5, 0.4]));
    c1.l = c1.a = c1.b = c1.opacity = 0;
    expect(c1, HasLabValues([0, 0, 0, 0]));
    expect(c2, HasLabValues([50, 4, -5, 0.4]));
  });

  test(
      "Lab.from(Hcl.from(lab)) doesn’t lose a and b channels if luminance is zero",
      () {
    expect(Lab.from(Hcl.from(Lab(0, 10, 0))), HasLabValues([0, 10, 0, 1]));
  });

  test("Lab.from(rgb) converts from RGB", () {
    expect(
        Lab.from(Rgb(255, 0, 0, 0.4)),
        HasLabValues(
            [54.29173376861782, 80.8124553179771, 69.88504032350531, 0.4]));
  });

  test("Lab.from(color) converts from another colorspace via rgb()", () {
    expect(
        Lab.from(TestColor()),
        HasLabValues([
          12.404844123471648,
          -2.159950219712034,
          -17.168132391132946,
          0.4
        ]));
  });

  test("lab.brighter(k) returns a brighter color if k > 0", () {
    final c = Lab.from("rgba(165, 42, 42, 0.4)");
    expect(
        c.brighter(0.5),
        HasLabValues(
            [47.149667346714935, 50.388769337115, 31.834059255569358, 0.4]));
    expect(
        c.brighter(1),
        HasLabValues(
            [56.149667346714935, 50.388769337115, 31.834059255569358, 0.4]));
    expect(
        c.brighter(2),
        HasLabValues(
            [74.14966734671493, 50.388769337115, 31.834059255569358, 0.4]));
  });

  test("lab.brighter(k) returns a copy", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1);
    expect(
        c1,
        HasLabValues(
            [51.98624890550498, -8.362792037014344, -32.832699449697685, 0.4]));
    expect(
        c2,
        HasLabValues(
            [69.98624890550498, -8.362792037014344, -32.832699449697685, 0.4]));
  });

  test("lab.brighter() is equivalent to lab.brighter(1)", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter();
    final c3 = c1.brighter(1);
    expect(c2, HasLabValues([c3.l, c3.a, c3.b, 0.4]));
  });

  test("lab.brighter(k) is equivalent to lab.darker(-k)", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.brighter(1.5);
    final c3 = c1.darker(-1.5);
    expect(c2, HasLabValues([c3.l, c3.a, c3.b, 0.4]));
  });

  test("lab.darker(k) returns a darker color if k > 0", () {
    final c = Lab.from("rgba(165, 42, 42, 0.4)");
    expect(
        c.darker(0.5),
        HasLabValues(
            [29.149667346714935, 50.388769337115, 31.834059255569358, 0.4]));
    expect(
        c.darker(1),
        HasLabValues(
            [20.149667346714935, 50.388769337115, 31.834059255569358, 0.4]));
    expect(
        c.darker(2),
        HasLabValues(
            [2.149667346714935, 50.388769337115, 31.834059255569358, 0.4]));
  });

  test("lab.darker(k) returns a copy", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1);
    expect(
        c1,
        HasLabValues(
            [51.98624890550498, -8.362792037014344, -32.832699449697685, 0.4]));
    expect(
        c2,
        HasLabValues(
            [33.98624890550498, -8.362792037014344, -32.832699449697685, 0.4]));
  });

  test("lab.darker() is equivalent to lab.darker(1)", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker();
    final c3 = c1.darker(1);
    expect(c2, HasLabValues([c3.l, c3.a, c3.b, 0.4]));
  });

  test("lab.darker(k) is equivalent to lab.brighter(-k)", () {
    final c1 = Lab.from("rgba(70, 130, 180, 0.4)");
    final c2 = c1.darker(1.5);
    final c3 = c1.brighter(-1.5);
    expect(c2, HasLabValues([c3.l, c3.a, c3.b, 0.4]));
  });

  test("lab.rgb() converts to RGB", () {
    final c = Lab(50, 4, -5, 0.4);
    expect(c.rgb(), HasApproxRgbValues([123, 117, 128, 0.4]));
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
