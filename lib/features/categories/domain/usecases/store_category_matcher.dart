import 'package:frontend_flutter/features/stores/domain/entities/store.dart';

class StoreCategoryMatcher {
  const StoreCategoryMatcher();

  bool matchesHome(Store store, String category) {
    final cat = category.toLowerCase();
    final target = '${store.category} ${store.displayCategory} ${store.badge}'
        .toLowerCase();
    if (cat == 'pakaian') {
      return target.contains('pakaian') || target.contains('baju');
    } else if (cat.contains('mainan')) {
      return target.contains('mainan') || target.contains('kids toys');
    } else if (cat == 'sembako') {
      return target.contains('sembako');
    } else if (cat == 'makanan') {
      return store.category.toLowerCase() == 'makanan';
    } else if (cat == 'perabotan') {
      return target.contains('perabotan') || target.contains('peralatan');
    } else if (cat == 'lainnya') {
      return !target.contains('baju') &&
          !target.contains('pakaian') &&
          !target.contains('mainan') &&
          !target.contains('sembako') &&
          !target.contains('makanan') &&
          !target.contains('kuliner');
    }
    return target.contains(cat);
  }

  bool matchesStoreList(Store store, String category) {
    final cat = category.toLowerCase().trim();
    final sCat = store.category.toLowerCase();
    final sBadge = store.badge.toLowerCase();
    final sDisplay = store.displayCategory.toLowerCase();
    final combined = '$sCat $sBadge $sDisplay';

    if (cat.contains('makanan') && !cat.contains('minuman')) {
      return sCat == 'makanan';
    }
    if (cat.contains('sayur') || cat.contains('buah')) {
      return combined.contains('sayur') ||
          combined.contains('buah') ||
          combined.contains('organic');
    }
    if (cat.contains('kuliner') || cat.contains('legend')) {
      return combined.contains('kuliner') ||
          combined.contains('legend') ||
          sCat.contains('kuliner');
    }
    if (cat.contains('daging') || cat.contains('ikan')) {
      return combined.contains('daging') || combined.contains('ikan');
    }
    if (cat.contains('sembako') ||
        cat.contains('perabotan') ||
        cat.contains('peralatan')) {
      return combined.contains('sembako') ||
          combined.contains('perabotan') ||
          combined.contains('peralatan');
    }
    if (cat.contains('mainan') ||
        cat.contains('pakaian') ||
        cat.contains('baju')) {
      return combined.contains('mainan') ||
          combined.contains('pakaian') ||
          combined.contains('baju') ||
          combined.contains('kids toys');
    }
    return combined.contains(cat);
  }
}
