import 'package:flutter/widgets.dart';


class InteresList {
  InteresList({
   // required this.icon,
   // required this.imagePathIcon,
    required this.title,
  //  required this.text,
   // required this.firstbool,
    //required this.secondbool,
  });


 // Widget icon;
 // String imagePathIcon;
  String title;
 // String text;

 // bool firstbool; // eto dlya gradientov (ne beite)
 // bool secondbool;

  static List<InteresList> profileList = [
    InteresList(

    //  navigateScreen: ForumHomeScreen(),

   //   imagePathIcon: 'assets/listimg/forum2.png',
      title: 'sport1',
     // text: 'Знайдiть цiкаву для вас тему та приєднайтесь до обговорення!',
    //  firstbool: true,
    //  secondbool: false,


    ),
    InteresList(

  //    navigateScreen: ShopHomeScreen(),
   //   imagePathIcon: 'assets/listimg/shops.png',
      title: 'sport2',
  //    text: 'Кращий сервiс оголошень, створений для пасичникiв i людей!',
    //  firstbool: false,
    //  secondbool: true,
    ),
    InteresList(

   //   navigateScreen: EncklHomeScreen(),
    //  imagePathIcon: 'assets/listimg/book.png',
      title: 'sport3',
    //  text: 'Заходи та читай кращi статтi!',
     // firstbool: true,
     // secondbool: true,
    ),
  ];
}