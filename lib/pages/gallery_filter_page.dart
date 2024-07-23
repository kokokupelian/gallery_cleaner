import 'package:flutter/cupertino.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryFilterPage extends StatefulWidget {
  const GalleryFilterPage({super.key});

  @override
  State<GalleryFilterPage> createState() => _GalleryFilterPageState();
}

class _GalleryFilterPageState extends State<GalleryFilterPage> {
  late final _future = PhotoManager.getAssetPathList(
    type: RequestType.image,
  );

  Map<String, bool> _filter = {};

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Filter"),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_filter.isEmpty) {
                snapshot.data!.forEach((element) {
                  _filter[element.name] = true;
                });
                _filter['All'] = true;
              }
              return ListView(
                children: [
                  Row(
                    children: [
                      CupertinoCheckbox(
                        value: _filter['All'],
                        onChanged: (value) {
                          _filter.forEach((key, _) {
                            _filter[key] = value ?? false;
                          });
                          setState(() {});
                        },
                      ),
                      Text("All"),
                    ],
                  ),
                  ...snapshot.data!.map((e) => Row(
                        children: [
                          CupertinoCheckbox(
                            value: _filter[e.name],
                            onChanged: (value) {
                              setState(() {
                                _filter[e.name] = value ?? false;
                              });
                            },
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filter[e.name] = !(_filter[e.name] ?? false);
                                });
                              },
                              child: Text(e.name)),
                        ],
                      ))
                ],
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ));
  }
}
