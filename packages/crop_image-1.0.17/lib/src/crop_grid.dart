import 'dart:ui';

import 'package:flutter/material.dart';
import 'crop_rect.dart';

/// Crop Grid with invisible border, for better touch detection.
class CropGrid extends StatelessWidget {
  final Rect crop;
  final Color gridColor;
  final Color gridInnerColor;
  final Color gridCornerColor;
  final double paddingSize;
  final double cornerSize;
  final double cornerOffset;
  final bool showCorners;
  final double thinWidth;
  final double thickWidth;
  final Color scrimColor;
  final bool alwaysShowThirdLines;
  final bool isMoving;
  final ValueChanged<Size> onSize;

  const CropGrid({super.key, required this.crop, required this.gridColor, required this.gridInnerColor, required this.gridCornerColor, required this.paddingSize, required this.cornerSize, required this.cornerOffset, required this.thinWidth, required this.thickWidth, required this.scrimColor, required this.showCorners, required this.alwaysShowThirdLines, required this.isMoving, required this.onSize});

  @override
  Widget build(BuildContext context) => RepaintBoundary(child: CustomPaint(foregroundPainter: _CropGridPainter(this)));
}

class _CropGridPainter extends CustomPainter {
  final CropGrid grid;

  _CropGridPainter(this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final Size imageSize = Size(size.width - 2 * grid.paddingSize, size.height - 2 * grid.paddingSize);
    final Rect full = Offset(grid.paddingSize, grid.paddingSize) & imageSize;
    final Rect bounds = grid.crop.multiply(imageSize).translate(grid.paddingSize, grid.paddingSize);
    grid.onSize(imageSize);

    final Offset upperLeftCorner = bounds.topLeft.translate(-grid.cornerOffset, -grid.cornerOffset);
    final Offset upperRightCorner = bounds.topRight.translate(grid.cornerOffset, -grid.cornerOffset);
    final Offset lowerRightCorner = bounds.bottomRight.translate(grid.cornerOffset, grid.cornerOffset);
    final Offset lowerLeftCorner = bounds.bottomLeft.translate(-grid.cornerOffset, grid.cornerOffset);

    canvas.save();
    canvas.clipRect(bounds, clipOp: ClipOp.difference);
    canvas.drawRect(
      full,
      Paint() //
        ..color = grid.scrimColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
    canvas.restore();

    canvas.drawRect(
      bounds,
      Paint()
        ..color = grid.gridColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = grid.thinWidth
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.miter
        ..isAntiAlias = true,
    );

    if (grid.isMoving || grid.alwaysShowThirdLines) {
      final halfHeight = bounds.height / 2.0;
      final halfWidth = bounds.width / 2.0;
      final offset = grid.thinWidth / 2;
      canvas.drawPath(
        Path() //
          ..addPolygon([bounds.topLeft.translate(offset, halfHeight), bounds.topRight.translate(-offset, halfHeight)], false)
          ..addPolygon([bounds.topLeft.translate(halfWidth, offset), bounds.bottomLeft.translate(halfWidth, -offset)], false),
        Paint()
          ..color = grid.gridInnerColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = grid.thinWidth
          ..strokeCap = StrokeCap.butt
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true,
      );
    }

    if (grid.showCorners) {
      final double cornerDotRadius = grid.thickWidth / 1.2;
      final Paint cornerDotPaint = Paint()
        ..color = grid.gridCornerColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas
        ..drawCircle(upperLeftCorner, cornerDotRadius, cornerDotPaint)
        ..drawCircle(upperRightCorner, cornerDotRadius, cornerDotPaint)
        ..drawCircle(lowerLeftCorner, cornerDotRadius, cornerDotPaint)
        ..drawCircle(lowerRightCorner, cornerDotRadius, cornerDotPaint);
    }
  }

  @override
  bool shouldRepaint(_CropGridPainter oldDelegate) =>
      oldDelegate.grid.crop != grid.crop || //
      oldDelegate.grid.isMoving != grid.isMoving ||
      oldDelegate.grid.cornerSize != grid.cornerSize ||
      oldDelegate.grid.cornerOffset != grid.cornerOffset ||
      oldDelegate.grid.showCorners != grid.showCorners ||
      oldDelegate.grid.gridColor != grid.gridColor ||
      oldDelegate.grid.gridCornerColor != grid.gridCornerColor ||
      oldDelegate.grid.thickWidth != grid.thickWidth ||
      oldDelegate.grid.gridInnerColor != grid.gridInnerColor;

  @override
  bool hitTest(Offset position) => true;
}
