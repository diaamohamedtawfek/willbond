import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiAboutUs();
  }

}


class UiAboutUs extends State<AboutUs>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            title: Text("من نحن",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
          ),

            backgroundColor: Color(0xff212660),
          ),


          body:ListView(
            children: [
              Padding(padding: EdgeInsets.all(17),

                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 25,),

                    Text("من نحن",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        )
                    ),


                    about("شركة ويل بوند للتصنيع هي أول شركة مصنعة لألواح الكلادينج في مصر ، وتقع في السويس."),
                    about("يمكن أن تبدأ في وضع أزمة في عام 2008 ، وخلال سنوات ، يمكن أن تكون هناك أزمة في جميع أنحاء الولايات المتحدة."),
                    about("قامت ويل بوند ببناء شبكات مبيعات ومؤسسات خدمية رائعة في عشرات البلدان والمناطق حول العالم ، مثل المملكة العربية السعودية وتنزانيا وأوغندا ولبنان والكويت والسودان وفلسطين وكينيا وقطر وغيرهم."),
                    about("قدم فريق ويل بوند دائمًا أسرع توصيل وأفضل شحن وخدمة ما بعد البيع بشكل مثالي لجميع العملاء."),
                    about("يحصل العملاء على شهادة ضمان لمدة 20 عامًا على انحراف اللون والتقشير."),
                    about("تتوافق منتجات ويل بوند مع المعايير الدولية مثل EOS 2013/7530 ، SASO 2008/2752 وحصلنا على شهادة ISO 9001/2015."),


                    SizedBox(height: 31,),

                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                        Image.asset("assets/key.png",height: 33,width: 33,),
                        SizedBox(width: 31,),

                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("مهمتنا",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Color(0xff000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),

                                about("نحن ملتزمون بضرورة مواصلة تطوير معايير الجودة لجميع منتجات ويل بوند لتلبية متطلبات عملائنا من خلال الإدارة الفعالة والموظفين الأكفاء وأحدث معدات التصنيع المتاحة للسوق العالمي."),
                              ],
                            ),
                        ),

                        
                      ],
                    ),


                    SizedBox(height: 31,),


                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Image.asset("assets/eye.png",height: 33,width: 33,),
                        SizedBox(width: 31,),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("رؤيتنا",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),

                              about("نعمل جاهدين لنكون أفضل منتج لألواح الكلادينج في الشرق الأوسط."),
                            ],
                          ),
                        ),


                      ],
                    ),



                    SizedBox(height: 31,),
                  ],
                ),
              )
            ],
          )

        )
    );
  }

  Widget about(text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        SizedBox(height: 11,),

        Text(
          text,
          style: TextStyle(
              fontFamily: 'Cairo',
              color: Color(0xff000000),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal
          ),
          textDirection: TextDirection.rtl,
        ),

      ],
    );
  }
}