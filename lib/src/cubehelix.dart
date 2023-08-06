import 'dart:math';

import 'color.dart';
import 'math.dart';

const _darker = 0.7, _brighter = 1 / _darker;

const _a = -0.14861,
    _b = 1.78277,
    _c = -0.29227,
    _d = -0.90649,
    _e = 1.97294,
    _ed = _e * _d,
    _eb = _e * _b,
    _bcda = _b * _c - _d * _a;

/// A color representation in the
/// [Cubehelix](http://www.mrao.cam.ac.uk/~dag/CUBEHELIX/) color space.
///
/// The [Cubehelix] class extends the [Color] class and represents a color in
/// the Cubehelix (Hue, Saturation, Lightness) color space.
class Cubehelix extends Color {
  num h, s, l;

  /// Constructs a new CIELAB color.
  ///
  /// The channel values are exposed as [h], [s] and [l] properties on the
  /// returned instance.
  Cubehelix(this.h, this.s, this.l, [super.opacity]);

  /// Creates an instance of [Cubehelix] color by converting the specified
  /// [source] object.
  ///
  /// If a CSS Color Module Level 3 specifier string is specified, it is parsed
  /// and then converted to the Cubehelix color space. See [Color.parse] for
  /// examples. If a color instance is specified, it is converted to the RGB
  /// color space using [Color.rgb] and then converted to Cubehelix. (Colors
  /// already in the Cubehelix color space skip the conversion to RGB.)
  factory Cubehelix.from(Object? source) {
    if (source is Cubehelix) return source.copy();
    if (source is! Rgb) source = Rgb.from(source);
    var r = source.r / 255,
        g = source.g / 255,
        b = source.b / 255,
        l = (_bcda * b + _ed * r - _eb * g) / (_bcda + _ed - _eb),
        bl = b - l,
        k = (_e * (g - l) - _c * bl) / _d,
        s = sqrt(k * k + bl * bl) / (_e * l * (1 - l)), // NaN if l=0 or l=1
        h = !s.isNaN ? atan2(k, bl) * degrees - 120 : double.nan;
    return Cubehelix(h < 0 ? h + 360 : h, s, l, source.opacity);
  }

  @override
  Cubehelix copy() => copyWith();

  /// Creates a new [Cubehelix] color instance by copying the current instance
  /// and optionally updating its properties.
  ///
  /// The method returns a new [Cubehelix] instance based on the current
  /// instance, with optional property updates. If any of the properties ([h],
  /// [s], [l], [opacity]) are provided, they will be used to create the new
  /// instance. If a property is not provided, the value from the current
  /// instance is used.
  ///
  /// Example:
  /// ```dart
  /// final originalColor = Cubehelix(200, 1, 0.5, 1.0);
  /// final updatedColor = originalColor.copyWith(s: 0.7, opacity: 0.5);
  /// ```
  ///
  /// Returns a new [Cubehelix] instance with the updated properties.
  Cubehelix copyWith({num? h, num? c, num? l, num? opacity}) =>
      Cubehelix(h ?? this.h, c ?? s, l ?? this.l, opacity ?? this.opacity);

  @override
  Cubehelix brighter([num k = 1]) {
    k = pow(_brighter, k);
    return Cubehelix(h, s, l * k, opacity);
  }

  @override
  Cubehelix darker([num k = 1]) {
    k = pow(_darker, k);
    return Cubehelix(h, s, l * k, opacity);
  }

  @override
  Rgb rgb() {
    var h = this.h.isNaN ? 0 : (this.h + 120) * radians,
        a = s.isNaN ? 0 : s * l * (1 - l),
        cosh = cos(h),
        sinh = sin(h);
    return Rgb(
        255 * (l + a * (_a * cosh + _b * sinh)),
        255 * (l + a * (_c * cosh + _d * sinh)),
        255 * (l + a * (_e * cosh)),
        opacity);
  }
}
