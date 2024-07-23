import 'package:flutter/cupertino.dart';
import 'package:jiffy/jiffy.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryProvider with ChangeNotifier {
  // #region galleryDates
  late Map<int, List<int>> _galleryDates;
  Map<int, List<int>> get galleryDates {
    return _galleryDates;
  }

  set galleryDates(Map<int, List<int>> value) {
    _galleryDates = value;
  }
  // #endregion

  // #region galleryFilter
  late Map<String, bool> _galleryFilter;
  Map<String, bool> get galleryFilter {
    return _galleryFilter;
  }

  set galleryFilter(Map<String, bool> value) {
    _galleryFilter = value;
  }
  // #endregion

  // #region albums
  late List<String> _albums;
  List<String> get albums {
    return _albums;
  }

  set albums(List<String> value) {
    _albums = value;
  }
  // #endregion

  // #region albumsByDate
  late List<AssetPathEntity> _albumsByDate;
  List<AssetPathEntity> get albumsByDate {
    return _albumsByDate;
  }

  set albumsByDate(List<AssetPathEntity> value) {
    _albumsByDate = value;
  }
  // #endregion

  // #region assetsByDate
  late List<AssetEntity> _assetsByDate = [];
  List<AssetEntity> get assetsByDate {
    return _assetsByDate;
  }

  set assetsByDate(List<AssetEntity> value) {
    _assetsByDate = value;
  }
  // #endregion

  int _assetsByDateCount = 0;

  DateTime? selectedDateAlbum;

  Future<List<AssetEntity>> getAssets() async {
    var root = await PhotoManager.getAssetPathList(
      onlyAll: true,
      type: RequestType.image,
    );

    int index = 0;

    List<AssetEntity> assets = [];

    List<AssetEntity> subAssets = [];

    do {
      subAssets.clear();
      subAssets =
          await root[0].getAssetListRange(start: index, end: index + 1000);
      assets.addAll(subAssets.toList());
      index += 1000;
    } while (subAssets.isNotEmpty &&
        subAssets.last.createDateTime
            .isAtSameMomentAs(assets.last.createDateTime));

    return assets;
  }

  Map<int, List<int>> getDate(List<AssetEntity> assets) {
    var uniqueDates = assets.map((e) => e.createDateTime);

    var years = uniqueDates.map((e) => e.year).toSet();

    Map<int, List<int>> output = {};

    for (var element in years) {
      if (element == DateTime.now().year) {
        output[element] = List.generate(
            DateTime.now().month, (index) => index + 1,
            growable: false);
      } else {
        output[element] = List.generate(12, (index) => index + 1);
      }
    }

    return output;
  }

  Future getAlbumsByDate() async {
    if (selectedDateAlbum == null) return;
    var manager = await PhotoManager.getAssetPathList(
        onlyAll: true,
        filterOption: FilterOptionGroup(
            createTimeCond: DateTimeCond(
                min: selectedDateAlbum!,
                max: Jiffy.parseFromDateTime(selectedDateAlbum!)
                    .add(months: 1)
                    .dateTime)));
    albumsByDate = manager;
  }

  Future getAssetsByDate() async {
    int currentCount = _assetsByDateCount;
    _assetsByDateCount += 20;
    var assets = await albumsByDate[0]
        .getAssetListRange(start: currentCount, end: _assetsByDateCount);
    if (assetsByDate.isEmpty) {
      assetsByDate.addAll(assets);
      notifyListeners();
    } else if (assets.last != assetsByDate.last) {
      assetsByDate.addAll(assets);
      notifyListeners();
    } else {
      print('finished');
    }
  }

  void addAdditionalAssets(int currentAsset) {
    if (currentAsset == _assetsByDateCount - 10) {
      getAssetsByDate();
    }
  }

  void clearDateSelection() {
    _assetsByDateCount = 0;
    _albumsByDate = [];
    _assetsByDate = [];
    selectedDateAlbum = null;
  }
}
