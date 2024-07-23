import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_cleaner/providers/gallery_provider.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';

class GallerySelectedDatePage extends StatefulWidget {
  const GallerySelectedDatePage({
    super.key,
  });

  @override
  State<GallerySelectedDatePage> createState() =>
      _GallerySelectedDatePageState();
}

class _GallerySelectedDatePageState extends State<GallerySelectedDatePage> {
  late final GalleryProvider _galleryProvider =
      Provider.of<GalleryProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          DateFormat(DateFormat.YEAR_MONTH)
              .format(_galleryProvider.selectedDateAlbum ?? DateTime.now()),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade900,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              _galleryProvider.clearDateSelection();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        trailing: IconButton(
            onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 600,
              child: Consumer<GalleryProvider>(
                  builder: (context, provider, child) {
                return PageView(
                  padEnds: true,
                  pageSnapping: true,
                  children: [
                    ...provider.assetsByDate.map(
                      (e) => AssetEntityImage(
                        e,
                      ),
                    )
                  ],
                  onPageChanged: (value) {
                    _galleryProvider.addAdditionalAssets(value);
                  },
                );
              }),
            ),
            // const Text(
            //   "50",
            //   style: TextStyle(color: Colors.white, fontSize: 30),
            // )
          ],
        ),
      ),
    );
  }
}
