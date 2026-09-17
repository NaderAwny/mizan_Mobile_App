enum MediaType {
  image,
  video,
  classification,
  category;

  /// يحوّل الـ String القادم من الـ API لـ enum
  static MediaType fromString(String? value) {
    // Debug: اطبع القيمة الجاية من الـ API
    // ignore: avoid_print
    print('🎯 mediaType from API: "$value"');

    switch (value?.toUpperCase().trim()) {
      case 'IMAGE':
        return MediaType.image;

      case 'VIDEO':
      case 'VIDEOS':
      case 'LIVE':
        return MediaType.video;

      case 'IMAGE_CLASSIFICATION':
      case 'CLASSIFICATION':
        return MediaType.classification;

      case 'CATEGORY':
        return MediaType.category;

      default:
        return MediaType.image;
    }
  }
}
