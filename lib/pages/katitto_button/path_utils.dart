import 'dart:ui';

class PathUtil {
  static Path createPath(
      double width, double height, double radius, double inclinationRate) {
    final xRadius = radius;
    final yRadius = radius * inclinationRate;

    final path = Path();
    // 点の定義
    final p0 = Offset(0, yRadius);

    final p1 = Offset(0, yRadius / 2);
    final p2 = Offset(xRadius / 2, 0);
    final p3 = Offset(xRadius, 0);

    final p4 = Offset(width - xRadius, 0);

    final p5 = Offset(width - xRadius / 2, 0);
    final p6 = Offset(width, yRadius / 2);
    final p7 = Offset(width, yRadius);

    final p8 = Offset(width, height - yRadius);

    final p9 = Offset(width, height - yRadius / 2);
    final p10 = Offset(width - radius / 2, height);
    final p11 = Offset(width - radius, height);

    final p12 = Offset(xRadius, height);

    final p13 = Offset(xRadius / 2, height);
    final p14 = Offset(0, height - yRadius / 2);
    final p15 = Offset(0, height - yRadius);

    // パスの定義
    path.moveTo(p0.dx, p0.dy);
    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);

    path.lineTo(p4.dx, p4.dy);
    path.cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy);

    path.lineTo(p8.dx, p8.dy);
    path.cubicTo(p9.dx, p9.dy, p10.dx, p10.dy, p11.dx, p11.dy);

    path.lineTo(p12.dx, p12.dy);
    path.cubicTo(p13.dx, p13.dy, p14.dx, p14.dy, p15.dx, p15.dy);
    path.close();

    return path;
  }

  static Path createSidePath(
      double width, double elevation, double radius, double inclinationRate) {
    final xRadius = radius;
    final yRadius = radius * inclinationRate;

    final path = Path();
    // 点の定義
    const p0 = Offset(0, 0);

    final p1 = Offset(0, yRadius / 2);
    final p2 = Offset(xRadius / 2, yRadius);
    final p3 = Offset(xRadius, yRadius);

    final p4 = Offset(width - xRadius, yRadius);

    final p5 = Offset(width - xRadius / 2, yRadius);
    final p6 = Offset(width, yRadius / 2);
    final p7 = Offset(width, 0);

    final p8 = Offset(width, elevation);

    final p9 = Offset(width, elevation + yRadius / 2);
    final p10 = Offset(width - radius / 2, elevation + yRadius);
    final p11 = Offset(width - radius, elevation + yRadius);

    final p12 = Offset(xRadius, elevation + yRadius);

    final p13 = Offset(xRadius / 2, elevation + yRadius);
    final p14 = Offset(0, elevation + yRadius / 2);
    final p15 = Offset(0, elevation);

    // パスの定義
    path.moveTo(p0.dx, p0.dy);
    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);

    path.lineTo(p4.dx, p4.dy);
    path.cubicTo(p5.dx, p5.dy, p6.dx, p6.dy, p7.dx, p7.dy);

    path.lineTo(p8.dx, p8.dy);
    path.cubicTo(p9.dx, p9.dy, p10.dx, p10.dy, p11.dx, p11.dy);

    path.lineTo(p12.dx, p12.dy);
    path.cubicTo(p13.dx, p13.dy, p14.dx, p14.dy, p15.dx, p15.dy);
    path.close();

    return path;
  }

  static Size getPathSize(Path path) {
    final rect = path.getBounds();
    return Size(rect.width, rect.height);
  }
}
