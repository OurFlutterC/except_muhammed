
import 'package:except_Mohammed/GetProductByName.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onBoarding extends StatefulWidget {
  @override
  _onBoardingState createState() => _onBoardingState();
}



var _fontHeaderStyle = TextStyle(
  fontFamily: "Cairo-Black",
  fontSize: 21.0,
  fontWeight: FontWeight.w800,
  color: Colors.black,
  letterSpacing: 1.5
);

var _fontDescriptionStyle = TextStyle(
  fontFamily: "Cairo-Black",
  fontSize: 15.0,
  color: Colors.black45,
  fontWeight: FontWeight.w400
);

///
/// Page View Model for on boarding
///
List<PageViewModel> myPages(BuildContext context) => [
  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'نصرة للحبيب المصطفى محمد صلى الله عليه وسلم',style: _fontHeaderStyle,
        textAlign: TextAlign.center,
      ),
      body: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Text(
          'سنقاطع معا جميع المنتجات الفرنسية ليعرف العدو أن أمة الاسلام تمرض ولا تموت والعاقبة للمتقين.',textAlign: TextAlign.center,
          style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/IlustrasiOnBoarding1.png',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      )),

       new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'البحث عن المنتج بالرمز الشريطي',style: _fontHeaderStyle,
        textAlign: TextAlign.center,
      ),
      body: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Text(
            'كل ما عليك هو الضغط على الزر الجانبي ثم وضع الرمز الشريطي أمام الكاميرا ',textAlign: TextAlign.center,
            style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/IlustrasiOnBoarding2.png',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      )),

  new PageViewModel(
      pageColor:  Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'البحث عن المنتج باسمه',style: _fontHeaderStyle,
      ),
      body: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: Text(
            'تكتب اسم المنتج في خانة البحث اذا ظهر  في نتائج البحث هذا يعني أنه فرنسي ويجب مقاطعته ',textAlign: TextAlign.center,
            style: _fontDescriptionStyle
        ),
      ),
      mainImage: Image.asset(
        'assets/IlustrasiOnBoarding3.png',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      )),

 

];

class _onBoardingState extends State<onBoarding> {
  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
          child: IntroViewsFlutter(
        myPages(context),
        pageButtonsColor: Colors.black45,
        skipText: Text("تخطي",style: _fontDescriptionStyle.copyWith(color: Colors.deepPurpleAccent,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
        doneText: Text("تم",style: _fontDescriptionStyle.copyWith(color: Colors.deepPurpleAccent,fontWeight: FontWeight.w800,letterSpacing: 1.0),),
        onTapDoneButton: () async {
       SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
         prefs.setBool("First", true);
          Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> new GetByName(),
          transitionsBuilder: (_,Animation<double> animation,__,Widget widget){
            return Opacity(
              opacity: animation.value,
              child: widget,
            );
          },
          transitionDuration: Duration(milliseconds: 1500),
          ));
        },
      ),
    );
  }
}

