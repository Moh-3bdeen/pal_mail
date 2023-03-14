import 'package:flutter/cupertino.dart';

class PassAllData extends ChangeNotifier{

  List allCategory = [];
  String? categoryName;
  int? categoryId;

  List getAllCategory(){
    return allCategory;
  }

  void putCategory(List categories){
    allCategory = categories;
    notifyListeners();
  }

  void selectCategory(String name, int id){
    categoryName = name;
    categoryId = id;

    notifyListeners();
  }

/////////////////////////////////////////////////////////////////

  int? senderId;
  String? senderName;
  String? senderMobile;


/////////////////////////////////////////////////////////////////

  String? imageUrl;
  String? name;

  void passUserData(String? image, String name) {
    imageUrl = image;
    this.name = name;

    notifyListeners();
  }

  ////////////////////////////////////////////////////////////

  List allTags = [];

  List getAllTagy(){
    return allTags;
  }

  void putTags(List tags){
    allTags = tags;
    notifyListeners();
  }


/////////////////////////////////////////////////////////////////

  List allMails = [];

  List getAllMails(){
    return allMails;
  }

  void putMails(List mails){
    allMails = mails;
    notifyListeners();
  }


/////////////////////////////////////////////////////////////////

}