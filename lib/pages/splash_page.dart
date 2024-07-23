import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gallery_cleaner/pages/detect_page.dart';
import 'package:gallery_cleaner/pages/gallery_date_page.dart';
import 'package:gallery_cleaner/providers/gallery_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final Size _size = MediaQuery.of(context).size;

  late final double _bodyHeight = _size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom -
      const CupertinoNavigationBar().preferredSize.height;

  late final AnimationController _textController =
      AnimationController(vsync: this, duration: 2.seconds);
  late final AnimationController _logoController =
      AnimationController(vsync: this, duration: 2.seconds);

  bool _splashFinished = false, _dataFinished = false;

  _finishSplash() {
    if (_splashFinished && _dataFinished) {
      Navigator.pushReplacement(context, CupertinoPageRoute(
        builder: (context) {
          return GalleryDatePage();
        },
      ));
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      GalleryProvider galleryProvider =
          Provider.of<GalleryProvider>(context, listen: false);

      if (sharedPreferences.containsKey('galleryDates')) {
        galleryProvider.galleryDates =
            jsonDecode(sharedPreferences.getString('galleryDates') ?? "")
                as Map<int, List<int>>;
      } else {
        galleryProvider.getAssets().then((value) {
          var dates = galleryProvider.getDate(value);
          galleryProvider.galleryDates = dates;
          _dataFinished = true;
          _finishSplash();
          // sharedPreferences.setString('galleryDates', jsonEncode(dates));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: SizedBox(
          height: _bodyHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.camera,
                    size: 170,
                    color: Colors.blueGrey.shade800,
                  ),
                )
                    .animate(
                      controller: _logoController,
                      autoPlay: false,
                      onComplete: (controller) {
                        _splashFinished = true;
                        _finishSplash();
                      },
                    )
                    .scale(curve: Curves.fastEaseInToSlowEaseOut)
                    .fade(),
              ),
              Center(
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  onFinished: () {
                    _textController
                        .forward()
                        .then((value) => _logoController.forward());
                  },
                  animatedTexts: [
                    TyperAnimatedText(
                      "Gallery Cleaner",
                      textStyle: GoogleFonts.kanit(
                        fontSize: 25,
                      ),
                    ),
                  ],
                )
                    .animate(
                      controller: _textController,
                      autoPlay: false,
                    )
                    .moveY(begin: 0, end: -20, curve: Curves.ease)
                    .then()
                    .moveY(
                      begin: 0,
                      end: (_bodyHeight / 2) - 10,
                      curve: Curves.easeOutSine,
                      duration: 750.milliseconds,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
