class ImagesResponse {
  ImagesResponse({
      this.error, 
      this.imageCount, 
      this.imageTiffPath, 
      this.imagePngPath, 
      this.content,
      this.pdfPath,});

  ImagesResponse.fromJson(dynamic json) {
    error = json['error'];
    imageCount = json['image_count'];
    imageTiffPath = json['image_tiff_path'];
    imagePngPath = json['image_png_path'];
    content = json['content'] != null ? json['content'].cast<String>() : [];
    pdfPath = json['pdf_path'];
  }
  String? error;
  int? imageCount;
  String? imageTiffPath;
  String? imagePngPath;
  List<String>? content;

  String? pdfPath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['image_count'] = imageCount;
    map['image_tiff_path'] = imageTiffPath;
    map['image_png_path'] = imagePngPath;
    map['content'] = content;
    map['pdf_path'] = pdfPath;
    return map;
  }

}