// // To parse this JSON data, do
//
//     final booksWp = booksWpFromMap(jsonString);

import 'dart:convert';

List<BooksWp> booksWpFromMap(String str) =>
    List<BooksWp>.from(json.decode(str).map((x) => BooksWp.fromMap(x)));

String booksWpToMap(List<BooksWp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BooksWp {
  BooksWp({
    this.id,
    this.downloadFile,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.featuredMedia,
    this.template,
    this.grade,
    this.bookauthor,
    this.chapters,
    this.thumbnailId,
    this.externalLinks,
    this.pdf,
    this.links,
    this.embedded,
    this.isFileOpen,
  });

  int? id;
  bool? isFileOpen;
  String? downloadFile;
  DateTime? date;
  DateTime? dateGmt;
  Guid? guid;
  DateTime? modified;
  DateTime? modifiedGmt;
  String? slug;
  String? status;
  String? type;
  String? link;
  Guid? title;
  Content? content;
  int? featuredMedia;
  String? template;
  String? grade;
  String? bookauthor;
  List<Chapter>? chapters;
  String? thumbnailId;
  String? externalLinks;
  String? pdf;
  BooksWpLinks? links;
  Embedded? embedded;

  factory BooksWp.fromMap(Map<String, dynamic> json) => BooksWp(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dateGmt:
            json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
        guid: json["guid"] == null ? null : Guid.fromMap(json["guid"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
        modifiedGmt: json["modified_gmt"] == null
            ? null
            : DateTime.parse(json["modified_gmt"]),
        slug: json["slug"],
        status: json["status"],
        type: json["type"],
        link: json["link"],
        title: json["title"] == null ? null : Guid.fromMap(json["title"]),
        content:
            json["content"] == null ? null : Content.fromMap(json["content"]),
        featuredMedia:
            json["featured_media"],
        template: json["template"],
        // grade: json["grade"],
        bookauthor: json["bookauthor"],
        chapters: json["chapters"] == null
            ? null
            : List<Chapter>.from(json["chapters"]
            .map((x) => Chapter.fromMap(x))) ,
        thumbnailId:
            json["_thumbnail_id"],
      // externalLinks: json['pdf'] is bool?(
      // json["external_links"] is List?
      // json["external_links"][0]:
      //   json["external_links"] is String?json["external_links"]:
      //   'https://api.ustozim.uz/wp-content/uploads/2022/09/Geografiya-10-sinf-1.pdf')
      //     :json['pdf']['guid']??json["external_links"][0].toString(),
        externalLinks:
        json["external_links"] is List?
        json["external_links"][0]:
        json["external_links"] is String?json["external_links"]:
      json['pdf'] is Object?json['pdf']['guid']:'https://api.ustozim.uz/wp-content/uploads/2022/09/Geografiya-10-sinf-1.pdf',
        // pdf: json["pdf"],
        links: json["_links"] == null
            ? null
            : BooksWpLinks.fromMap(json["_links"]),
        embedded: json["_embedded"] == null
            ? null
            : Embedded.fromMap(json["_embedded"]),
    isFileOpen: json['isFileOpen'],
    downloadFile: json['downloadFile']
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date == null ? null : date!.toIso8601String(),
        "date_gmt": dateGmt == null ? null : dateGmt!.toIso8601String(),
        "guid": guid == null ? null : guid!.toMap(),
        "modified": modified == null ? null : modified!.toIso8601String(),
        "modified_gmt":
            modifiedGmt == null ? null : modifiedGmt!.toIso8601String(),
        "slug": slug,
        "status": status,
        "type": type,
        "link": link,
        "title": title == null ? null : title!.toMap(),
        "content": content == null ? null : content!.toMap(),
        "featured_media": featuredMedia,
        "template": template,
        "grade": grade,
        "bookauthor": bookauthor,
  'chapters' : this.chapters!.map((v) => v.toMap()).toList(),
        "_thumbnail_id": thumbnailId,
        "external_links": externalLinks,
        // "pdf": pdf,
        "_links": links == null ? null : links!.toMap(),
        "_embedded": embedded == null ? null : embedded!.toMap(),
    "downloadFile":downloadFile,
    "isFileOpen":isFileOpen
      };
}
class Chapter{
  Chapter({
    this.id,
    this.chatperTitle,
    this.chapterPage,
  });

  String? id;
  String? chatperTitle;
  String? chapterPage;

  factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    chatperTitle: json["chaptertitle"],
      chapterPage: json['chapterpage']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "chaptertitle": chatperTitle,
    "chapterpage": chapterPage,
  };
}

class Content {
  Content({
    this.rendered,
    this.protected,
  });

  String? rendered;
  bool? protected;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
        rendered: json["rendered"],
        protected: json["protected"],
      );

  Map<String, dynamic> toMap() => {
        "rendered": rendered,
        "protected": protected,
      };
}

class Embedded {
  Embedded({
    this.wpFeaturedmedia,
    this.wpTerm,
  });

  List<WpFeaturedmedia>? wpFeaturedmedia;
  List<List<EmbeddedWpTerm>>? wpTerm;

  factory Embedded.fromMap(Map<String, dynamic> json) => Embedded(
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<WpFeaturedmedia>.from(json["wp:featuredmedia"]
                .map((x) => WpFeaturedmedia.fromMap(x))),
        wpTerm: json["wp:term"] == null
            ? null
            : List<List<EmbeddedWpTerm>>.from(json["wp:term"].map((x) =>
                List<EmbeddedWpTerm>.from(
                    x.map((x) => EmbeddedWpTerm.fromMap(x))))),
      );

  Map<String, dynamic> toMap() => {
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia!.map((x) => x.toMap())),
        "wp:term": wpTerm == null
            ? null
            : List<dynamic>.from(
                wpTerm!.map((x) => List<dynamic>.from(x.map((x) => x.toMap())))),
      };
}

