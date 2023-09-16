import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dataproject2/productionmodel/ebooks.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DownloadStatus { idle, loading }

class EbookProvider extends ChangeNotifier {
  String _language = '';
  int _grade = 0;
  int progress = 0;
  DownloadStatus _downloadStatus = DownloadStatus.idle;

  int get grade => _grade;
  String get language => _language;
  DownloadStatus get downLoadStatus => _downloadStatus;

  set setGrade(int val) {
    _grade = val;
    notifyListeners();
  }

  set setLanguage(String val) {
    _language = val;
    notifyListeners();
  }

  set setDownloadStatus(DownloadStatus downloadStatus) {
    _downloadStatus = downloadStatus;
    notifyListeners();
  }

  Future<List<String>> getDownloadedBooks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> downloaded = pref.getStringList('ebookPath') ?? [];
    return downloaded;
  }

  Future<BooksWp?> getDownloadedBookModel(String path) async {
    BooksWp? booksWp;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var media = pref.getString(path);
    if (media != null) {
      var decode = jsonDecode(media);
      booksWp = BooksWp.fromMap(decode);
    }
    return booksWp;
  }

  Future<void> saveSettings() async {
    if (grade > 0 && language.isNotEmpty) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('language', language);
      await pref.setInt('grade', grade);
    }
  }

  Future<bool> getSaved() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? lang = pref.getString('language');
    int? grade = pref.getInt('grade');
    if (lang != null && grade != null) {
      _language = lang;
      _grade = grade;
      notifyListeners();

      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  //
  Future<File?> downloadPdf(
    String url,
    String name,
    BooksWp media,
  ) async {
    final storage = await getApplicationDocumentsDirectory();
    SharedPreferences pref = await SharedPreferences.getInstance();

    final file = File('${storage.path}/$name');
    progress = 0;
    // print(url);

    try {
      var response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ), onReceiveProgress: (received, total) {
        progress = ((received / total) * 100).floor();
        notifyListeners();
      });

      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(response.data);
      await ref.close();
      log('message');

      final check = await file.exists();
      if (check) {
        List<String> downloadedFile = [];
        downloadedFile = pref.getStringList('ebookPath') ?? [];
        media.downloadFile = file.path;
        media.isFileOpen = false;
        String encodedB = jsonEncode(media.toMap());
        downloadedFile.add(encodedB);
        await pref.setStringList('ebookPath', downloadedFile);
        await pref.setString(media.id.toString(), encodedB);
      }

      return file;
    } catch (e) {
      progress = 0;
      log(e.toString());
      return null;
    }
  }
}

extension FileUtils on File {
  get size {
    int sizeInBytes = lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }
}
