

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/utils/ResultState.dart';
import 'package:pickeat/controller/database_controller.dart';

import 'package:pickeat/widgets/card_favorite.dart';

import 'package:pickeat/widgets/platformWidget.dart';

class FavoriteScreen extends StatelessWidget {
  static final routeName = '/favorite_page';
  final DatabaseController dbase = Get.find();

  // final Tween<Offset> _offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  // @override
  // void initState() {
  //   WidgetsBinding.instance!.addPostFrameCallback((_) {
  //     addData();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }

  // void addData() {
  //   Future ft = Future(() {});
  //   state.favList.forEach((element) {
  //     ft = ft.then((_) {
  //       return Future.delayed(const Duration(milliseconds: 100), () {
  //         _listItem.add(element);

  //         _listKey.currentState?.insertItem(_listItem.length - 1, duration: const Duration(milliseconds: 150));
  //       });
  //     });
  //   });
  // }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Favorite Places",
            style: TextStyle(fontSize: 32),
          ),
          toolbarHeight: 80,
        ),
        body: _buildList()
        // SafeArea(
        //   child: AnimatedList(
        //       key: _listKey,
        //       initialItemCount: _listItem.length ,
        //       itemBuilder: (context, index, animation) {

        //         return _listItem.isEmpty ? Center(child: Text('No Data'),) :

        //         SlideTransition(position: animation.drive(_offset),
        //         child: CardRestaurant(restaurant: _listItem[index ]));
        //       }),
        // ),
        );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Your Favorite Places', style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black))), child: _buildList()
        //   SafeArea(
        //   child: AnimatedList(
        //       key: _listKey,
        //       initialItemCount: _listItem.length ,
        //       itemBuilder: (context, index, animation) {

        //         return _listItem.isEmpty ? Center(child: Text('No Data'),) :

        //         SlideTransition(position: animation.drive(_offset), child: FavCardRestaurant(restaurant: _listItem[index ]));
        //       }),
        // ),

        );
  }

  Widget _buildList() {
   
      return GetBuilder<DatabaseController>(
        builder: (_) {
           if (dbase.state == ResultState.HasData) {
          return ListView.builder(
                      itemCount: _.favorites.length,
                      itemBuilder: (context, index) {
                        return CardFavorite(restaurant: dbase.favorites[index]);
                      }); 
        } else {
      return Center(
        child: Text(dbase.message),
      );
    }
        
        
        }
         
        ,
      );
    
  }
}
