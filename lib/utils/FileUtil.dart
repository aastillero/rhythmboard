import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class FileUtil {
  ///Save file,
  ///
  ///NOTE: include extension in filename
  static Future<File?> saveFile(byteImg, String filename,
      {bool allowOverwrite = false}) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File? retVal;

    if (byteImg != null && byteImg.isNotEmpty) {
      try {
        File file = new File('$path/$filename');
        if (!file.existsSync()) {
          file.writeAsBytesSync(byteImg);
        } else {
          if (allowOverwrite) {
            await deleteFile('$filename').then((_) {
              File newFile = new File('$path/$filename');
              newFile.writeAsBytesSync(byteImg);
              file = newFile;
            });
          }
        }
        retVal = file;
      } catch (e) {
        retVal = null;
        print('Saving img error: $e');
      }
    }
    return retVal;
  }

  ///NOTE: include extension in filename
  static Future<File?> getImageFile(String? filename) async {
    final String? path = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$path/$filename');
    if (await f.exists()) {
      return f;
    } else {
      return null;
    }
  }

  static Future<File?> getVideoFile(String? filename) async {
    final String? path = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$path/$filename');
    if (await f.exists()) {
      return f;
    } else {
      return null;
    }
  }

  ///NOTE: include extension in filename
  static Future<bool> deleteFile(filename) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File f = new File('$path/$filename');
    bool isError = false;
    try {
      if (await f.exists()) {
        f.deleteSync();
      }
    } catch (e) {
      isError = true;
    }
    return isError;
  }

  static Future<File?> downloadFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    File retVal = File(filePath);

    if (retVal.existsSync()) {
      // If file already exists, return the file
      return retVal;
    }

    try {
      print('URI : $url');
      final res = await http.get(Uri.parse(url));
      final completer = Completer<File>();
      if (res.statusCode == 200) {
        // Write response body into file
        final fileStream = retVal.openWrite();
        res.bodyBytes.forEach((element) {
          fileStream.add(element as List<int>);
        });
        await fileStream.close();
        completer.complete(retVal);
        return completer.future;
      } else {
        print("INVALID RESPONSE: ${res.statusCode}");
        print(res.reasonPhrase);
        return null;
      }
    } catch (e) {
      print("Error occurred during download: $e");
      return null;
    }
  }

  static Future<bool> isFileExistsInDownloads(String fileName) async {
    // Get the path to the Download folder
    //Directory? downloadDir = await getDownloadsDirectory();
    Directory? downloadDir = Directory('/storage/emulated/0/Download');
    if (!await downloadDir.exists()) downloadDir = await getExternalStorageDirectory();
    String? downloadsPath = downloadDir?.path;

    // Check if the file exists in the Download folder
    print("DOWNLOADS PATH: $downloadsPath");
    File file = File('$downloadsPath/$fileName');
    return await file.exists();
  }

  static Future<bool> isFileExistsInAppDir(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final appPath = directory.path;

    print("APPS PATH: $appPath/$fileName");
    File file = File('$appPath/$fileName');
    return await file.exists();
  }

  static moveFileToAppDir(String fileName) async {
    Directory? downloadDir = Directory('/storage/emulated/0/Download');
    if (!await downloadDir.exists()) downloadDir = await getExternalStorageDirectory();
    String? downloadsPath = downloadDir?.path;

    final directory = await getApplicationDocumentsDirectory();
    final appPath = directory.path;

    File file = File('$downloadsPath/$fileName');
    if(await file.exists()) {
      // checked if have permission
      final PermissionStatus permissionStatus = await getPermission();
      if(permissionStatus == PermissionStatus.granted) {
        // move this to app dir
        var basNameWithExtension = path.basename(file.path);
        var copiedFile =  await _moveFile(file,appPath+"/"+basNameWithExtension);
        print("FILE MOVED: ${copiedFile.path}");
      } else {
        print("Was not granted permission");
      }
    } else {
      print("[$fileName] FILE NOT FOUND IN DOWNLOADS");
    }
  }

  static Future<File> _moveFile(File sourceFile, String newPath) async {
    try {
      /// prefer using rename as it is probably faster
      /// if same directory path
      return await sourceFile.rename(newPath);
    } catch (e) {
      /// if rename fails, copy the source file
      final newFile = await sourceFile.copy(newPath);
      return newFile;
    }
  }

  //Check storage permission
  static Future<PermissionStatus> getPermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    print("PERMISSION: $permission");
    if (permission != PermissionStatus.granted) {
      print("BEFORE THE STORAGE PERMISSION REQUEST...");
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.storage].request();
      return permissionStatus[Permission.storage] ??
          PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}
