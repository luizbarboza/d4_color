import 'dart:math';

import 'color.dart';
import 'math.dart';

// https://observablehq.com/@mbostock/lab-and-rgb
const _k = 18,
    _xn = 0.96422,
    _yn = 1,
    _zn = 0.82521,
    _t0 = 4 / 29,
    _t1 = 6 / 29,
    _t2 = 3 * _t1 * _t1,
    _t3 = _t1 * _t1 * _t1;

/// A color representation in the
/// [CIELAB](https://en.wikipedia.org/wiki/Lab_color_space#CIELAB) color space.
///
/// The [Lab] class extends the [Color] class and represents a color in the
/// CIELAB (Lightness, Green-Red Hue, Blue-Yellow Hue) color space. The value of
/// [l] is typically in the range \[0, 100\], while [a] and [b] are typically in
/// \[-160, +160\].
class Lab extends Color {
  num l, a, b;

  /// Constructs a new CIELAB color.
  ///
  /// The channel values are exposed as [l], [a] and [b] properties on the
  /// returned instance.
  Lab(this.l, this.a, this.b, [super.opacity]);

  /// Constructs a new CIELAB color with the specified [l] value and [a] = [b] =
  /// 0.
  Lab.gray(this.l, [super.opacity])
      : a = 0,
        b = 0;

  /// Creates an instance of [Lab] color by converting the specified [source]
  /// object.
  ///
  /// If a CSS Color Module Level 3 [source] string is specified, it is parsed
  /// and then converted to the CIELAB color space. See [Color.parse] for
  /// examples. If a color instance is specified, it is converted to the RGB
  /// color space using [Color.rgb] and then converted to CIELAB. (Colors
  /// already in the CIELAB color space skip the conversion to RGB, and colors
  /// in the HCL color space are converted directly to CIELAB.)
  factory Lab.from(Object? source) {
    if (source is Lab) return source.copy();
    if (source is Hcl) return _hcl2lab(source);
    if (source is! Rgb) source = Rgb.from(source);
    num r = _rgb2lrgb(source.r),
        g = _rgb2lrgb(source.g),
        b = _rgb2lrgb(source.b),
        y = _xyz2lab((0.2225045 * r + 0.7168786 * g + 0.0606169 * b) / _yn),
        x,
        z;
    if (r == g && g == b) {
      x = z = y;
    } else {
      x = _xyz2lab((0.4360747 * r + 0.3850649 * g + 0.1430804 * b) / _xn);
      z = _xyz2lab((0.0139322 * r + 0.0971045 * g + 0.7141733 * b) / _zn);
    }
    return Lab(116 * y - 16, 500 * (x - y), 200 * (y - z), source.opacity);
  }

  @override
  Lab copy() => copyWith();

  /// Creates a new [Lab] color instance by copying the current instance and
  /// optionally updating its properties.
  ///
  /// The method returns a new [Lab] instance based on the current instance,
  /// with optional property updates. If any of the properties ([l], [a], [b],
  /// [opacity]) are provided, they will be used to create the new instance. If
  /// a property is not provided, the value from the current instance is used.
  ///
  /// Example:
  /// ```dart
  /// final originalColor = Lab(70, 15, -40, 1.0);
  /// final updatedColor = originalColor.copyWith(a: 38, opacity: 0.5);
  /// ```
  ///
  /// Returns a new [Lab] instance with the updated properties.
  Lab copyWith({num? l, num? a, num? b, num? opacity}) =>
      Lab(l ?? this.l, a ?? this.a, b ?? this.b, opacity ?? this.opacity);

  @override
  Lab brighter([num k = 1]) {
    return Lab(l + _k * k, a, b, opacity);
  }

  @override
  Lab darker([num k = 1]) {
    return Lab(l - _k * k, a, b, opacity);
  }

