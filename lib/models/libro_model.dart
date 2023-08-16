// To parse this JSON data, do
//
//     final libro = libroFromJson(jsonString);

import 'dart:convert';

Libro libroFromJson(String str) => Libro.fromJson(json.decode(str));
Result resultFromJson(String str) => Result.fromJson(json.decode(str));
String libroToJson(Libro data) => json.encode(data.toJson());

class Libro {
  int count;
  String next;
  dynamic previous;
  List<Result> results;

  Libro({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => Libro(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  int id;
  String title;
  List<Author> authors;
  List<Author> translators;
  List<String> subjects;
  List<String> bookshelves;
  List<Language> languages;
  bool copyright;
  MediaType mediaType;
  Formats formats;
  int downloadCount;

  Result({
    required this.id,
    required this.title,
    required this.authors,
    required this.translators,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.copyright,
    required this.mediaType,
    required this.formats,
    required this.downloadCount,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        authors:
            List<Author>.from(json["authors"].map((x) => Author.fromJson(x))),
        translators: List<Author>.from(
            json["translators"].map((x) => Author.fromJson(x))),
        subjects: List<String>.from(json["subjects"].map((x) => x)),
        bookshelves: List<String>.from(json["bookshelves"].map((x) => x)),
        languages: List<Language>.from(
            json["languages"].map((x) => languageValues.map[x]!)),
        copyright: json["copyright"],
        mediaType: mediaTypeValues.map[json["media_type"]]!,
        formats: Formats.fromJson(json["formats"]),
        downloadCount: json["download_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "authors": List<dynamic>.from(authors.map((x) => x.toJson())),
        "translators": List<dynamic>.from(translators.map((x) => x.toJson())),
        "subjects": List<dynamic>.from(subjects.map((x) => x)),
        "bookshelves": List<dynamic>.from(bookshelves.map((x) => x)),
        "languages":
            List<dynamic>.from(languages.map((x) => languageValues.reverse[x])),
        "copyright": copyright,
        "media_type": mediaTypeValues.reverse[mediaType],
        "formats": formats.toJson(),
        "download_count": downloadCount,
      };
}

class Author {
  String name;
  int? birthYear;
  int? deathYear;

  Author({
    required this.name,
    required this.birthYear,
    required this.deathYear,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["name"],
        birthYear: json["birth_year"],
        deathYear: json["death_year"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "birth_year": birthYear,
        "death_year": deathYear,
      };
}

class Formats {
  String applicationXMobipocketEbook;
  String applicationEpubZip;
  String textHtml;
  String? applicationOctetStream;
  String imageJpeg;
  String? textPlain;
  String? textPlainCharsetUsAscii;
  String applicationRdfXml;
  String? textHtmlCharsetUtf8;
  String? textPlainCharsetUtf8;
  String? textPlainCharsetIso88591;
  String? textHtmlCharsetIso88591;

  Formats({
    required this.applicationXMobipocketEbook,
    required this.applicationEpubZip,
    required this.textHtml,
    this.applicationOctetStream,
    required this.imageJpeg,
    this.textPlain,
    this.textPlainCharsetUsAscii,
    required this.applicationRdfXml,
    this.textHtmlCharsetUtf8,
    this.textPlainCharsetUtf8,
    this.textPlainCharsetIso88591,
    this.textHtmlCharsetIso88591,
  });

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        applicationXMobipocketEbook: json["application/x-mobipocket-ebook"],
        applicationEpubZip: json["application/epub+zip"],
        textHtml: json["text/html"],
        applicationOctetStream: json["application/octet-stream"],
        imageJpeg: json["image/jpeg"],
        textPlain: json["text/plain"],
        textPlainCharsetUsAscii: json["text/plain; charset=us-ascii"],
        applicationRdfXml: json["application/rdf+xml"],
        textHtmlCharsetUtf8: json["text/html; charset=utf-8"],
        textPlainCharsetUtf8: json["text/plain; charset=utf-8"],
        textPlainCharsetIso88591: json["text/plain; charset=iso-8859-1"],
        textHtmlCharsetIso88591: json["text/html; charset=iso-8859-1"],
      );

  Map<String, dynamic> toJson() => {
        "application/x-mobipocket-ebook": applicationXMobipocketEbook,
        "application/epub+zip": applicationEpubZip,
        "text/html": textHtml,
        "application/octet-stream": applicationOctetStream,
        "image/jpeg": imageJpeg,
        "text/plain": textPlain,
        "text/plain; charset=us-ascii": textPlainCharsetUsAscii,
        "application/rdf+xml": applicationRdfXml,
        "text/html; charset=utf-8": textHtmlCharsetUtf8,
        "text/plain; charset=utf-8": textPlainCharsetUtf8,
        "text/plain; charset=iso-8859-1": textPlainCharsetIso88591,
        "text/html; charset=iso-8859-1": textHtmlCharsetIso88591,
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

enum MediaType { TEXT }

final mediaTypeValues = EnumValues({"Text": MediaType.TEXT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
