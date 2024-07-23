import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_cleaner/pages/sub_gallery_page.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Gallery"),
        ),
        child: FutureBuilder(
          future: PhotoManager.getAssetPathList(type: RequestType.image),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          ...snapshot.data!.map(
                            (e) => GestureDetector(
                              onTap: () {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return SubCategoryPage(assetPathEntity: e);
                                  },
                                ));
                              },
                              child: Container(
                                height: 125,
                                width: 125,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: Text(
                                  e.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator.adaptive();
            }
          },
        ));
  }
}
