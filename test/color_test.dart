import 'package:d4_color/d4_color.dart';
import 'package:test/test.dart';

import 'matchers.dart';

void main() {
  test(
      "Color.tryParse(format) parses CSS color names (e.g., \"rebeccapurple\")",
      () {
    expect(Color.tryParse("moccasin"), HasApproxRgbValues([255, 228, 181, 1]));
    expect(Color.tryParse("aliceblue"), HasApproxRgbValues([240, 248, 255, 1]));
    expect(Color.tryParse("yellow"), HasApproxRgbValues([255, 255, 0, 1]));
    expect(Color.tryParse("moccasin"), HasApproxRgbValues([255, 228, 181, 1]));
    expect(Color.tryParse("aliceblue"), HasApproxRgbValues([240, 248, 255, 1]));
    expect(Color.tryParse("yellow"), HasApproxRgbValues([255, 255, 0, 1]));
    expect(
        Color.tryParse("rebeccapurple"), HasApproxRgbValues([102, 51, 153, 1]));
    expect(Color.tryParse("transparent"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, 0]));
  });

  test("Color.tryParse(format) parses 6-digit hexadecimal (e.g., \"#abcdef\")",
      () {
    expect(Color.tryParse("#abcdef"), HasApproxRgbValues([171, 205, 239, 1]));
  });

  test("Color.tryParse(format) parses 3-digit hexadecimal (e.g., \"#abc\")",
      () {
    expect(Color.tryParse("#abc"), HasApproxRgbValues([170, 187, 204, 1]));
  });

  test(
      "Color.tryParse(format) does not parse 7-digit hexadecimal (e.g., \"#abcdef3\")",
      () {
    expect(Color.tryParse("#abcdef3"), isNull);
  });

  test(
      "Color.tryParse(format) parses 8-digit hexadecimal (e.g., \"#abcdef33\")",
      () {
    expect(
        Color.tryParse("#abcdef33"), HasApproxRgbValues([171, 205, 239, 0.2]));
  });

  test("Color.tryParse(format) parses 4-digit hexadecimal (e.g., \"#abc3\")",
      () {
    expect(Color.tryParse("#abc3"), HasApproxRgbValues([170, 187, 204, 0.2]));
  });

  test(
      "Color.tryParse(format) parses RGB integer format (e.g., \"rgb(12,34,56)\")",
      () {
    expect(
        Color.tryParse("rgb(12,34,56)"), HasApproxRgbValues([12, 34, 56, 1]));
  });

  test(
      "Color.tryParse(format) parses RGBA integer format (e.g., \"rgba(12,34,56,0.4)\")",
      () {
    expect(Color.tryParse("rgba(12,34,56,0.4)"),
        HasApproxRgbValues([12, 34, 56, 0.4]));
  });

  test(
      "Color.tryParse(format) parses RGB percentage format (e.g., \"rgb(12%,34%,56%)\")",
      () {
    expect(Color.tryParse("rgb(12%,34%,56%)"),
        HasApproxRgbValues([31, 87, 143, 1]));
    expect(Color.tryParse("rgb(100%,100%,100%)"),
        HasRgbValues([255, 255, 255, 1]));
  });

  test(
      "Color.tryParse(format) parses RGBA percentage format (e.g., \"rgba(12%,34%,56%,0.4)\")",
      () {
    expect(Color.tryParse("rgba(12%,34%,56%,0.4)"),
        HasApproxRgbValues([31, 87, 143, 0.4]));
    expect(Color.tryParse("rgba(100%,100%,100%,0.4)"),
        HasRgbValues([255, 255, 255, 0.4]));
  });

  test("Color.tryParse(format) parses HSL format (e.g., \"hsl(60,100%,20%)\")",
      () {
    expect(Color.tryParse("hsl(60,100%,20%)"), HasHslValues([60, 1, 0.2, 1]));
  });

  test(
      "Color.tryParse(format) parses HSLA format (e.g., \"hsla(60,100%,20%,0.4)\")",
      () {
    expect(Color.tryParse("hsla(60,100%,20%,0.4)"),
        HasHslValues([60, 1, 0.2, 0.4]));
  });

  test("Color.tryParse(format) ignores leading and trailing whitespace", () {
    expect(Color.tryParse(" aliceblue\t\n"),
        HasApproxRgbValues([240, 248, 255, 1]));
    expect(Color.tryParse(" #abc\t\n"), HasApproxRgbValues([170, 187, 204, 1]));
    expect(
        Color.tryParse(" #aabbcc\t\n"), HasApproxRgbValues([170, 187, 204, 1]));
    expect(Color.tryParse(" rgb(120,30,50)\t\n"),
        HasApproxRgbValues([120, 30, 50, 1]));
    expect(Color.tryParse(" hsl(120,30%,50%)\t\n"),
        HasHslValues([120, 0.3, 0.5, 1]));
  });

  test("Color.tryParse(format) ignores whitespace between numbers", () {
    expect(Color.tryParse(" rgb( 120 , 30 , 50 ) "),
        HasApproxRgbValues([120, 30, 50, 1]));
    expect(Color.tryParse(" hsl( 120 , 30% , 50% ) "),
        HasHslValues([120, 0.3, 0.5, 1]));
    expect(Color.tryParse(" rgba( 12 , 34 , 56 , 0.4 ) "),
        HasApproxRgbValues([12, 34, 56, 0.4]));
    expect(Color.tryParse(" rgba( 12% , 34% , 56% , 0.4 ) "),
        HasApproxRgbValues([31, 87, 143, 0.4]));
    expect(Color.tryParse(" hsla( 60 , 100% , 20% , 0.4 ) "),
        HasHslValues([60, 1, 0.2, 0.4]));
  });

  test("Color.tryParse(format) allows number signs", () {
    expect(Color.tryParse("rgb(+120,+30,+50)"),
        HasApproxRgbValues([120, 30, 50, 1]));
    expect(Color.tryParse("hsl(+120,+30%,+50%)"),
        HasHslValues([120, 0.3, 0.5, 1]));
    expect(Color.tryParse("rgb(-120,-30,-50)"),
        HasApproxRgbValues([-120, -30, -50, 1]));
    expect(Color.tryParse("hsl(-120,-30%,-50%)"),
        HasHslValues([double.nan, double.nan, -0.5, 1]));
    expect(Color.tryParse("rgba(12,34,56,+0.4)"),
        HasApproxRgbValues([12, 34, 56, 0.4]));
    expect(Color.tryParse("rgba(12,34,56,-0.4)"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, -0.4]));
    expect(Color.tryParse("rgba(12%,34%,56%,+0.4)"),
        HasApproxRgbValues([31, 87, 143, 0.4]));
    expect(Color.tryParse("rgba(12%,34%,56%,-0.4)"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, -0.4]));
    expect(Color.tryParse("hsla(60,100%,20%,+0.4)"),
        HasHslValues([60, 1, 0.2, 0.4]));
    expect(Color.tryParse("hsla(60,100%,20%,-0.4)"),
        HasHslValues([double.nan, double.nan, double.nan, -0.4]));
  });

  test("Color.tryParse(format) allows decimals for non-integer values", () {
    expect(Color.tryParse("rgb(20.0%,30.4%,51.2%)"),
        HasApproxRgbValues([51, 78, 131, 1]));
    expect(Color.tryParse("hsl(20.0,30.4%,51.2%)"),
        HasHslValues([20, 0.304, 0.512, 1]));
  });

  test(
      "Color.tryParse(format) allows leading decimal for hue, opacity and percentages",
      () {
    expect(Color.tryParse("hsl(.9,.3%,.5%)"),
        HasHslValues([0.9, 0.003, 0.005, 1]));
    expect(Color.tryParse("hsla(.9,.3%,.5%,.5)"),
        HasHslValues([0.9, 0.003, 0.005, 0.5]));
    expect(
        Color.tryParse("rgb(.1%,.2%,.3%)"), HasApproxRgbValues([0, 1, 1, 1]));
    expect(Color.tryParse("rgba(120,30,50,.5)"),
        HasApproxRgbValues([120, 30, 50, 0.5]));
  });

  test(
      "Color.tryParse(format) allows exponential format for hue, opacity and percentages",
      () {
    expect(
        Color.tryParse("hsl(1e1,2e1%,3e1%)"), HasHslValues([10, 0.2, 0.3, 1]));
    expect(Color.tryParse("hsla(9e-1,3e-1%,5e-1%,5e-1)"),
        HasHslValues([0.9, 0.003, 0.005, 0.5]));
    expect(Color.tryParse("rgb(1e-1%,2e-1%,3e-1%)"),
        HasApproxRgbValues([0, 1, 1, 1]));
    expect(Color.tryParse("rgba(120,30,50,1e-1)"),
        HasApproxRgbValues([120, 30, 50, 0.1]));
  });

  test("Color.tryParse(format) does not allow decimals for integer values", () {
    expect(Color.tryParse("rgb(120.5,30,50)"), isNull);
  });

  test("Color.tryParse(format) does not allow empty decimals", () {
    expect(Color.tryParse("rgb(120.,30,50)"), isNull);
    expect(Color.tryParse("rgb(120.%,30%,50%)"), isNull);
    expect(Color.tryParse("rgba(120,30,50,1.)"), isNull);
    expect(Color.tryParse("rgba(12%,30%,50%,1.)"), isNull);
    expect(Color.tryParse("hsla(60,100%,20%,1.)"), isNull);
  });

  test("Color.tryParse(format) does not allow made-up names", () {
    expect(Color.tryParse("bostock"), isNull);
  });

  test("Color.tryParse(format) allows achromatic colors", () {
    expect(Color.tryParse("rgba(0,0,0,0)"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, 0]));
    expect(Color.tryParse("#0000"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, 0]));
    expect(Color.tryParse("#00000000"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, 0]));
  });

  test(
      "Color.tryParse(format) does not allow whitespace before open paren or percent sign",
      () {
    expect(Color.tryParse("rgb (120,30,50)"), isNull);
    expect(Color.tryParse("rgb (12%,30%,50%)"), isNull);
    expect(Color.tryParse("hsl (120,30%,50%)"), isNull);
    expect(Color.tryParse("hsl(120,30 %,50%)"), isNull);
    expect(Color.tryParse("rgba (120,30,50,1)"), isNull);
    expect(Color.tryParse("rgba (12%,30%,50%,1)"), isNull);
    expect(Color.tryParse("hsla (120,30%,50%,1)"), isNull);
  });

  test("Color.tryParse(format) is case-insensitive", () {
    expect(Color.tryParse("aLiCeBlUE"), HasApproxRgbValues([240, 248, 255, 1]));
    expect(Color.tryParse("transPARENT"),
        HasApproxRgbValues([double.nan, double.nan, double.nan, 0]));
    expect(Color.tryParse(" #aBc\t\n"), HasApproxRgbValues([170, 187, 204, 1]));
    expect(
        Color.tryParse(" #aaBBCC\t\n"), HasApproxRgbValues([170, 187, 204, 1]));
    expect(Color.tryParse(" rGB(120,30,50)\t\n"),
        HasApproxRgbValues([120, 30, 50, 1]));
    expect(Color.tryParse(" HSl(120,30%,50%)\t\n"),
        HasHslValues([120, 0.3, 0.5, 1]));
  });

  test(
      "Color.tryParse(format) returns undefined RGB channel values for unknown formats",
      () {
    expect(Color.tryParse("invalid"), isNull);
    expect(Color.tryParse("hasOwnProperty"), isNull);
    expect(Color.tryParse("__proto__"), isNull);
    expect(Color.tryParse("#ab"), isNull);
  });

  test("Color.tryParse(format).hex() returns a hexadecimal string", () {
    expect(Color.tryParse("rgba(12%,34%,56%,0.4)")!.formatHex(), "#1f578f");
  });
}
