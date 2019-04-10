import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class MemberPage extends StatefulWidget {
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {

  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String showText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text('會員登入')),
         body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '帳號',
                  helperText: '請輸入您的手機或Email'
                ),
                autofocus: false,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '密碼',
                  helperText: '請輸入您的密碼'
                ),
                autofocus: false,
              ),
              RaisedButton(
                onPressed: () {
                  _choiceAction();
                },
                child: Text('登入')
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
    print('開始登入。。。。');
    if (idController.text.toString() == '' || passwordController.text.toString() == '') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('帳號、密碼不能為空'),)
      );
    } else {
      // getHttp(typeController.text.toString()).then((val){
      //   setState(() {
      //     showText = val['data']['name'].toString();
      //   });
      // });
      setState(() {
        showText = '帳號、密碼錯誤!!';
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