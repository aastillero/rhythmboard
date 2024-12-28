import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

const TIMEOUT_DURATION = 20;

class HttpUtil {
  static Future getRequest(String uri) async {
    //-UPD4TE-
    //CURRENT IMPLEMENTATION
    try {
      http.Response res = await http.get(Uri.parse(uri));
      print("res status code: ${res.statusCode}");
      if (res.statusCode == 200) {
        var body;
        //validate if response is not string
        if (res.headers["content-type"] != null) {
          //res is image
          if (res.headers["content-type"]!.contains("image")) {
            body = res.bodyBytes;
          } else {
            //res is normal data
            body = jsonDecode(res.body);
            print("response body:");
            print(body);
          }
        } else {
          //no headers but has successful endpoint
          //test connection
          body = jsonDecode(res.body);
          print("response body:");
          print(body);
        }
        return body;
      } else {
        print("INVALID RESPONSE: ${res.statusCode}");
        print(res.reasonPhrase);
        return {"error": res.statusCode, "message": res.reasonPhrase};
      }
    } catch (e) {
      print("Error decoding: $e");
      return {"error": 404, "message": e};
    }

    // print("Req URL: ${uri}");
    // try {
    //   http.Response res = await http.get(Uri.parse(uri));

    //
    //   //Causing an issue because its being decode before going to content type checker
    //   // print("res status code: ${res.statusCode}");
    //   // print("res status code Body: ${jsonDecode(res.body)}");

    //   if (res.statusCode == 200) {
    //     var body;
    //     //validate if response is not string
    //     // if (res.headers["content-type"] == "image/png") {
    //     //   body = res.bodyBytes;
    //     // } else {
    //     //   body = jsonDecode(res.body);
    //     //   print("response body:");
    //     //   print(body);
    //     // }
    //     //
    //     //will catch all image instead of just png from previous build
    //     if (res.headers["content-type"]!.contains("image")) {
    //       body = res.bodyBytes;
    //     } else {
    //       body = jsonDecode(res.body);
    //       print("response body:");
    //       print(body);
    //     }
    //     return body;
    //   } else {
    //     print("INVALID RESPONSE: ${res.statusCode}");
    //     print(res.reasonPhrase);
    //     return {"error": res.statusCode, "message": res.reasonPhrase};
    //   }
    // } catch (e) {
    //   print("Error decoding getrR: $e");
    //   return {"error": 404, "message": e};
    // }
  }

  static Future<String?> networkImageToBase64(imageUrl) async {
    http.Response response = await http.get(imageUrl);
    final bytes = response.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  static Future getImgRequest(String uri) async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // final key = 'token';
      // final value = prefs.get(key) ?? 0;

      Map<String, String> headers = {
        'Charset': 'utf-8',
        'accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
        'user-agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
      };
      print('URI : $uri');
      http.Response res = await http.get(Uri.parse(uri), headers: headers);
      print('Content type : ${res.headers["content-type"]}');
      // var body = utf8.decode(res.bodyBytes);
      var body;
      var contentType = res.headers["content-type"];

      var response = await Dio().get(uri);
      print('Response DIO : ${response.data}');
      // print('Response HTTP : ${await networkImageToBase64(uri)}');
      // print("res status code: ${res.statusCode}");
      // print("res status code Body: $body");

      if (res.statusCode == 200) {
        //validate if response is not string

        // print("response body image: $body");
        if (contentType == "image/jpeg" || contentType == "image/png") {
          //body = await networkImageToBase64(res.bodyBytes);
          // print("response body bytes: ${res.bodyBytes}");

          print("response body image dio: $response");
        } else {
          // print("response body before:");
          // print(body);
          // body = jsonDecode(res.body);
          body = json.decode(res.body);
          // var uri = Uri.parse(decodedResponse['uri'] as String);
          // print("response body after:");
          // print(body);
        }
        // print("response body after:");
        // print(body);
        return body;
      } else {
        print("INVALID RESPONSE: ${res.statusCode}");
        print(res.reasonPhrase);
        return {"error": res.statusCode, "message": res.reasonPhrase};
      }
    } catch (e) {
      print("Error decodingsR: $e");
      return {"error": 404, "message": e};
    }
  }

  static Future postRequest(String uri, Map reqBody) async {
    print("Sending HTTP POST: $uri");
    print("request post body: $reqBody");
    try {
      http.Response res = await http.post(Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      print('RES : ${res}');
      //.timeout(Duration(seconds: TIMEOUT_DURATION))
      //  .catchError((error) {
      //ScreenUtil.showMainFrameDialog(context, "debug", error.message);
      /*if (error is TimeoutException || error is SocketException) {
        print("Request has timed out");
        throw new StateError("Error: Request has timed out.");
      }
      else {
        print("error: ${error}");
        throw new StateError(
            "Error: Internal error has occurred. Please contact support.");
      }
    });*/

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        print("response body:");
        print(body);
        return body;
      } else {
        print("INVALID RESPONSE: ${res.statusCode}");
        print(res.reasonPhrase);
        return {"error": res.statusCode, "message": res.reasonPhrase};
      }
    } catch (e) {
      print("Error decoding: $e");
      return {"error": 404, "message": e};
    }
  }

  static Future uploadImage(context, String uri, File filename) async {
    print("UPLOADING IMAGE @ $uri");
    var postUri = Uri.parse(uri);
    var request = http.MultipartRequest("POST", postUri);
    request.fields["Content-Type"] = "multipart/form-data";
    request.files.add(await http.MultipartFile.fromPath(
        "uploadfile", filename.absolute.path,
        contentType: MediaType("image", "png")));
    var stres = await request.send();
    print("status: ${stres.statusCode}");
    print("phrase: ${stres.reasonPhrase}");
    if (stres.statusCode == 200) {
      var res = await http.Response.fromStream(stres);
      var body = jsonDecode(res.body);
      print("response body:");
      print(body);
      return body;
    } else {
      print("INVALID RESPONSE: ${stres.statusCode}");
      print(stres.reasonPhrase);
      return {"error": stres.statusCode, "message": stres.reasonPhrase};
    }
  }
}
