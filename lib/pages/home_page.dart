import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController typeController = TextEditingController();
  String showText = '歡迎您來到美好人間高級會所';

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('美好人間')),
         body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '美女類型',
                  helperText: '請輸入你喜歡的類型'
                ),
                autofocus: false,
              ),
              RaisedButton(
                onPressed: () {
                  _choiceAction();
                },
                child: Text('選擇完畢')
              ),
              Text (
                showText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          )
         )
       ),
    );
  }

  void _choiceAction(){
    print('開始選擇你喜歡的類型。。。。');
    if (typeController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('美女類型不能為空'),)
      );
    } else {
      getHttp(typeController.text.toString()).then((val){
        setState(() {
          showText = val['data']['name'].toString();
        });
      });
    }
  }


  Future getHttp(String TypeText) async {
    try {
      Response response;
      // map
      var data = {'name': TypeText};
      response = await Dio().get(
        'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
        queryParameters: data,
      );
      return response.data;
    } catch (e) {

    }
  }
}