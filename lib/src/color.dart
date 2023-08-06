import 'dart:math' as math;

const _darker = 0.7, _brighter = 1 / _darker;

final _reI = r'\s*([+-]?\d+)\s*',
    _reN = r'\s*([+-]?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?)\s*',
    _reP = r'\s*([+-]?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?)%\s*',
    _reHex = RegExp(r'^#([0-9a-f]{3,8})$'),
    _reRgbInteger = RegExp('^rgb\\($_reI,$_reI,$_reI\\)\$'),
    _reRgbPercent = RegExp('^rgb\\($_reP,$_reP,$_reP\\)\$'),
    _reRgbaInteger = RegExp('^rgba\\($_reI,$_reI,$_reI,$_reN\\)\$'),
    _reRgbaPercent = RegExp('^rgba\\($_reP,$_reP,$_reP,$_reN\\)\$'),
    _reHslPercent = RegExp('^hsl\\($_reN,$_reP,$_reP\\)\$'),
    _reHslaPercent = RegExp('^hsla\\($_reN,$_reP,$_reP,$_reN\\)\$');

const Map<String, int> _named = {
  'aliceblue': 0xf0f8ff,
  'antiquewhite': 0xfaebd7,
  'aqua': 0x00ffff,
  'aquamarine': 0x7fffd4,
  'azure': 0xf0ffff,
  'beige': 0xf5f5dc,
  'bisque': 0xffe4c4,
  'black': 0x000000,
  'blanchedalmond': 0xffebcd,
  'blue': 0x0000ff,
  'blueviolet': 0x8a2be2,
  'brown': 0xa52a2a,
  'burlywood': 0xdeb887,
  'cadetblue': 0x5f9ea0,
  'chartreuse': 0x7fff00,
  'chocolate': 0xd2691e,
  'coral': 0xff7f50,
  'cornflowerblue': 0x6495ed,
  'cornsilk': 0xfff8dc,
  'crimson': 0xdc143c,
  'cyan': 0x00ffff,
  'darkblue': 0x00008b,
  'darkcyan': 0x008b8b,
  'darkgoldenrod': 0xb8860b,
  'darkgray': 0xa9a9a9,
  'darkgreen': 0x006400,
  'darkgrey': 0xa9a9a9,
  'darkkhaki': 0xbdb76b,
  'darkmagenta': 0x8b008b,
  'darkolivegreen': 0x556b2f,
  'darkorange': 0xff8c00,
  'darkorchid': 0x9932cc,
  'darkred': 0x8b0000,
  'darksalmon': 0xe9967a,
  'darkseagreen': 0x8fbc8f,
  'darkslateblue': 0x483d8b,
  'darkslategray': 0x2f4f4f,
  'darkslategrey': 0x2f4f4f,
  'darkturquoise': 0x00ced1,
  'darkviolet': 0x9400d3,
  'deeppink': 0xff1493,
  'deepskyblue': 0x00bfff,
  'dimgray': 0x696969,
  'dimgrey': 0x696969,
  'dodgerblue': 0x1e90ff,
  'firebrick': 0xb22222,
  'floralwhite': 0xfffaf0,
  'forestgreen': 0x228b22,
  'fuchsia': 0xff00ff,
  'gainsboro': 0xdcdcdc,
  'ghostwhite': 0xf8f8ff,
  'gold': 0xffd700,
  'goldenrod': 0xdaa520,
  'gray': 0x808080,
  'green': 0x008000,
  'greenyellow': 0xadff2f,
  'grey': 0x808080,
  'honeydew': 0xf0fff0,
  'hotpink': 0xff69b4,
  'indianred': 0xcd5c5c,
  'indigo': 0x4b0082,
  'ivory': 0xfffff0,
  'khaki': 0xf0e68c,
  'lavender': 0xe6e6fa,
  'lavenderblush': 0xfff0f5,
  'lawngreen': 0x7cfc00,
  'lemonchiffon': 0xfffacd,
  'lightblue': 0xadd8e6,
  'lightcoral': 0xf08080,
  'lightcyan': 0xe0ffff,
  'lightgoldenrodyellow': 0xfafad2,
  'lightgray': 0xd3d3d3,
  'lightgreen': 0x90ee90,
  'lightgrey': 0xd3d3d3,
  'lightpink': 0xffb6c1,
  'lightsalmon': 0xffa07a,
  'lightseagreen': 0x20b2aa,
  'lightskyblue': 0x87cefa,
  'lightslategray': 0x778899,
  'lightslategrey': 0x778899,
  'lightsteelblue': 0xb0c4de,
  'lightyellow': 0xffffe0,
  'lime': 0x00ff00,
  'limegreen': 0x32cd32,
  'linen': 0xfaf0e6,
  'magenta': 0xff00ff,
  'maroon': 0x800000,
  'mediumaquamarine': 0x66cdaa,
  'mediumblue': 0x0000cd,
  'mediumorchid': 0xba55d3,
  'mediumpurple': 0x9370db,
  'mediumseagreen': 0x3cb371,
  'mediumslateblue': 0x7b68ee,
  'mediumspringgreen': 0x00fa9a,
  'mediumturquoise': 0x48d1cc,
  'mediumvioletred': 0xc71585,
  'midnightblue': 0x191970,
  'mintcream': 0xf5fffa,
  'mistyrose': 0xffe4e1,
  'moccasin': 0xffe4b5,
  'navajowhite': 0xffdead,
  'navy': 0x000080,
  'oldlace': 0xfdf5e6,
  'olive': 0x808000,
  'olivedrab': 0x6b8e23,
  'orange': 0xffa500,
  'orangered': 0xff4500,
  'orchid': 0xda70d6,
  'palegoldenrod': 0xeee8aa,
  'palegreen': 0x98fb98,
  'paleturquoise': 0xafeeee,
  'palevioletred': 0xdb7093,
  'papayawhip': 0xffefd5,
  'peachpuff': 0xffdab9,
  'peru': 0xcd853f,
  'pink': 0xffc0cb,
  'plum': 0xdda0dd,
  'powderblue': 0xb0e0e6,
  'purple': 0x800080,
  'rebeccapurple': 0x663399,
  'red': 0xff0000,
  'rosybrown': 0xbc8f8f,
  'royalblue': 0x4169e1,
  'saddlebrown': 0x8b4513,
  'salmon': 0xfa8072,
  'sandybrown': 0xf4a460,
  'seagreen': 0x2e8b57,
  'seashell': 0xfff5ee,
  'sienna': 0xa0522d,
  'silver': 0xc0c0c0,
  'skyblue': 0x87ceeb,
  'slateblue': 0x6a5acd,
  'slategray': 0x708090,
  'slategrey': 0x708090,
  'snow': 0xfffafa,
  'springgreen': 0x00ff7f,
  'steelblue': 0x4682b4,
  'tan': 0xd2b48c,
  'teal': 0x008080,
  'thistle': 0xd8bfd8,
  'tomato': 0xff6347,
  'turquoise': 0x40e0d0,
  'violet': 0xee82ee,
  'wheat': 0xf5deb3,
  'white': 0xffffff,
  'whitesmoke': 0xf5f5f5,
  'yellow': 0xffff00,
  'yellowgreen': 0x9acd32
};

