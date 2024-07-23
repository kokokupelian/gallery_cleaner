import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart' as cp;
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class SubCategoryPage extends StatefulWidget {
  final AssetPathEntity assetPathEntity;
  const SubCategoryPage({super.key, required this.assetPathEntity});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late final _future =
      widget.assetPathEntity.getAssetListRange(start: 0, end: 20);

  late List<AssetEntity>? _assets = [];

  var _index = 0;

  _assetThumbnail(Future<File?> file) {
    return FutureBuilder(
      future: file,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.file(snapshot.data!);
        }
        return cp.Center(child: const CircularProgressIndicator.adaptive());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return cp.CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: cp.CupertinoNavigationBar(
        middle: Text(
          widget.assetPathEntity.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade900,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _assets = snapshot.data;
            return cp.Center(
              child: cp.Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: cp.MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 600,
                    child: CarouselSlider(
                      items: [
                        ...snapshot.data!.map((e) => _assetThumbnail(e.file))
                      ],
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        height: 600,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _index = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Text(
                    "50",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  )
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator.adaptive();
          }
        },
      ),
    );
  }
}