  @override
  Rgb rgb() {
    var y = (l + 16) / 116,
        x = a.isNaN ? y : y + a / 500,
        z = b.isNaN ? y : y - b / 200;
    x = _xn * _lab2xyz(x);
    y = _yn * _lab2xyz(y);
    z = _zn * _lab2xyz(z);
    return Rgb(
        _lrgb2rgb(3.1338561 * x - 1.6168667 * y - 0.4906146 * z),
        _lrgb2rgb(-0.9787684 * x + 1.9161415 * y + 0.0334540 * z),
        _lrgb2rgb(0.0719453 * x - 0.2289914 * y + 1.4052427 * z),
        opacity);
  }
}

num _xyz2lab(double t) {
  return t > _t3 ? pow(t, 1 / 3) : t / _t2 + _t0;
}

double _lab2xyz(double t) {
  return t > _t1 ? t * t * t : _t2 * (t - _t0);
}

double _lrgb2rgb(double x) {
  return 255 * (x <= 0.0031308 ? 12.92 * x : 1.055 * pow(x, 1 / 2.4) - 0.055);
}

num _rgb2lrgb(num x) {
  return (x /= 255) <= 0.04045 ? x / 12.92 : pow((x + 0.055) / 1.055, 2.4);
}

/// A color representation in the
/// [CIELChab](https://en.wikipedia.org/wiki/CIELAB_color_space#Cylindrical_representation:_CIELCh_or_CIEHLC)
/// color space.
///
/// The [Lab] class extends the [Color] class and represents a color in the
/// CIELAB (Hue, Chroma, Lightness) color space. The value of [l] is typically
/// in the range \[0, 100\], [c] is typically in \[0, 230\], and [h] is
/// typically in \[0, 360).
class Hcl extends Color {
  num h, c, l;

  Hcl(this.h, this.c, this.l, [super.opacity]);

  /// Creates an instance of [Hcl] color by converting the specified [source]
  /// object.
  ///
  /// If a CSS Color Module Level 3 [source] string is specified, it is parsed
  /// and then converted to CIELChab color space. See [Color.parse] for
  /// examples. If a color instance is specified, it is converted to the RGB
  /// color space using [Color.rgb] and then converted to CIELChab. (Colors
  /// already in CIELChab color space skip the conversion to RGB, and colors in
  /// CIELAB color space are converted directly to CIELChab.)
  factory Hcl.from(Object? source) {
    if (source is Hcl) return source.copy();
    if (source is! Lab) source = Lab.from(source);
    if (source.a == 0 && source.b == 0) {
      return Hcl(double.nan, 0 < source.l && source.l < 100 ? 0 : double.nan,
          source.l, source.opacity);
    }
    var h = atan2(source.b, source.a) * degrees;
    return Hcl(
        h < 0 ? h + 360 : h,
        sqrt(source.a * source.a + source.b * source.b),
        source.l,
        source.opacity);
  }

  @override
  Hcl copy() => copyWith();

  /// Creates a new [Hcl] color instance by copying the current instance and
  /// optionally updating its properties.
  ///
  /// The method returns a new [Hcl] instance based on the current instance,
  /// with optional property updates. If any of the properties ([h], [c], [l],
  /// [opacity]) are provided, they will be used to create the new instance. If
  /// a property is not provided, the value from the current instance is used.
  ///
  /// Example:
  /// ```dart
  /// final originalColor = Hcl(220, 70, 60, 1.0);
  /// final updatedColor = originalColor.copyWith(c: 94, opacity: 0.5);
  /// ```
  ///
  /// Returns a new [Hcl] instance with the updated properties.
  Hcl copyWith({num? h, num? c, num? l, num? opacity}) =>
      Hcl(h ?? this.h, c ?? this.c, l ?? this.l, opacity ?? this.opacity);

  @override
  Hcl brighter([num k = 1]) {
    return Hcl(h, c, l + _k * k, opacity);
  }

  @override
  Hcl darker([num k = 1]) {
    return Hcl(h, c, l - _k * k, opacity);
  }

  @override
  Rgb rgb() {
    return _hcl2lab(this).rgb();
  }
}

Lab _hcl2lab(Hcl o) {
  if (o.h.isNaN) return Lab(o.l, 0, 0, o.opacity);
  var h = o.h * radians;
  return Lab(o.l, cos(h) * o.c, sin(h) * o.c, o.opacity);
}
