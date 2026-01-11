import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceInfo {
  final double amount;
  final String currency;
  final String partnerName;
  final String? promoLabel;
  final double? shippingCost;
  final String? deliveryTime;
  final String? productUrl;

  PriceInfo({
    required this.amount,
    required this.currency,
    required this.partnerName,
    this.promoLabel,
    this.shippingCost,
    this.deliveryTime,
    this.productUrl,
  });

  double get totalAmount => amount + (shippingCost ?? 0.0);
}

class PriceService {
  // Pour la V1, on simule une agrégation de prix.
  // Plus tard, cela pourra appeler des APIs partenaires ou une Cloud Function.
  Future<List<PriceInfo>> getPricesForVariant(String mpn) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulation réseau

    // Simulation de données basées sur le MPN
    if (mpn == 'BP1234' || mpn == '0986494019') {
      return [
        PriceInfo(
          amount: 45.90,
          currency: '€',
          partnerName: 'Oscaro',
          shippingCost: 4.99,
          deliveryTime: '2-3 jours',
          productUrl: 'https://oscaro.com',
        ),
        PriceInfo(
          amount: 42.50,
          currency: '€',
          partnerName: 'MisterAuto',
          promoLabel: '-15%',
          shippingCost: 0.0,
          deliveryTime: '3-5 jours',
          productUrl: 'https://mister-auto.com',
        ),
        PriceInfo(
          amount: 48.00,
          currency: '€',
          partnerName: 'AutoDoc',
          shippingCost: 9.95,
          deliveryTime: '5-7 jours',
          productUrl: 'https://autodoc.fr',
        ),
      ];
    } else {
      return [
        PriceInfo(
          amount: 50.00,
          currency: '€',
          partnerName: 'Partenaire Standard',
          shippingCost: 5.00,
          deliveryTime: '3 jours',
        ),
      ];
    }
  }

  Future<PriceInfo?> getBestPrice(String mpn) async {
    final prices = await getPricesForVariant(mpn);
    if (prices.isEmpty) return null;
    return prices.reduce((a, b) => a.totalAmount < b.totalAmount ? a : b);
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