/// An abstract class representing a color in various color spaces.
///
/// This class provides a base for different color space implementations, such
/// as RGB, HSL, and more. Colors can be used to represent and manipulate colors
/// in different color models and can be used for various purposes, including UI
/// design, graphics, and data visualization.
abstract class Color {
  /// This color’s opacity, typically in the range \[0, 1\].
  num opacity;

  Color([this.opacity = 1]);

  /// Returns a copy of this color.
  ///
  /// For example, to derive a copy of a *color* with [opacity] 0.5, say
  ///
  /// ```dart
  /// color.copy(opacity: 0.5);
  /// ```
  Color copy();

  /// Returns a brighter copy of this color.
  ///
  /// If [k] is specified, it controls how much brighter the returned color
  /// should be. If [k] is not specified, it defaults to 1. The behavior of this
  /// method is dependent on the implementing color space.
  Color brighter([num k]);

  /// Returns a darker copy of this color.
  ///
  /// If [k] is specified, it controls how much darker the returned color should
  /// be. If [k] is not specified, it defaults to 1. The behavior of this method
  /// is dependent on the implementing color space.
  Color darker([num k]);

  /// Returns the RGB equivalent of this color.
  ///
  /// For RGB colors, that’s `this`.
  Rgb rgb();

  /// Returns true if and only if the color is displayable on standard hardware.
  ///
  /// For example, this returns false for an RGB color if any channel value is
  /// less than zero or greater than 255 when rounded, or if the opacity is not
  /// in the range \[0, 1\].
  bool displayable() => rgb().displayable();

