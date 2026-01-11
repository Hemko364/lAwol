import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/data/services/price_service.dart';

class PriceComparisonSheet extends ConsumerWidget {
  final String mpn;
  final String brand;

  const PriceComparisonSheet({
    super.key,
    required this.mpn,
    required this.brand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricesAsync = ref.watch(variantPricesProvider(mpn));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comparateur de prix',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$brand • $mpn',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          pricesAsync.when(
            data: (prices) => _buildPriceList(context, prices),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(child: Text('Erreur: $e')),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPriceList(BuildContext context, List<PriceInfo> prices) {
    if (prices.isEmpty) {
      return const Center(child: Text('Aucune offre disponible'));
    }

    // Sort by total amount
    final sortedPrices = List<PriceInfo>.from(prices)
      ..sort((a, b) => a.totalAmount.compareTo(b.totalAmount));

    final bestPrice = sortedPrices.first;
    final worstPrice = sortedPrices.last;

    // R5 - Calcul économie
    double? savingsPercent;
    double? savingsAmount;
    if (prices.length >= 2) {
      savingsAmount = worstPrice.totalAmount - bestPrice.totalAmount;
      savingsPercent = (savingsAmount / worstPrice.totalAmount) * 100;
    }

    return Column(
      children: [
        if (savingsPercent != null && savingsPercent > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Économisez jusqu\'à ${savingsPercent.toStringAsFixed(0)}% (${savingsAmount?.toStringAsFixed(2)} €) en choisissant la meilleure offre.',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ...sortedPrices.map(
          (price) => _buildPriceItem(context, price, price == bestPrice),
        ),
      ],
    );
  }

  Widget _buildPriceItem(BuildContext context, PriceInfo price, bool isBest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBest
            ? Colors.blue.shade50.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBest ? Colors.blue.shade200 : Colors.grey.shade200,
          width: isBest ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Logo Partenaire (simulé par une icône)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront, color: Colors.blueGrey),
          ),
          const SizedBox(width: 16),
          // Infos Partenaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      price.partnerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (price.promoLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          price.promoLabel!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      price.deliveryTime ?? 'Délais non précisés',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Prix
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${price.totalAmount.toStringAsFixed(2)} ${price.currency}',
                style: TextStyle(
                  color: isBest ? Colors.blue.shade800 : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (price.shippingCost != null && price.shippingCost! > 0)
                Text(
                  '${price.amount.toStringAsFixed(2)} € + ${price.shippingCost!.toStringAsFixed(2)} € port',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                )
              else if (price.shippingCost == 0)
                const Text(
                  'Livraison gratuite',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Simulation ouverture lien
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBest ? Colors.blue : Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('Voir', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
