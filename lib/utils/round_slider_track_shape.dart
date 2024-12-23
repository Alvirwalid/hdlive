import 'dart:math';
import 'package:flutter/material.dart';

class RoundSliderTrackShape extends SliderTrackShape {
  /// Create a slider track that draws 2 rectangles.
  const RoundSliderTrackShape({ this.disabledThumbGapWidth = 2.0 });

  /// Horizontal spacing, or gap, between the disabled thumb and the track.
  ///
  /// This is only used when the slider is disabled. There is no gap around
  /// the thumb and any part of the track when the slider is enabled. The
  /// Material spec defaults this gap width 2, which is half of the disabled
  /// thumb radius.
  final double disabledThumbGapWidth;

  @override
  Rect getPreferredRect({
    RenderBox? parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double overlayWidth = sliderTheme!.overlayShape!.getPreferredSize(isEnabled!, isDiscrete!).width;
    final double? trackHeight = sliderTheme.trackHeight;
    assert(overlayWidth >= 0);
    assert(trackHeight! >= 0);
    assert(parentBox!.size.width >= overlayWidth);
    assert(parentBox!.size.height >= trackHeight!);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop = offset.dy + (parentBox!.size.height - trackHeight!) / 2;
    // TODO(clocksmith): Although this works for a material, perhaps the default
    // rectangular track should be padded not just by the overlay, but by the
    // max of the thumb and the overlay, in case there is no overlay.
    final double trackWidth = parentBox.size.width - overlayWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset, {required RenderBox parentBox, required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter, Offset? secondaryOffset, bool? isEnabled, bool? isDiscrete, required TextDirection textDirection}) {
    // If the slider track height is 0, then it makes no difference whether the
    // track is painted or not, therefore the painting can be a no-op.
    if (sliderTheme!.trackHeight == 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final ColorTween activeTrackColorTween = ColorTween(begin: sliderTheme.disabledActiveTrackColor , end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(begin: sliderTheme.disabledInactiveTrackColor , end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation!)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    Paint? leftTrackPaint;
    Paint? rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    // Used to create a gap around the thumb iff the slider is disabled.
    // If the slider is enabled, the track can be drawn beneath the thumb
    // without a gap. But when the slider is disabled, the track is shortened
    // and this gap helps determine how much shorter it should be.
    // TODO(clocksmith): The new Material spec has a gray circle in place of this gap.
    double horizontalAdjustment = 0.0;
    if (!isEnabled!) {
      final double disabledThumbRadius = sliderTheme.thumbShape!.getPreferredSize(false, isDiscrete!).width / 2.0;
      final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
      horizontalAdjustment = disabledThumbRadius + gap;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter!.dx - horizontalAdjustment, trackRect.bottom);

    // Left Arc
    context.canvas.drawArc(
        Rect.fromCircle(center: Offset(trackRect.left, trackRect.top + 11.0), radius: 11.0),
        -pi * 3 / 2, // -270 degrees
        pi, // 180 degrees
        false,
        trackRect!.left - thumbCenter!.dx == 0.0 ? rightTrackPaint! : leftTrackPaint!
    );

    // Right Arc
    context.canvas.drawArc(
        Rect.fromCircle(center: Offset(trackRect.right, trackRect.top + 11.0), radius: 11.0),
        -pi / 2, // -90 degrees
        pi, // 180 degrees
        false,
        trackRect!.right - thumbCenter!.dx == 0.0 ? leftTrackPaint! : rightTrackPaint!
    );

    context.canvas.drawRect(leftTrackSegment, leftTrackPaint!);
    final Rect rightTrackSegment = Rect.fromLTRB(thumbCenter.dx + horizontalAdjustment, trackRect.top, trackRect.right, trackRect.bottom);
    context.canvas.drawRect(rightTrackSegment, rightTrackPaint!);


  }


  // @override
  // void paint(
  //     PaintingContext context,
  //     Offset offset, {
  //       RenderBox? parentBox,
  //       SliderThemeData? sliderTheme,
  //       Animation<double>? enableAnimation,
  //       TextDirection? textDirection,
  //       Offset? thumbCenter,
  //       bool? isDiscrete,
  //       bool? isEnabled,
  //     }) {
  //   // If the slider track height is 0, then it makes no difference whether the
  //   // track is painted or not, therefore the painting can be a no-op.
  //   if (sliderTheme!.trackHeight == 0) {
  //     return;
  //   }
  //
  //   // Assign the track segment paints, which are left: active, right: inactive,
  //   // but reversed for right to left text.
  //   final ColorTween activeTrackColorTween = ColorTween(begin: sliderTheme.disabledActiveTrackColor , end: sliderTheme.activeTrackColor);
  //   final ColorTween inactiveTrackColorTween = ColorTween(begin: sliderTheme.disabledInactiveTrackColor , end: sliderTheme.inactiveTrackColor);
  //   final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation!)!;
  //   final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
  //   Paint? leftTrackPaint;
  //   Paint? rightTrackPaint;
  //   switch (textDirection) {
  //     case TextDirection.ltr:
  //       leftTrackPaint = activePaint;
  //       rightTrackPaint = inactivePaint;
  //       break;
  //     case TextDirection.rtl:
  //       leftTrackPaint = inactivePaint;
  //       rightTrackPaint = activePaint;
  //       break;
  //   }
  //
  //   // Used to create a gap around the thumb iff the slider is disabled.
  //   // If the slider is enabled, the track can be drawn beneath the thumb
  //   // without a gap. But when the slider is disabled, the track is shortened
  //   // and this gap helps determine how much shorter it should be.
  //   // TODO(clocksmith): The new Material spec has a gray circle in place of this gap.
  //   double horizontalAdjustment = 0.0;
  //   if (!isEnabled!) {
  //     final double disabledThumbRadius = sliderTheme.thumbShape!.getPreferredSize(false, isDiscrete!).width / 2.0;
  //     final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
  //     horizontalAdjustment = disabledThumbRadius + gap;
  //   }
  //
  //   final Rect trackRect = getPreferredRect(
  //     parentBox: parentBox,
  //     offset: offset,
  //     sliderTheme: sliderTheme,
  //     isEnabled: isEnabled,
  //     isDiscrete: isDiscrete,
  //   );
  //   final Rect leftTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter!.dx - horizontalAdjustment, trackRect.bottom);
  //
  //   // Left Arc
  //   context.canvas.drawArc(
  //       Rect.fromCircle(center: Offset(trackRect.left, trackRect.top + 11.0), radius: 11.0),
  //       -pi * 3 / 2, // -270 degrees
  //       pi, // 180 degrees
  //       false,
  //       trackRect!.left - thumbCenter!.dx == 0.0 ? rightTrackPaint! : leftTrackPaint!
  //   );
  //
  //   // Right Arc
  //   context.canvas.drawArc(
  //       Rect.fromCircle(center: Offset(trackRect.right, trackRect.top + 11.0), radius: 11.0),
  //       -pi / 2, // -90 degrees
  //       pi, // 180 degrees
  //       false,
  //       trackRect!.right - thumbCenter!.dx == 0.0 ? leftTrackPaint! : rightTrackPaint!
  //   );
  //
  //   context.canvas.drawRect(leftTrackSegment, leftTrackPaint!);
  //   final Rect rightTrackSegment = Rect.fromLTRB(thumbCenter.dx + horizontalAdjustment, trackRect.top, trackRect.right, trackRect.bottom);
  //   context.canvas.drawRect(rightTrackSegment, rightTrackPaint!);
  //
  // }
}