class WpFeaturedmedia {
  WpFeaturedmedia({
    this.id,
    this.date,
    this.slug,
    this.type,
    this.link,
    this.title,
    this.author,
    this.wpAttachedFile,
    this.wpAttachmentMetadata,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.sourceUrl,
    this.links,
  });

  int? id;
  DateTime? date;
  String? slug;
  String? type;
  String? link;
  Guid? title;
  int? author;
  String? wpAttachedFile;
  WpAttachmentMetadata? wpAttachmentMetadata;
  Guid? caption;
  String? altText;
  String? mediaType;
  String? mimeType;
  MediaDetails? mediaDetails;
  String? sourceUrl;
  WpFeaturedmediaLinks? links;

  factory WpFeaturedmedia.fromMap(Map<String, dynamic> json) => WpFeaturedmedia(
        id: json["id"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        slug: json["slug"],
        type: json["type"],
        link: json["link"],
        title: json["title"] == null ? null : Guid.fromMap(json["title"]),
        author: json["author"],
        wpAttachedFile: json["_wp_attached_file"],
        wpAttachmentMetadata: json["_wp_attachment_metadata"] == null
            ? null
            : WpAttachmentMetadata.fromMap(json["_wp_attachment_metadata"]),
        caption: json["caption"] == null ? null : Guid.fromMap(json["caption"]),
        altText: json["alt_text"],
        mediaType: json["media_type"],
        mimeType: json["mime_type"],
        mediaDetails: json["media_details"] == null
            ? null
            : MediaDetails.fromMap(json["media_details"]),
        sourceUrl: json["source_url"],
        links: json["_links"] == null
            ? null
            : WpFeaturedmediaLinks.fromMap(json["_links"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "date": date == null ? null : date!.toIso8601String(),
        "slug": slug,
        "type": type,
        "link": link,
        "title": title == null ? null : title!.toMap(),
        "author": author,
        "_wp_attached_file": wpAttachedFile,
        "_wp_attachment_metadata":
            wpAttachmentMetadata == null ? null : wpAttachmentMetadata!.toMap(),
        "caption": caption == null ? null : caption!.toMap(),
        "alt_text": altText,
        "media_type": mediaType,
        "mime_type": mimeType,
        "media_details": mediaDetails == null ? null : mediaDetails!.toMap(),
        "source_url": sourceUrl,
        "_links": links == null ? null : links!.toMap(),
      };
}

class Guid {
  Guid({
    this.rendered,
  });

  String? rendered;

  factory Guid.fromMap(Map<String, dynamic> json) => Guid(
        rendered: json["rendered"],
      );

  Map<String, dynamic> toMap() => {
        "rendered": rendered,
      };
}

class WpFeaturedmediaLinks {
  WpFeaturedmediaLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
  });

  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<AuthorElement>? author;
  List<AuthorElement>? replies;

  factory WpFeaturedmediaLinks.fromMap(Map<String, dynamic> json) =>
      WpFeaturedmediaLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromMap(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(json["collection"].map((x) => About.fromMap(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromMap(x))),
        author: json["author"] == null
            ? null
            : List<AuthorElement>.from(
                json["author"].map((x) => AuthorElement.fromMap(x))),
        replies: json["replies"] == null
            ? null
            : List<AuthorElement>.from(
                json["replies"].map((x) => AuthorElement.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toMap())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toMap())),
        "about": about == null
            ? null
            : List<dynamic>.from(about!.map((x) => x.toMap())),
        "author": author == null
            ? null
            : List<dynamic>.from(author!.map((x) => x.toMap())),
        "replies": replies == null
            ? null
            : List<dynamic>.from(replies!.map((x) => x.toMap())),
      };
}

class About {
  About({
    this.href,
  });

