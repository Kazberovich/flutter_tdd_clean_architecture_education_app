import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';

class ResourceController extends ChangeNotifier {
  ResourceController({
    required FirebaseStorage storage,
    required SharedPreferences preferences,
  })  : _storage = storage,
        _preferences = preferences;

  final FirebaseStorage _storage;
  final SharedPreferences _preferences;

  Resource? _resource;
  bool _downloading = false;
  bool _loading = false;
  double _percenage = 0;

  String get _pathKey => 'material_file_path${_resource!.id}';

  double get percentage => _percenage;

  bool get loading => _loading;

  bool get downloading => _downloading;

  Resource? get resource => _resource;

  void initResource(Resource resource) {
    if (_resource == resource) return;
    _resource = resource;
  }

  bool get fileExists {
    final cachedFilePath = _preferences.getString(_pathKey);
    if (cachedFilePath == null) return false;
    final file = File(cachedFilePath);

    final fileExists = file.existsSync();
    if (!fileExists) _preferences.remove(_pathKey);

    return fileExists;
  }

  Future<File> _getFileFromCache() async {
    final cachedFilePath = _preferences.getString(_pathKey);
    return File(cachedFilePath!);
  }

  Future<File?> downloadAndSaveFile() async {
    _loading = true;
    _downloading = true;
    notifyListeners();
    final cacheDir = await getTemporaryDirectory();
    final file =
        File('${cacheDir.path}/${_resource!.id}.${_resource!.fileExtension}');
    if (file.existsSync()) return file;
    try {
      final ref = _storage.refFromURL(_resource!.fileURL);
      var successful = false;
      final downloadTask = ref.writeToFile(file);
      downloadTask.snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            _percenage =
                taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
            notifyListeners();

          case TaskState.paused:
            break;
          case TaskState.success:
            _downloading = false;
            await _preferences.setString(_pathKey, file.path);
            successful = true;

          case TaskState.canceled:
            successful = false;

          case TaskState.error:
            successful = false;
        }
      });
      await downloadTask;
      return successful ? file : null;
    } catch (e) {
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await file.delete();
      await _preferences.remove(_pathKey);
    }
  }

  Future<void> openFile() async {
    if (fileExists) {
      final file = await _getFileFromCache();
      await OpenFile.open(file.path);
    }
  }
}
