import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Check onboarding3.svg contents and parsing', () async {
    final file = File('assets/images/onboarding3.svg');
    final svgString = await file.readAsString();
    expect(svgString.isNotEmpty, isTrue);

    // Parse with SvgStringLoader
    final loader = SvgStringLoader(svgString);
    final pictureInfo = await vg.loadPicture(loader, null);
    expect(pictureInfo.picture, isTrue);
  });
}