  String? href;

  factory About.fromMap(Map<String, dynamic> json) => About(
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "href": href,
      };
}

class AuthorElement {
  AuthorElement({
    this.embeddable,
    this.href,
  });

  bool? embeddable;
  String? href;

  factory AuthorElement.fromMap(Map<String, dynamic> json) => AuthorElement(
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "embeddable": embeddable,
        "href": href,
      };
}

class MediaDetails {
  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.filesize,
    this.sizes,
    this.imageMeta,
  });

  int? width;
  int? height;
  String? file;
  int? filesize;
  MediaDetailsSizes? sizes;
  ImageMeta? imageMeta;

  factory MediaDetails.fromMap(Map<String, dynamic> json) => MediaDetails(
        width: json["width"],
        height: json["height"],
        file: json["file"],
        filesize: json["filesize"],
        sizes: json["sizes"] == null
            ? null
            : MediaDetailsSizes.fromMap(json["sizes"]),
        imageMeta: json["image_meta"] == null
            ? null
            : ImageMeta.fromMap(json["image_meta"]),
      );

  Map<String, dynamic> toMap() => {
        "width": width,
        "height": height,
        "file": file,
        "filesize": filesize,
        "sizes": sizes == null ? null : sizes!.toMap(),
        "image_meta": imageMeta == null ? null : imageMeta!.toMap(),
      };
}

class ImageMeta {
  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  String? aperture;
  String? credit;
  String? camera;
  String? caption;
  String? createdTimestamp;
  String? copyright;
  String? focalLength;
  String? iso;
  String? shutterSpeed;
  String? title;
  String? orientation;
  List<dynamic>? keywords;

