import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_cleaner/pages/gallery_selected_date_page.dart';
import 'package:gallery_cleaner/providers/gallery_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GalleryDatePage extends StatefulWidget {
  const GalleryDatePage({super.key});

  @override
  State<GalleryDatePage> createState() => _GalleryDatePageState();
}

class _GalleryDatePageState extends State<GalleryDatePage> {
  late final GalleryProvider _galleryProvider =
      Provider.of<GalleryProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._galleryProvider.galleryDates.keys.map(
              (year) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          year.toString(),
                          style: const TextStyle(
                              fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        indent: 5,
                        endIndent: 5,
                      ),
                      Wrap(
                        runSpacing: 20,
                        spacing: 20,
                        children: [
                          ..._galleryProvider.galleryDates[year]!.map(
                            (month) => GestureDetector(
                              onTap: () async {
                                _galleryProvider.selectedDateAlbum =
                                    DateTime(year, month);
                                await _galleryProvider.getAlbumsByDate();
                                await _galleryProvider.getAssetsByDate();
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return GallerySelectedDatePage();
                                  },
                                ));
                              },
                              child: CircleAvatar(
                                radius: 25,
                                child: Text(
                                  DateFormat(DateFormat.MMM().pattern).format(
                                    DateTime(2000, month),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
