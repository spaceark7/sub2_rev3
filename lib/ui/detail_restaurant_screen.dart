import 'dart:io';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pickeat/api_service/api_service.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/controller/database_controller.dart';
import 'package:pickeat/controller/preferences_controller.dart';
import 'package:pickeat/controller/restaurant_controller.dart';
import 'package:pickeat/data/model/restaurant.dart';
import 'package:pickeat/data/model/restaurant_detail.dart';

class DetailScreen extends StatefulWidget {
  static final routeName = '/detail_screen';
  final Restaurant restaurant;

  DetailScreen({Key? key, required this.restaurant});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final RestaurantController controller = Get.find();
  final DatabaseController _dbase = Get.find();
  final PreferencesController prefs = Get.find();
  late Future<RestaurantDetailResult> futureDetail;
  final urlImg = "https://restaurant-api.dicoding.dev/images/medium/";

  @override
  void initState() {
    super.initState();
    futureDetail = ApiService().restaurantDetail(widget.restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    _dbase.isFavorite(widget.restaurant.id);
    return Scaffold(
      body: FutureBuilder(
          future: futureDetail,
          builder: (context, AsyncSnapshot snapshot) {
            var state = snapshot.connectionState;
            if (state != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var detail = snapshot.data?.restaurant;
              return NestedScrollView(
                  headerSliverBuilder: (context, isScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        actions: [
                          Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Obx(() => _dbase.isFav.value
                                  ? IconButton(
                                      color: accentBrandColor,
                                      onPressed: () {
                                        _dbase.removeFavorite(widget.restaurant.id);
                                        _dbase.isFav.value = false;
                                        SnackBar snackBar = SnackBar(content: Text("Removed from Favorite"),
                                        backgroundColor: prefs.isDarkTheme.value ? secondaryDarkColor : accentBrandColor,);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      },
                                      icon: Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite),
                                      iconSize: 32,
                                    )
                                  : IconButton(
                                      color: accentBrandColor,
                                      onPressed: () {
                                        _dbase.addFavorite(widget.restaurant);
                                        _dbase.isFav.value = true;
                                         SnackBar snackBar = SnackBar(content: Text("Added to Favorite"),
                                        backgroundColor: prefs.isDarkTheme.value ? secondaryDarkColor : accentBrandColor,);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      },
                                      icon: Icon(Platform.isIOS ? CupertinoIcons.heart_circle : Icons.favorite_outline),
                                      iconSize: 32,
                                    ))

                              // IconButton(
                              //   color: accentBrandColor,
                              //   onPressed: () {
                              //     _dbase.addFavorite(widget.restaurant);
                              //   },
                              //   icon: Obx(() => _dbase.isFav.value
                              //       ? Icon(Platform.isIOS ? CupertinoIcons.heart : Icons.favorite)
                              //       : Icon(Platform.isIOS ? CupertinoIcons.heart_circle : Icons.favorite_outline)),
                              //   iconSize: 32,
                              // ),
                              )
                        ],
                        expandedHeight: 250,
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: secondaryBrandColor,
                        foregroundColor: secondaryBrandColor,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Text(
                            detail!.name,
                            style: Theme.of(context).textTheme.headline5!.apply(color: Colors.white),
                          ),
                          background: Hero(
                            tag: urlImg + widget.restaurant.pictureId!,
                            child: Image.network(
                              urlImg + widget.restaurant.pictureId!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    ];
                  },
                  body: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      detail!.rating.toString(),
                                      style: Theme.of(context).textTheme.bodyText1!.apply(color: secondaryBrandColor, fontSizeDelta: 32.0, fontWeightDelta: 5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Overall Score', style: Theme.of(context).textTheme.bodyText1),
                                          RatingBar.builder(
                                            initialRating: detail.rating,
                                            itemBuilder: (context, _) => Icon(
                                              Platform.isIOS ? CupertinoIcons.star : Icons.star,
                                              size: 8,
                                              color: secondaryBrandColor,
                                            ),
                                            itemSize: 18,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            onRatingUpdate: (rating) {},
                                            allowHalfRating: true,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Platform.isIOS ? CupertinoIcons.placemark : Icons.place,
                                      color: secondaryBrandColor,
                                      size: 24,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${detail.address}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      Text(
                                        "${detail.city} City",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Divider(
                                color: Colors.black38,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.caption!.apply(fontSizeDelta: 5),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Obx(() => ExpandableText(
                                    detail.description,
                                    expandText: 'Read More',
                                    collapseText: 'Show Less',
                                    animation: true,
                                    maxLines: 3,
                                    collapseOnTextTap: true,
                                    linkColor: accentBrandColor,
                                    animationDuration: Duration(milliseconds: 500),
                                    animationCurve: Curves.ease,
                                    style: TextStyle(color: prefs.isDarkTheme.value ? Colors.white : Colors.black, fontSize: 16),
                                  )),
                              SizedBox(
                                height: 24,
                              ),
                              detail.categories.length != null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Category',
                                          style: Theme.of(context).textTheme.caption!.apply(fontSizeDelta: 5),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            height: 25,
                                            child: GridView.count(
                                                scrollDirection: Axis.horizontal,
                                                crossAxisCount: 1,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 2 / 5,
                                                children: detail.categories
                                                    .map<Widget>((e) => Material(
                                                          elevation: 0,
                                                          color: Colors.white12,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.white12,
                                                                borderRadius: BorderRadius.circular(20),
                                                                border: Border.all(color: secondaryBrandColor, width: 1)),
                                                            child: Center(
                                                              child: Text(
                                                                e.name.toString(),
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(color: secondaryBrandColor, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                    .toList()),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 8,
                                    ),
                              SizedBox(
                                height: 24,
                              ),
                              Center(
                                child: Obx(() => Text("Menus",
                                    style: prefs.isDarkTheme.value
                                        ? Theme.of(context).textTheme.headline4!.apply()
                                        : Theme.of(context).textTheme.headline4!.apply(color: Colors.black87))),
                              ),
                              Divider(
                                color: Colors.black38,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Foods',
                                    style: Theme.of(context).textTheme.caption!.apply(fontSizeDelta: 7, fontWeightDelta: 7),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _foodMenuList(context, detail)
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Drinks',
                                    style: Theme.of(context).textTheme.caption!.apply(fontSizeDelta: 7, fontWeightDelta: 7),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  _drinksMenuList(context, detail)
                                ],
                              ),
                              SizedBox(
                                height: 69.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        primary: accentBrandColor,
                                        textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      defaultTargetPlatform == TargetPlatform.iOS
                                          ? showCupertinoDialog(
                                              context: context,
                                              barrierDismissible: true,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Coming Soon!'),
                                                  content: Text('This feature will be coming soon!'),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: Text('Ok'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Coming Soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5, fontSizeDelta: 5),
                                                  ),
                                                  content: Text(
                                                    'This feature will be coming soon!',
                                                    style: Theme.of(context).textTheme.bodyText1!.apply(fontWeightDelta: 5),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(primary: secondaryBrandColor),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Dismiss'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                      child: Text("Book Table"),
                                    )),
                              ),
                              SizedBox(
                                height: 30.0,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(
                child: Text("Weird!"),
              );
            }
          }),
    );
  }

  Widget menuGridHorizontal(BuildContext context, List<String> items, String category) {
    return Column(
      children: [
        Text(
          '$category Selection',
          style: Theme.of(context).textTheme.caption!.apply(fontSizeDelta: 7, fontWeightDelta: 7),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 5,
            children: _listFoodGrid(items),
          ),
        ),
      ],
    );
  }

  List<Material> _listFoodGrid(List<String> foods) {
    return foods
        .map((e) => Material(
              elevation: 1,
              child: Container(
                decoration: BoxDecoration(color: accentBrandColor, borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      e,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }

  SizedBox _foodMenuList(BuildContext context, detail) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 5,
          children: detail.menus.foods
              .map<Widget>((item) => Material(
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(color: secondaryBrandColor, borderRadius: BorderRadius.circular(2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            item.name.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }

  SizedBox _drinksMenuList(BuildContext context, detail) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 5,
          children: detail.menus.drinks
              .map<Widget>((item) => Material(
                    elevation: 1,
                    child: Container(
                      decoration: BoxDecoration(color: secondaryBrandColor, borderRadius: BorderRadius.circular(2)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            item.name.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}