  factory ImageMeta.fromMap(Map<String, dynamic> json) => ImageMeta(
        aperture: json["aperture"],
        credit: json["credit"],
        camera: json["camera"],
        caption: json["caption"],
        createdTimestamp: json["created_timestamp"],
        copyright: json["copyright"],
        focalLength: json["focal_length"],
        iso: json["iso"],
        shutterSpeed:
            json["shutter_speed"],
        title: json["title"],
        orientation: json["orientation"],
        keywords: json["keywords"] == null
            ? null
            : List<dynamic>.from(json["keywords"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "aperture": aperture,
        "credit": credit,
        "camera": camera,
        "caption": caption,
        "created_timestamp": createdTimestamp,
        "copyright": copyright,
        "focal_length": focalLength,
        "iso": iso,
        "shutter_speed": shutterSpeed,
        "title": title,
        "orientation": orientation,
        "keywords": keywords == null
            ? null
            : List<dynamic>.from(keywords!.map((x) => x)),
      };
}

class MediaDetailsSizes {
  MediaDetailsSizes({
    this.medium,
    this.large,
    this.thumbnail,
    this.mediumLarge,
    this.full,
  });

  Full? medium;
  Full? large;
  Full? thumbnail;
  Full? mediumLarge;
  Full? full;

  factory MediaDetailsSizes.fromMap(Map<String, dynamic> json) =>
      MediaDetailsSizes(
        medium: json["medium"] == null ? null : Full.fromMap(json["medium"]),
        large: json["large"] == null ? null : Full.fromMap(json["large"]),
        thumbnail:
            json["thumbnail"] == null ? null : Full.fromMap(json["thumbnail"]),
        mediumLarge: json["medium_large"] == null
            ? null
            : Full.fromMap(json["medium_large"]),
        full: json["full"] == null ? null : Full.fromMap(json["full"]),
      );

  Map<String, dynamic> toMap() => {
        "medium": medium == null ? null : medium!.toMap(),
        "large": large == null ? null : large!.toMap(),
        "thumbnail": thumbnail == null ? null : thumbnail!.toMap(),
        "medium_large": mediumLarge == null ? null : mediumLarge!.toMap(),
        "full": full == null ? null : full!.toMap(),
      };
}

class Full {
  Full({
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.sourceUrl,
    this.filesize,
  });

  String? file;
  int? width;
  int? height;
  String? mimeType;
  String? sourceUrl;
  int? filesize;

  factory Full.fromMap(Map<String, dynamic> json) => Full(
        file: json["file"],
        width: json["width"],
        height: json["height"],
        mimeType: json["mime_type"],
        sourceUrl: json["source_url"],
        filesize: json["filesize"],
      );

  Map<String, dynamic> toMap() => {
        "file": file,
        "width": width,
        "height": height,
        "mime_type": mimeType,
        "source_url": sourceUrl,
        "filesize": filesize,
      };
}

class WpAttachmentMetadata {
  WpAttachmentMetadata({
    this.width,
    this.height,
    this.file,
    this.filesize,
    this.sizes,
    this.imageMeta,
  });

  int? width;
  int? height;
  String? file;
  int? filesize;
  WpAttachmentMetadataSizes? sizes;
  ImageMeta? imageMeta;

  factory WpAttachmentMetadata.fromMap(Map<String, dynamic> json) =>
      WpAttachmentMetadata(
        width: json["width"],
        height: json["height"],
        file: json["file"],
        filesize: json["filesize"],
        sizes: json["sizes"] == null
            ? null
            : WpAttachmentMetadataSizes.fromMap(json["sizes"]),
        imageMeta: json["image_meta"] == null
            ? null
            : ImageMeta.fromMap(json["image_meta"]),
      );

  Map<String, dynamic> toMap() => {
        "width": width,
        "height": height,
        "file": file,
        "filesize": filesize,
        "sizes": sizes == null ? null : sizes!.toMap(),
        "image_meta": imageMeta == null ? null : imageMeta!.toMap(),
      };
}

class WpAttachmentMetadataSizes {
  WpAttachmentMetadataSizes({
    this.medium,
    this.large,
    this.thumbnail,
    this.mediumLarge,
  });

  Large? medium;
  Large? large;
  Large? thumbnail;
  Large? mediumLarge;

  factory WpAttachmentMetadataSizes.fromMap(Map<String, dynamic> json) =>
      WpAttachmentMetadataSizes(
        medium: json["medium"] == null ? null : Large.fromMap(json["medium"]),
        large: json["large"] == null ? null : Large.fromMap(json["large"]),
        thumbnail:
            json["thumbnail"] == null ? null : Large.fromMap(json["thumbnail"]),
        mediumLarge: json["medium_large"] == null
            ? null
            : Large.fromMap(json["medium_large"]),
      );

  Map<String, dynamic> toMap() => {
        "medium": medium == null ? null : medium!.toMap(),
        "large": large == null ? null : large!.toMap(),
        "thumbnail": thumbnail == null ? null : thumbnail!.toMap(),
        "medium_large": mediumLarge == null ? null : mediumLarge!.toMap(),
      };
}

class Large {
  Large({
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.filesize,
  });

  String? file;
  int? width;
  int? height;
  String? mimeType;
  int? filesize;

  factory Large.fromMap(Map<String, dynamic> json) => Large(
        file: json["file"],
        width: json["width"],
        height: json["height"],
        mimeType: json["mime-type"],
        filesize: json["filesize"],
      );

  Map<String, dynamic> toMap() => {
        "file": file,
        "width": width,
        "height": height,
        "mime-type": mimeType,
        "filesize": filesize,
      };
}

class EmbeddedWpTerm {
  EmbeddedWpTerm({
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.links,
  });

  int? id;
  String? link;
  String? name;
  String? slug;
  String? taxonomy;
  WpTermLinks? links;

  factory EmbeddedWpTerm.fromMap(Map<String, dynamic> json) => EmbeddedWpTerm(
        id: json["id"],
        link: json["link"],
        name: json["name"],
        slug: json["slug"],
        taxonomy: json["taxonomy"],
        links:
            json["_links"] == null ? null : WpTermLinks.fromMap(json["_links"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "link": link,
        "name": name,
        "slug": slug,
        "taxonomy": taxonomy,
        "_links": links == null ? null : links!.toMap(),
      };
}

class WpTermLinks {
  WpTermLinks({
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
    this.curies,
  });

  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<About>? wpPostType;
  List<Cury>? curies;

  factory WpTermLinks.fromMap(Map<String, dynamic> json) => WpTermLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromMap(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(json["collection"].map((x) => About.fromMap(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromMap(x))),
        wpPostType: json["wp:post_type"] == null
            ? null
            : List<About>.from(
                json["wp:post_type"].map((x) => About.fromMap(x))),
        curies: json["curies"] == null
            ? null
            : List<Cury>.from(json["curies"].map((x) => Cury.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toMap())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toMap())),
        "about": about == null
            ? null
            : List<dynamic>.from(about!.map((x) => x.toMap())),
        "wp:post_type": wpPostType == null
            ? null
            : List<dynamic>.from(wpPostType!.map((x) => x.toMap())),
        "curies": curies == null
            ? null
            : List<dynamic>.from(curies!.map((x) => x.toMap())),
      };
}

class Cury {
  Cury({
    this.name,
    this.href,
    this.templated,
  });

  String? name;
  String? href;
  bool? templated;

  factory Cury.fromMap(Map<String, dynamic> json) => Cury(
        name: json["name"],
        href: json["href"],
        templated: json["templated"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "href": href,
        "templated": templated,
      };
}

class BooksWpLinks {
  BooksWpLinks({
    this.self,
    this.collection,
    this.about,
    this.wpFeaturedmedia,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
  });

  List<About>? self;
  List<About>? collection;
  List<About>? about;
  List<AuthorElement>? wpFeaturedmedia;
  List<About>? wpAttachment;
  List<LinksWpTerm>? wpTerm;
  List<Cury>? curies;

  factory BooksWpLinks.fromMap(Map<String, dynamic> json) => BooksWpLinks(
        self: json["self"] == null
            ? null
            : List<About>.from(json["self"].map((x) => About.fromMap(x))),
        collection: json["collection"] == null
            ? null
            : List<About>.from(json["collection"].map((x) => About.fromMap(x))),
        about: json["about"] == null
            ? null
            : List<About>.from(json["about"].map((x) => About.fromMap(x))),
        wpFeaturedmedia: json["wp:featuredmedia"] == null
            ? null
            : List<AuthorElement>.from(
                json["wp:featuredmedia"].map((x) => AuthorElement.fromMap(x))),
        wpAttachment: json["wp:attachment"] == null
            ? null
            : List<About>.from(
                json["wp:attachment"].map((x) => About.fromMap(x))),
        wpTerm: json["wp:term"] == null
            ? null
            : List<LinksWpTerm>.from(
                json["wp:term"].map((x) => LinksWpTerm.fromMap(x))),
        curies: json["curies"] == null
            ? null
            : List<Cury>.from(json["curies"].map((x) => Cury.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "self": self == null
            ? null
            : List<dynamic>.from(self!.map((x) => x.toMap())),
        "collection": collection == null
            ? null
            : List<dynamic>.from(collection!.map((x) => x.toMap())),
        "about": about == null
            ? null
            : List<dynamic>.from(about!.map((x) => x.toMap())),
        "wp:featuredmedia": wpFeaturedmedia == null
            ? null
            : List<dynamic>.from(wpFeaturedmedia!.map((x) => x.toMap())),
        "wp:attachment": wpAttachment == null
            ? null
            : List<dynamic>.from(wpAttachment!.map((x) => x.toMap())),
        "wp:term": wpTerm == null
            ? null
            : List<dynamic>.from(wpTerm!.map((x) => x.toMap())),
        "curies": curies == null
            ? null
            : List<dynamic>.from(curies!.map((x) => x.toMap())),
      };
}

class LinksWpTerm {
  LinksWpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  String? taxonomy;
  bool? embeddable;
  String? href;

  factory LinksWpTerm.fromMap(Map<String, dynamic> json) => LinksWpTerm(
        taxonomy: json["taxonomy"],
        embeddable: json["embeddable"],
        href: json["href"],
      );

  Map<String, dynamic> toMap() => {
        "taxonomy": taxonomy,
        "embeddable": embeddable,
        "href": href,
      };
}