  /// Returns a hexadecimal string representing this color in RGB space, such as
  /// `#f7eaba`.
  ///
  /// If this color is not displayable, a suitable displayable color is returned
  /// instead. For example, RGB channel values greater than 255 are clamped to
  /// 255.
  String formatHex() => rgb().formatHex();

  /// Returns a hexadecimal string representing this color in RGBA space, such
  /// as `#f7eaba90`.
  ///
  /// If this color is not displayable, a suitable displayable color is returned
  /// instead. For example, RGB channel values greater than 255 are clamped to
  /// 255.
  String formatHex8() => rgb().formatHex8();

  /// Returns a string representing this color according to the CSS Color Module
  /// Level 3 specification, such as `hsl(257, 50%, 80%)` or
  /// `hsla(257, 50%, 80%, 0.2)`.
  ///
  /// If this color is not displayable, a suitable displayable color is returned
  /// instead by clamping S and L channel values to the interval \[0, 100\].
  String formatHsl() => Hsl.from(this).formatHsl();

  /// Returns a string representing this color according to the CSS Object Model
  /// specification, such as `rgb(247, 234, 186)` or `rgba(247, 234, 186, 0.2)`.
  ///
  /// If this color is not displayable, a suitable displayable color is returned
  /// instead by clamping RGB channel values to the interval \[0, 255\].
  String formatRgb() => rgb().formatRgb();

  /// An alias for [formatRgb].
  @override
  String toString() => rgb().formatRgb();

  /// Parses the specified CSS Color Module Level 3 [specifier] string,
  /// returning an RGB or HSL color, along with CSS Color Module Level 4 hex
  /// [specifier] strings.
  ///
  /// The method first tries to read the input as [Color]. If that fails, it
  /// throws a [FormatException].
  ///
  /// Rather than throwing and immediately catching the [FormatException],
  /// instead use [tryParse] to handle a potential parsing error.
  ///
  /// Some examples:
  ///
  /// * `rgb(255, 255, 255)`
  /// * `rgb(10%, 20%, 30%)`
  /// * `rgba(255, 255, 255, 0.4)`
  /// * `rgba(10%, 20%, 30%, 0.4)`
  /// * `hsl(120, 50%, 20%)`
  /// * `hsla(120, 50%, 20%, 0.4)`
  /// * `#ffeeaa`
  /// * `#fea`
  /// * `#ffeeaa22`
  /// * `#fea2`
  /// * `steelblue`
  ///
  /// The list of supported
  /// [named colors](http://www.w3.org/TR/SVG/types.html#ColorKeywords) is
  /// specified by CSS.
  static Color parse(String specifier) {
    Color? result = tryParse(specifier);
    if (result != null) return result;
    throw FormatException(specifier);
  }

