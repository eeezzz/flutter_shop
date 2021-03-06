import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  
  String homePageContent = '正在獲取數據';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活＋'),
      ),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            List<Map> navigatorList = (data['data']['category'] as List).cast();
            String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
            // String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话 
            String  leaderPhone = '0918122223'; //店长电话 
            print('店長圖片:$leaderImage');
            print('店長電話:$leaderPhone');
            // 商品推薦
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            return new SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList: swiperDataList),
                  TopNavigator(navigatorList: navigatorList),
                  AdBanner(advertesPicture: advertesPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommand(recommendList: recommendList),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('加載中'),
            );
          }
          
        },
      ),
    );
  }
}
// 輪播組件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}):super(key:key);
  
  @override
  Widget build(BuildContext context){
    // ScreenUtil.getInstance()..init(context);
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('設備的像素密度：${ScreenUtil.pixelRatio}');
    print('設備的高：${ScreenUtil.screenHeight}');
    print('設備的寛：${ScreenUtil.screenWidth}');
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network('${swiperDataList[index]['image']}', fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      )
    );
  }
}
// 導航組件
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}):super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {

    return InkWell(
      onTap: () {
        print('點擊了尋航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'], style: TextStyle(fontSize: 10.0),)
          // Text(item['mallCategoryName'],)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }

 
}

class AdBanner extends StatelessWidget {
  final String advertesPicture;

  AdBanner({Key key, this.advertesPicture}) : super(key: key);
  
  @override
  Widget build(BuildContext context){
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw '電話格式不正確 $url';
    }
  }
}

// 商品推薦
class Recommand extends StatelessWidget {
  final List recommendList;

  Recommand({Key key, this.recommendList}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Container(
      height: ScreenUtil().setHeight(395),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      )
    );
  }

  // 商品推薦標題
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12) )
      ),
      child: Text(
        '商品推薦',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  //
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text(
              '￥${recommendList[index]['mallPrice']}',
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                fontSize: 10.0,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            )
          ],
        )
      ),
      
    );
  }
}