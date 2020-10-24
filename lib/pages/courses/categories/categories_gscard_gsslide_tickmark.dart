import 'package:flutter/material.dart';

class GSTickMark extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const GSTickMark({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double tickMarkRadius;

  @override
  Size getPreferredSize({
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    assert(sliderTheme != null);
    assert(sliderTheme.trackHeight != null);
    assert(isEnabled != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight / 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isEnabled = false,
  }) {
    assert(context != null);
    assert(center != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    assert(isEnabled != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    Color begin;
    Color end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
        end = isTickMarkRightOfThumb ? sliderTheme.inactiveTickMarkColor.withOpacity(.5) : sliderTheme.inactiveTickMarkColor.withOpacity(.5);
        break;
      case TextDirection.rtl:
        final bool isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
        end = isTickMarkLeftOfThumb ? sliderTheme.inactiveTickMarkColor.withOpacity(.5) : sliderTheme.inactiveTickMarkColor.withOpacity(.5);
        break;
    }
    final Paint paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation);

    // The tick marks are tiny circles that are the same height as the track.
    final double tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        2;
    if (tickMarkRadius > 0) {
      context.canvas.drawRect(Rect.fromCenter(center: center, width: tickMarkRadius, height: 10), paint);
    }
  }
}