  /// Like [parse], except that this function returns null for invalid inputs
  /// instead of throwing.
  static Color? tryParse(String specifier) {
    Match? m;
    int k, l;

    Color? color;

    specifier = specifier.trim().toLowerCase();
    if ((m = _reHex.firstMatch(specifier)) != null) {
      l = m![1]!.length;
      k = int.parse(m[1]!, radix: 16);

      if (l == 6) {
        color = _rgbn(k); // #ff0000
      } else if (l == 3) {
        color = Rgb(
          (k >> 8 & 0xf) | (k >> 4 & 0xf0),
          (k >> 4 & 0xf) | (k & 0xf0),
          ((k & 0xf) << 4) | (k & 0xf),
          1,
        ); // #f00
      } else if (l == 8) {
        color = _rgba(
          k >> 24 & 0xff,
          k >> 16 & 0xff,
          k >> 8 & 0xff,
          (k & 0xff) / 0xff,
        ); // #ff000000
      } else if (l == 4) {
        color = _rgba(
          (k >> 12 & 0xf) | (k >> 8 & 0xf0),
          (k >> 8 & 0xf) | (k >> 4 & 0xf0),
          (k >> 4 & 0xf) | (k & 0xf0),
          (((k & 0xf) << 4) | (k & 0xf)) / 0xff,
        ); // #f000
      }
    } else if ((m = _reRgbInteger.firstMatch(specifier)) != null) {
      color = Rgb(
        int.parse(m![1]!),
        int.parse(m[2]!),
        int.parse(m[3]!),
        1,
      ); // rgb(255, 0, 0)
    } else if ((m = _reRgbPercent.firstMatch(specifier)) != null) {
      color = Rgb(
        num.parse(m![1]!) * 255 / 100,
        num.parse(m[2]!) * 255 / 100,
        num.parse(m[3]!) * 255 / 100,
        1,
      ); // rgb(100%, 0%, 0%)
    } else if ((m = _reRgbaInteger.firstMatch(specifier)) != null) {
      color = _rgba(
        int.parse(m![1]!),
        int.parse(m[2]!),
        int.parse(m[3]!),
        num.parse(m[4]!),
      ); // rgba(255, 0, 0, 1)
    } else if ((m = _reRgbaPercent.firstMatch(specifier)) != null) {
      color = _rgba(
        num.parse(m![1]!) * 255 / 100,
        num.parse(m[2]!) * 255 / 100,
        num.parse(m[3]!) * 255 / 100,
        num.parse(m[4]!),
      ); // rgb(100%, 0%, 0%, 1)
    } else if ((m = _reHslPercent.firstMatch(specifier)) != null) {
      color = _hsla(
        num.parse(m![1]!),
        num.parse(m[2]!) / 100,
        num.parse(m[3]!) / 100,
        1,
      ); // hsl(120, 50%, 50%)
    } else if ((m = _reHslaPercent.firstMatch(specifier)) != null) {
      color = _hsla(
        num.parse(m![1]!),
        num.parse(m[2]!) / 100,
        num.parse(m[3]!) / 100,
        num.parse(m[4]!),
      ); // hsla(120, 50%, 50%, 1)
    } else if (_named.containsKey(specifier)) {
      color = _rgbn(_named[specifier]!);
    } else if (specifier == "transparent") {
      color = Rgb(double.nan, double.nan, double.nan, 0);
    }

    return color;
  }
}

Rgb _rgbn(int n) {
  return Rgb(n >> 16 & 0xff, n >> 8 & 0xff, n & 0xff, 1);
}

Rgb _rgba(num r, num g, num b, num a) {
  if (a <= 0) r = g = b = double.nan;
  return Rgb(r, g, b, a);
}

/// A color representation in the
/// [RGB](https://en.wikipedia.org/wiki/RGB_color_model) color space.
///
/// The [Rgb] class extends the [Color] class and represents a color in the
/// RGB (Red, Green, Blue) color space.
class Rgb extends Color {
  num r, g, b;

  /// Constructs a new RGB color.
  ///
  /// The channel values are exposed as [r], [g] and [b] properties on the
  /// returned instance.
  Rgb(this.r, this.g, this.b, [super.opacity]);

  /// Creates an instance of [Rgb] color by converting the specified [source]
  /// object.
  ///
  /// If a CSS Color Module Level 3 [source] string is specified, it is parsed
  /// and then converted to the RGB color space. See [Color.parse] for examples.
  /// If a color instance is specified, it is converted to the RGB color space
  /// using [Color.rgb]. Note that unlike [Color.rgb] this method always returns
  /// a new instance, even if color is already an RGB color.
  factory Rgb.from(Object? source) {
    if (source is String) source = Color.tryParse(source);
    if (source is! Color) {
      return Rgb(double.nan, double.nan, double.nan, double.nan);
    }
    return source.rgb().copy();
  }

