import 'package:flutter/material.dart';
import 'package:quicky/model/item_menu.dart';

class PanierModel {
  List<ItemMenu> listItemMenu;

  PanierModel(){
    listItemMenu = List<ItemMenu>();
  }

  addItemMenuToList(String menuId, String categorieId, int prix)
  {
    for(int i =0; i<listItemMenu.length;i++){
      if(menuId == listItemMenu[i].id){
        listItemMenu[i].number +=1;
        return;
      }
    }
    listItemMenu.add(ItemMenu.name(menuId, 1, categorieId, prix));
  }

  retireItemMenu(String menuId)
  {
    for(int i =0; i<listItemMenu.length;i++){
      if(menuId == listItemMenu[i].id){
        listItemMenu[i].number -=1;
        if (listItemMenu[i].number == 0){
          listItemMenu.removeAt(i);
          return;
        }
      }
    }
  }

  int getNumberOfItemMenu(String menuId){
    for(int i =0; i<listItemMenu.length;i++){
      if(menuId == listItemMenu[i].id){
        return listItemMenu[i].number;
      }
    }
    return 0;
  }

  String getPrix(){
    int prix = 0;
    for(int i =0; i<listItemMenu.length;i++){
      prix += (listItemMenu[i].number * listItemMenu[i].prix);
    }
    return prix.toString();
  }

  Map getMapMenu(){
    Map foodMap = {
    };
    for(int i =0; i<listItemMenu.length;i++){
      foodMap[listItemMenu[i].id] = listItemMenu[i].number;
    }
    return foodMap;
  }

}