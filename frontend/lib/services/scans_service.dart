import 'package:flutter/material.dart';
import 'package:frontend/dtos/scan.dart';
import 'package:frontend/services/api_client.dart';
import 'package:intl4x/collation.dart';

class ScanService extends ChangeNotifier {
  final ApiClient _apiClient;

  ScanService(this._apiClient);

  List<ScanDto> _myScans = [];
  List<ScanDto> get _myScanSortedFiltered => _sort(_filter(_myScans));
  List<ScanDto> get myScans => _isSortReversed
      ? _myScanSortedFiltered.reversed.toList()
      : _myScanSortedFiltered;

  bool _isSortReversed = false;
  bool get isSortReversed => _isSortReversed;

  ScanSortingOptions _currentSort = .byDate;
  ScanSortingOptions get currentSort => _currentSort;

  String _currentFilter = "";

  Future<void> fetchMyScans() async {
    _myScans = await _apiClient.getMyScans();

    notifyListeners();
  }

  void setSort(ScanSortingOptions sortOption) {
    _currentSort = sortOption;

    notifyListeners();
  }

  void setFilter(String newFilter) {
    _currentFilter = newFilter;

    notifyListeners();
  }

  void reverseSort() {
    _isSortReversed = !_isSortReversed;

    notifyListeners();
  }

  List<ScanDto> _sort(List<ScanDto> scans) {
    var newList = [...scans];
    _currentSort.sort(newList);
    return newList;
  }

  List<ScanDto> _filter(List<ScanDto> scans) {
    return scans
        .where(
          (scan) => scan.townshipName.toLowerCase().contains(
            _currentFilter.toLowerCase(),
          ),
        )
        .toList();
  }
}

enum ScanSortingOptions {
  byDate("Date", _sortBydate),
  byTownship("Commune", _sortByTownship),
  byReport("Signalement", _sortByReport),
  byOwning("Possession", _sortByOwning);

  const ScanSortingOptions(this.label, this.sort);
  final String label;
  final void Function(List<ScanDto>) sort;

  static void _sortBydate(List<ScanDto> scans) {
    scans.sort((s1, s2) => s2.createdAt.compareTo(s1.createdAt));
  }

  static final _french = Collation(locale: .parse("fr-FR"));
  static void _sortByTownship(List<ScanDto> scans) {
    scans.sort((s1, s2) => _french.compare(s1.townshipName, s2.townshipName));
  }

  static void _sortByReport(List<ScanDto> scans) {
    scans.sort((s1, s2) => s1.reportNumber.compareTo(s2.reportNumber));
  }

  static void _sortByOwning(List<ScanDto> scans) {
    scans.sort(
      (s1, s2) => (s1.hasTownship ? 0 : 1).compareTo(s2.hasTownship ? 0 : 1),
    );
  }
}
