import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Check onboarding3.svg contents and parsing', () async {
    final File file = File('assets/images/onboarding3.svg');
    final String svgString = await file.readAsString();
    expect(svgString.isNotEmpty, isTrue);

    // Parse with SvgStringLoader
    final SvgStringLoader loader = SvgStringLoader(svgString);
    final PictureInfo pictureInfo = await vg.loadPicture(loader, null);
    expect(pictureInfo.picture, isTrue);
  });
}
