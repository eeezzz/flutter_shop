import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future getHomePageContent() async {
  try {
    print('開始獲取首頁數據');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    var formData = {'lon':'115.02932', 'lat':'35.76189'};
    print(formData);
    response = await dio.post(servicePath['homePageContext'], data: formData);
    print(response);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('後端接口出現異常!!');
    }

  }catch(e) {
    return print('ERROR:===========>${e}');
  }
}
