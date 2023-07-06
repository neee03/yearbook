import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yearbook/onboarding/all_colleges/all_colleges_page.dart';

var color1 = Color(0xFFFFCB37);
var color2 = Color(0xFFFFCB37);
var color3 = Color(0xFFFFCB37);

List<String> image = [
  'assets/images/onboard-1.png',
  'assets/images/onboard-2.png',
  'assets/images/onboard-3.png',
];

List<String> title = [
  'Capture your best memories.',
  'Everything is better with friends.',
  'Show your love',
];

List<String> text = [
  'This is your yearbook! So you can preserve the best memories.',
  'Share now and get your friends to sign your yearbook!',
  "Sign your friends' yearbooks by writing your best moments spent together"
];

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  CarouselSlider carouselSlider;
  int carouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    carouselSlider = CarouselSlider(
      viewportFraction: 1.0,
      enableInfiniteScroll: false,
      onPageChanged: (index) {
        setState(() {
          carouselIndex = index;
        });
      },
      height: MediaQuery.of(context).size.height,
      items: <Widget>[
        CarouselComponent(
          col1: color1,
          col2: color2,
          imgUrl: image[0],
          ttl: title[0],
          txt: text[0],
        ),
        CarouselComponent(
          col1: color2,
          col2: color3,
          imgUrl: image[1],
          ttl: title[1],
          txt: text[1],
        ),
        CarouselComponent(
          col1: color3,
          col2: color3,
          imgUrl: image[2],
          ttl: title[2],
          txt: text[2],
        ),
      ],
    );

    return Scaffold(
      floatingActionButton: carouselIndex == 2
          ? Container()
          : IconButton(
              icon: Icon(
                Icons.chevron_right,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () {
                carouselSlider.nextPage(
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              }),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          carouselSlider,
          carouselIndex == 2
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.07,
                  child: MaterialButton(
                    color: Colors.white,
                    onPressed: () async {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => AllCollegesPage()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                    child: Text(
                      "CONTINUE",
                      style: TextStyle(
                        color: Color(0xFFFFCB37),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.12,
                  child: Row(
                    children: <Widget>[
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 0,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 1,
                      ),
                      Indicator(
                        carouselIndex: carouselIndex,
                        indicatorIndex: 2,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class CarouselComponent extends StatelessWidget {
  final col1, col2, imgUrl, ttl, txt;

  CarouselComponent({this.col1, this.col2, this.imgUrl, this.ttl, this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 10),
      color: col2,
      child: Container(
        decoration: BoxDecoration(
          color: col1,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(180),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            Image.asset(
              imgUrl,
              height: 300,
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 0,
              ),
              child: Text(
                ttl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 20,
              ),
              child: Text(
                txt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final carouselIndex, indicatorIndex;

  Indicator({this.carouselIndex, this.indicatorIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: carouselIndex == indicatorIndex ? Colors.white : Colors.grey,
      ),
    );
  }
}
