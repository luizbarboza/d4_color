/// Color spaces! RGB, HSL, Cubehelix, CIELAB, and more.
///
/// This package provides representations for various color spaces, allowing
/// specification, conversion and manipulation. (Also see
/// [d3_interpolate](https://pub.dev/packages/d4_interpolate) for color
/// interpolation.)
///
/// For example, take the color named “steelblue”:
///
/// ```dart
/// final c = Color.parse("steelblue"); // {r: 70, g: 130, b: 180, opacity: 1}
/// ```
///
/// Let’s try converting it to HSL:
///
/// ```dart
/// final c = Hsl.from("steelblue"); // {h: 207.27…, s: 0.44, l: 0.4902…, opacity: 1}
/// ```
///
/// Now rotate the hue by 90°, bump up the saturation, and format as a string for CSS:
///
/// ```dart
/// c.h += 90;
/// c.s += 0.2;
/// c.toString(); // rgb(198, 45, 205)
/// ```
///
/// To fade the color slightly:
///
/// ```dart
/// c.opacity = 0.8;
/// c.toString(); // rgba(198, 45, 205, 0.8)
/// ```
///
/// In addition to the ubiquitous and machine-friendly
/// [RGB](https://pub.dev/documentation/d4_color/latest/d4_color/Rgb-class.html)
/// and
/// [HSL](https://pub.dev/documentation/d4_color/latest/d4_color/Hsl-class.html)
/// color space, d4_color supports color spaces that are designed for humans:
///
/// * CIELAB (a.k.a. “Lab”)
/// * CIELChab (a.k.a. “LCh” or “HCL”)
/// * Dave Green’s Cubehelix
///
/// Cubehelix features monotonic lightness, while CIELAB and its polar form
/// CIELChab are perceptually uniform.
export 'src/d4_color.dart';
