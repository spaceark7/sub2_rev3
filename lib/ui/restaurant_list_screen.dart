import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pickeat/common/style.dart';
import 'package:pickeat/controller/preferences_controller.dart';
import 'package:pickeat/controller/restaurant_controller.dart';
import 'package:pickeat/data/model/restaurant.dart';
import 'package:pickeat/ui/detail_restaurant_screen.dart';
import 'package:pickeat/widgets/card_restaurant.dart';
import 'package:pickeat/widgets/platformWidget.dart';

class RestaurantListScreen extends StatelessWidget {
  final urlImg = "https://restaurant-api.dicoding.dev/images/medium/";
  final RestaurantController state = Get.find();
  final PreferencesController prefs = Get.find();
  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIOS);
  }

  Widget _buildList(BuildContext context) {
    return Obx(() {
      if (state.searchResult.isNotEmpty) {
        return MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              itemCount: state.searchResult.length,
              itemBuilder: (context, index) {
                return CardRestaurant(restaurant: state.searchResult[index]);
              }),
        );
      } else if (state.query.isNotEmpty && state.isSearch.value == true) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.isNotFound == true && state.query.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/NOT_FOUND.png',
                height: 200,
              ),
              Text(
                '${state.message} \n Cannot find \"${state.query}\"',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.apply(fontSizeDelta: 2),
              ),
            ],
          ),
        );
      } else if (state.isLoading.value == false && state.restaurants.isNotEmpty) {
        return MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView.builder(
              itemCount: state.restaurants.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _carouselBuilder(context, state.restaurants);
                }
                if (index == 1) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0, top: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discover The Best Place",
                          style: Theme.of(context).textTheme.headline6!.apply(fontSizeDelta: 10),
                        ),
                        Container(
                          width: 190,
                          child: const Divider(
                            height: 10,
                            thickness: 1,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return CardRestaurant(restaurant: state.restaurants[index - 2]);
              }),
        );
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return FloatingSearchAppBar(
      title: Obx(() => Text(
            'Pick\'eat',
            style: prefs.isDarkTheme.value ? Theme.of(context).textTheme.headline4!.apply(color: secondaryBrandColor) :Theme.of(context).textTheme.headline4!.apply(color: Colors.black),
          )),
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 900),
      accentColor: secondaryBrandColor,
      hintStyle: Theme.of(context).textTheme.bodyText1,
      hint: 'I\'m Looking For ...',
      onSubmitted: (_) {
        if (state.searchResult.isNotEmpty) {
          state.isSearch.value = true;
        }
      },
      iconColor: secondaryBrandColor,
      clearQueryOnClose: true,
      debounceDelay: const Duration(milliseconds: 1000),
      onQueryChanged: (value) {
        if (value.isEmpty) {
          state.query.value = value;
          state.searchResult.clear();
        } else {
          state.query.value = value;  
          state.fetchSearchData(state.query.value);
        }
      },
      height: 70,
      colorOnScroll: prefs.isDarkTheme.value ? primaryDarkColor : primaryBrandColor ,
      body: _buildList(context),
    );
  }

  Widget _buildIOS(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: Scaffold(
              body: FloatingSearchAppBar(
            hideKeyboardOnDownScroll: true,
            title: Text(
              'Pick\'eat',
              style: Theme.of(context).textTheme.headline4!.apply(color: Colors.black),
            ),
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 900),
            accentColor: secondaryBrandColor,
            hintStyle: Theme.of(context).textTheme.bodyText1,
            hint: 'I\'m Looking For ...',
            onSubmitted: (_) {
              if (state.searchResult.isNotEmpty) {
                state.isSearch.value = true;
              }
            },
            iconColor: secondaryBrandColor,
            clearQueryOnClose: true,
            debounceDelay: const Duration(milliseconds: 1000),
            onQueryChanged: (value) {
              if (value.isEmpty) {
                state.query.value = value;
                state.searchResult.clear();
              } else {
                state.query.value = value;
                state.fetchSearchData(state.query.value);
              }
            },
            colorOnScroll: primaryBrandColor,
            height: 200,
            body: null,
          )),
          transitionBetweenRoutes: false,
        ),
        child: _buildList(context));
  }

  Widget _carouselBuilder(BuildContext context, List<Restaurant> resto) {
    var items = resto.where((element) => element.rating >= 4.5);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Place',
                style: Theme.of(context).textTheme.headline5!.apply(fontSizeDelta: 10),
              ),
              Container(
                width: 130,
                child: Divider(
                  height: 10,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
        CarouselSlider(
            items: items
                .map<Widget>((item) => Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24.0),
                        splashColor: secondaryBrandColor.withAlpha(80),
                        focusColor: accentBrandColor,
                        onTap: () {
                          Get.toNamed(DetailScreen.routeName, arguments: item);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0, left: 8),
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Ink.image(
                                image: NetworkImage(urlImg + item.pictureId!),
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                                child: SizedBox(
                                  height: 70,
                                  child: Text(
                                    item.name,
                                    style: Theme.of(context).textTheme.bodyText1!.apply(color: primaryBrandColor, fontSizeDelta: 10, fontWeightDelta: 10),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.8,
                                  height: 50,
                                  child: Text(
                                    item.description,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.bodyText2!.apply(
                                          color: primaryBrandColor,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
            options: CarouselOptions(height: 350, aspectRatio: 2.0, autoPlay: true, viewportFraction: 0.8, autoPlayCurve: Curves.easeInOutCubic)),
      ],
    );
  }
}
