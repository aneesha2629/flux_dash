import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/dashboard_card_model.dart';
import '../../data/local_storage_service.dart';
import '../../core/data_generator.dart';

enum LayoutType { grid, list }

class DashboardProvider extends ChangeNotifier {
  List<DashboardCardModel> _cards = [];
  LayoutType _layout = LayoutType.grid;
  bool _isLoading = true;
  Timer? _dataTimer;

  List<DashboardCardModel> get cards => _cards;
  LayoutType get layout => _layout;
  bool get isLoading => _isLoading;

  DashboardProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    
    _cards = List.from(DashboardCardModel.defaults);

    
    final savedOrder = LocalStorageService.getCardOrder();
    if (savedOrder != null) {
      _reorderByIds(savedOrder);
    }

    
    final savedLayout = LocalStorageService.getLayoutType();
    _layout = savedLayout == 'list' ? LayoutType.list : LayoutType.grid;

    _isLoading = false;
    notifyListeners();

    _startDataRefresh();
  }

  void _startDataRefresh() {
    _dataTimer?.cancel();
    _dataTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _refreshCardData();
    });
  }

  void _refreshCardData() {
    _cards = _cards.map((card) {
      if (card.type == CardType.pie) {
        final newPie = DataGenerator.generatePieData(card.pieData.length);
        return card.copyWith(pieData: newPie);
      }
      final newSeries = DataGenerator.mutateSeries(card.seriesData);
      final newCurrent = newSeries.last * (card.unit == '\$' ? 1000 : 1);
      return card.copyWith(
        previousValue: card.currentValue,
        currentValue: newCurrent,
        seriesData: newSeries,
      );
    }).toList();
    notifyListeners();
  }


  void toggleExpand(String cardId) {
    _cards = _cards.map((c) {
      if (c.id == cardId) return c.copyWith(isExpanded: !c.isExpanded);
      return c.copyWith(isExpanded: false); 
    }).toList();
    notifyListeners();
  }

  void toggleLayout() {
    _layout = _layout == LayoutType.grid ? LayoutType.list : LayoutType.grid;
    LocalStorageService.saveLayoutType(
      _layout == LayoutType.grid ? 'grid' : 'list',
    );
    notifyListeners();
  }

  
  void reorderCards(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;
    final card = _cards.removeAt(fromIndex);
    _cards.insert(toIndex, card);

   
    for (int i = 0; i < _cards.length; i++) {
      _cards[i] = _cards[i].copyWith(gridPosition: i);
    }

    LocalStorageService.saveCardOrder(_cards.map((c) => c.id).toList());
    notifyListeners();
  }


  void removeCard(String cardId) {
    _cards.removeWhere((c) => c.id == cardId);
    notifyListeners();
  }


  void refreshNow() => _refreshCardData();

  void _reorderByIds(List<String> ids) {
    final mapped = {for (var c in _cards) c.id: c};
    final reordered = ids
        .where((id) => mapped.containsKey(id))
        .map((id) => mapped[id]!)
        .toList();
    
    final existingIds = ids.toSet();
    for (final card in _cards) {
      if (!existingIds.contains(card.id)) reordered.add(card);
    }
    _cards = reordered;
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    super.dispose();
  }
}