  @override
  Rgb copy({num? opacity}) => copyWith(opacity: opacity);

  /// Creates a new [Rgb] color instance by copying the current instance and
  /// optionally updating its properties.
  ///
  /// The method returns a new [Rgb] instance based on the current instance,
  /// with optional property updates. If any of the properties ([r], [g], [b],
  /// [opacity]) are provided, they will be used to create the new instance. If
  /// a property is not provided, the value from the current instance is used.
  ///
  /// Example:
  /// ```dart
  /// final originalColor = Rgb(255, 0, 0, 1.0);
  /// final updatedColor = originalColor.copyWith(g: 128, opacity: 0.5);
  /// ```
  ///
  /// Returns a new [Rgb] instance with the updated properties.
  Rgb copyWith({num? r, num? g, num? b, num? opacity}) =>
      Rgb(r ?? this.r, g ?? this.g, b ?? this.b, opacity ?? this.opacity);

  @override
  Rgb brighter([num k = 1]) {
    k = math.pow(_brighter, k);
    return Rgb(r * k, g * k, b * k, opacity);
  }

  @override
  Rgb darker([num k = 1]) {
    k = math.pow(_darker, k);
    return Rgb(r * k, g * k, b * k, opacity);
  }

  @override
  Rgb rgb() {
    return this;
  }

  /// Returns a new RGB color where the [r], [g], and [b] channels are clamped
  /// to the range \[0, 255\] and rounded to the nearest integer value, and the
  /// opacity is clamped to the range \[0, 1\].
  Rgb clamp() {
    return Rgb(_clampi(r), _clampi(g), _clampi(b), _clampa(opacity));
  }

  @override
  bool displayable() {
    return (-0.5 <= r && r < 255.5) &&
        (-0.5 <= g && g < 255.5) &&
        (-0.5 <= b && b < 255.5) &&
        (0 <= opacity && opacity <= 1);
  }

  @override
  String formatHex() {
    return '#${_hex(r)}${_hex(g)}${_hex(b)}';
  }

  @override
  String formatHex8() {
    return '#${_hex(r)}${_hex(g)}${_hex(b)}${_hex((opacity.isNaN ? 1 : opacity) * 255)}';
  }

  @override
  String formatRgb() {
    final a = _clampa(opacity);
    return '${a == 1 ? "rgb(" : "rgba("}${_clampi(r)}, ${_clampi(g)}, ${_clampi(b)}${a == 1 ? ")" : ', $a)'}';
  }
}

num _clampa(num opacity) {
  return opacity.isNaN ? 1 : math.max(0, math.min(1, opacity));
}

int _clampi(num value) {
  return value.isNaN ? 0 : math.max(0, math.min(255, value.round()));
}

String _hex(num value) {
  value = _clampi(value);
  return (value < 16 ? "0" : "") + (value as int).toRadixString(16);
}

Hsl _hsla(num h, num s, num l, num a) {
  if (a <= 0) {
    h = s = l = double.nan;
  } else if (l <= 0 || l >= 1) {
    h = s = double.nan;
  } else if (s <= 0) {
    h = double.nan;
  }
  return Hsl(h, s, l, a);
}

/// A color representation in the
/// [HSL](https://en.wikipedia.org/wiki/HSL_and_HSV) color space.
///
/// The [Hsl] class extends the [Color] class and represents a color in the
/// HSL (Hue, Saturation, Lightness) color space.
class Hsl extends Color {
  late num h, s, l;

  /// Constructs a new HSL color.
  ///
  /// The channel values are exposed as [h], [s] and [l] properties on the
  /// returned instance.
  Hsl(this.h, this.s, this.l, [super.opacity]);

