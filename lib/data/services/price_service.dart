import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceInfo {
  final double amount;
  final String currency;
  final String partnerName;
  final String? promoLabel;

  PriceInfo({
    required this.amount,
    required this.currency,
    required this.partnerName,
    this.promoLabel,
  });
}

class PriceService {
  // Pour la V1, on simule une agrégation de prix.
  // Plus tard, cela pourra appeler des APIs partenaires ou une Cloud Function.
  Future<List<PriceInfo>> getPricesForVariant(String mpn) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulation réseau

    // Simulation de données basées sur le MPN
    if (mpn == 'BP1234') {
      return [
        PriceInfo(amount: 45.90, currency: '€', partnerName: 'Oscaro'),
        PriceInfo(
          amount: 42.50,
          currency: '€',
          partnerName: 'MisterAuto',
          promoLabel: '-15%',
        ),
      ];
    } else if (mpn == '0986494019') {
      return [
        PriceInfo(amount: 38.20, currency: '€', partnerName: 'MisterAuto'),
      ];
    } else {
      return [
        PriceInfo(
          amount: 50.00,
          currency: '€',
          partnerName: 'Partenaire Standard',
        ),
      ];
    }
  }

  Future<PriceInfo?> getBestPrice(String mpn) async {
    final prices = await getPricesForVariant(mpn);
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a.amount < b.amount ? a : b);
  }
}

final priceServiceProvider = Provider((ref) => PriceService());

final variantPricesProvider = FutureProvider.family<List<PriceInfo>, String>((
  ref,
  mpn,
) {
  return ref.watch(priceServiceProvider).getPricesForVariant(mpn);
});

final bestPriceProvider = FutureProvider.family<PriceInfo?, String>((ref, mpn) {
  return ref.watch(priceServiceProvider).getBestPrice(mpn);
});
