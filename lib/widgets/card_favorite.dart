import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/controller/database_controller.dart';
import 'package:pickeat/controller/restaurant_controller.dart';

import 'package:pickeat/data/model/restaurant.dart';
import 'package:pickeat/ui/detail_restaurant_screen.dart';

class CardFavorite extends StatelessWidget {
  final Restaurant restaurant;

  CardFavorite({Key? key, required this.restaurant}) : super(key: key);
  final RestaurantController state = Get.find();
  final DatabaseController dbHelper = Get.find();
  final imageUrl = "https://restaurant-api.dicoding.dev/images/medium/";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: dbHelper.isFavorite(restaurant.id),
      builder: (context, snapshot) {
        var fav = snapshot.data ?? false;
        return Material(
         
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(DetailScreen.routeName, arguments: restaurant);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Ink.image(
                          height: 200,
                          image: NetworkImage(imageUrl + restaurant.pictureId!),
                          fit: BoxFit.cover,
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 10.0, bottom: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  restaurant.name,
                                  style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black, fontSizeDelta: 3, fontWeightDelta: 5),
                                ),
                                Text(restaurant.city),
                                RatingBar.builder(
                                  initialRating: restaurant.rating,
                                  itemBuilder: (context, _) => Icon(
                                    Platform.isIOS ? CupertinoIcons.star : Icons.star,
                                    size: 6,
                                    color: secondaryBrandColor,
                                  ),
                                  itemSize: 24,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  onRatingUpdate: (rating) {},
                                  allowHalfRating: true,
                                )
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: fav
                                    ? IconButton(
                                        onPressed: () {
                                          dbHelper.removeFavorite(restaurant.id);
                                        },
                                        icon: Icon(Icons.favorite),
                                        iconSize: 24.0,
                                      )
                                    : IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.favorite_outline),
                                        iconSize: 24.0,
                                      )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
      // Material(
      //     color: primaryBrandColor,
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      //       child: Card(
      //         clipBehavior: Clip.antiAlias,
      //         elevation: 8,
      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      //         child: InkWell(
      //           onTap: () {
      //             Get.toNamed(DetailScreen.routeName, arguments: restaurant);
      //           },
      //           child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Stack(children: [
      //                 Ink.image(
      //                   height: 200,
      //                   image: NetworkImage(imageUrl + restaurant.pictureId),
      //                   fit: BoxFit.cover,
      //                 )
      //               ]),
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 8.0, left: 10.0, bottom: 16.0),
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.max,
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: <Widget>[
      //                         Text(
      //                           restaurant.name,
      //                           style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black, fontSizeDelta: 3, fontWeightDelta: 5),
      //                         ),
      //                         Text(restaurant.city),
      //                         RatingBar.builder(
      //                           initialRating: restaurant.rating,
      //                           itemBuilder: (context, _) => Icon(
      //                             Platform.isIOS ? CupertinoIcons.star : Icons.star,
      //                             size: 6,
      //                             color: secondaryBrandColor,
      //                           ),
      //                           itemSize: 24,
      //                           itemCount: 5,
      //                           ignoreGestures: true,
      //                           onRatingUpdate: (rating) {},
      //                           allowHalfRating: true,
      //                         )
      //                       ],
      //                     ),

      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     )),
    );
  }
}