  /// Creates an instance of [Hsl] color by converting the specified [source]
  /// object.
  ///
  /// If a CSS Color Module Level 3 [source] string is specified, it is parsed
  /// and then converted to the HSL color space. See [Color.parse] for examples.
  /// If a color instance is specified, it is converted to the RGB color space
  /// using [Color.rgb] and then converted to HSL. (Colors already in the HSL
  /// color space skip the conversion to RGB.)
  factory Hsl.from(Object? source) {
    if (source is String) source = Color.tryParse(source);
    if (source is! Color) {
      return Hsl(double.nan, double.nan, double.nan, double.nan);
    }
    if (source is Hsl) return source.copy();
    var rgb = source.rgb();
    var r = rgb.r / 255,
        g = rgb.g / 255,
        b = rgb.b / 255,
        min = math.min(r, math.min(g, b)),
        max = math.max(r, math.max(g, b)),
        h = double.nan,
        s = max - min,
        l = (max + min) / 2;
    if (s != 0) {
      if (r == max) {
        h = (g - b) / s + (g < b ? 1 : 0) * 6;
      } else if (g == max) {
        h = (b - r) / s + 2;
      } else {
        h = (r - g) / s + 4;
      }
      s /= l < 0.5 ? max + min : 2 - max - min;
      h *= 60;
    } else {
      s = l > 0 && l < 1 ? 0 : h;
    }
    return Hsl(h, s, l, rgb.opacity);
  }

  @override
  Hsl copy() => copyWith();

  /// Creates a new [Hsl] color instance by copying the current instance and
  /// optionally updating its properties.
  ///
  /// The method returns a new [Hsl] instance based on the current instance,
  /// with optional property updates. If any of the properties ([h], [s], [l],
  /// [opacity]) are provided, they will be used to create the new instance. If
  /// a property is not provided, the value from the current instance is used.
  ///
  /// Example:
  /// ```dart
  /// final originalColor = Hsl(180, 0.5, 0.7, 1.0);
  /// final updatedColor = originalColor.copyWith(s: 0.2, opacity: 0.5);
  /// ```
  ///
  /// Returns a new [Hsl] instance with the updated properties.
  Hsl copyWith({num? h, num? s, num? l, num? opacity}) =>
      Hsl(h ?? this.h, s ?? this.s, l ?? this.l, opacity ?? this.opacity);

  @override
  Hsl brighter([num k = 1]) {
    k = math.pow(_brighter, k);
    return Hsl(h, s, l * k, opacity);
  }

  @override
  Hsl darker([num k = 1]) {
    k = math.pow(_darker, k);
    return Hsl(h, s, l * k, opacity);
  }

  @override
  Rgb rgb() {
    var h = this.h % 360,
        s = h.isNaN || this.s.isNaN ? 0 : this.s,
        l = this.l,
        m2 = l + (l < 0.5 ? l : 1 - l) * s,
        m1 = 2 * l - m2;
    return Rgb(
        _hsl2rgb(h >= 240 ? h - 240 : h + 120, m1, m2),
        _hsl2rgb(h, m1, m2),
        _hsl2rgb(h < 120 ? h + 240 : h - 120, m1, m2),
        opacity);
  }

  /// Returns a new HSL color where the [h] channel is clamped to the range \[0,
  /// 360), and the [s], [l], and [opacity] channels are clamped to the range
  /// \[0, 1\].
  Hsl clamp() {
    return Hsl(_clamph(h), _clampt(s), _clampt(l), _clampa(opacity));
  }

  @override
  bool displayable() {
    return (0 <= s && s <= 1 || s.isNaN) &&
        (0 <= l && l <= 1) &&
        (0 <= opacity && opacity <= 1);
  }

  @override
  String formatHsl() {
    final a = _clampa(opacity);
    return '${a == 1 ? "hsl(" : "hsla("}${_clamph(h)}, ${_clampt(s) * 100}%, ${_clampt(l) * 100}%${a == 1 ? ")" : ', $a)'}';
  }
}

num _clamph(num value) {
  return (value.isNaN ? 0 : value) % 360;
}

num _clampt(num value) {
  return math.max(0, math.min(1, value.isNaN ? 0 : value));
}

/* From FvD 13.37, CSS Color Module Level 3 */
num _hsl2rgb(num h, num m1, num m2) {
  return (h < 60
          ? m1 + (m2 - m1) * h / 60
          : h < 180
              ? m2
              : h < 240
                  ? m1 + (m2 - m1) * (240 - h) / 60
                  : m1) *
      255;
}
