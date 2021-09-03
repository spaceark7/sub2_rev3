import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pickeat/controller/preferences_controller.dart';
import 'package:pickeat/ui/home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = '/onBoarding_screens';
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

 

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/images/s1.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.zero,
    );
    return GetBuilder<PreferencesController>(
      builder: (prefs) {
        return IntroductionScreen(
          key: introKey,
          // globalFooter: SizedBox(
          //   width: double.infinity,
          //   height: 60,
          //   child: ElevatedButton(
          //     child: Text('Let\'s Find Out'),
          //     onPressed: () {},
          //   ),
          // ),
          pages: [
            PageViewModel(
              title: "",
              body: "",
              image: _buildFullscrenImage(),
              decoration: pageDecoration.copyWith(
                contentMargin: const EdgeInsets.symmetric(horizontal: 16),
                fullScreen: true,
                bodyFlex: 2,
                imageFlex: 3,
              ),
            ),
            PageViewModel(
                title: "Your Favorites is here",
                body: "Everything that you like is here! There are plenty places you can explore with many foods and drinks to find what you like.",
                image: _buildImage('stores.png', 300),
                decoration: pageDecoration),
            PageViewModel(
                title: "Booking Or Comes by",
                body: "It's all your choices! You can book the table or just coming by with your friends. Simply convenient",
                image: _buildImage('booking.png', 250),
                decoration: pageDecoration),
            PageViewModel(
                title: "Ready To Find Out?",
                bodyWidget: Column(
                  children: [
                    Text(
                      'We will help you to find out.',
                      style: TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(onPressed: (){
                       Get.offAndToNamed(HomeScreen.routeName);
                        prefs.disableFirstLaunch();
                    }, child: Text("Find now"))
                  ],
                ),
                image: _buildImage('trip.png', 250),
                decoration: pageDecoration),
          ],
          next: Icon(Icons.arrow_forward),
          onDone: () {
            Get.offAndToNamed(HomeScreen.routeName);
            prefs.disableFirstLaunch();
          },
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: const Text('Skip'),
          curve: Curves.fastLinearToSlowEaseIn,
          done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
          controlsMargin: const EdgeInsets.all(16),
          dotsDecorator: const DotsDecorator(
            size: Size(10.0, 10.0),
            activeSize: Size(22.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
        );
      },
    );
  }
}
