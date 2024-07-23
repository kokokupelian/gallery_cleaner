import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_cleaner/pages/gallery_date_page.dart';
import 'package:gallery_cleaner/pages/gallery_filter_page.dart';
import 'package:gallery_cleaner/pages/gallery_page.dart';
import 'package:gallery_cleaner/pages/splash_page.dart';
import 'package:gallery_cleaner/providers/gallery_provider.dart';
import 'package:gallery_cleaner/providers/image_detection_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return ImageDetectionProvider();
            },
          ),
          ChangeNotifierProvider(
            create: (context) {
              return GalleryProvider();
            },
          )
        ],
        builder: (context, child) {
          return Consumer<ImageDetectionProvider>(
              builder: (context, provider, child) {
            return FutureBuilder(
                future: provider.loadModel(),
                builder: (context, snapshot) {
                  return CupertinoApp(
                    debugShowCheckedModeBanner: false,
                    theme:
                        const CupertinoThemeData(brightness: Brightness.light),
                    home: (snapshot.connectionState == ConnectionState.done)
                        ? const SplashPage()
                        : const Center(child: CupertinoActivityIndicator()),
                  );
                });
          });
        });
  }
}
