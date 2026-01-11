import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lawol/presentation/ui/results/widgets/price_comparison_sheet.dart';
import '../../../domain/models/part_search_query.dart';
import '../../../core/providers/providers.dart';
import '../../../domain/models/part_variant.dart';
import '../../../data/services/price_service.dart';

class ResultsScreen extends ConsumerWidget {
  final PartSearchQuery searchQuery;

  const ResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Si on a une référence OEM, on cherche les variantes correspondantes
    final oemResults = searchQuery.oemNumber != null
        ? ref.watch(oemSearchProvider(searchQuery.oemNumber!))
        : const AsyncValue.data(<PartVariant>[]);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Résultat Identification'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildIdentificationHeader(context),
            const SizedBox(height: 24),
            _buildTechnicalDetails(context, ref),
            const SizedBox(height: 24),
            oemResults.when(
              data: (variants) => _buildVariantsSection(context, ref, variants),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erreur : $err')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantsSection(
    BuildContext context,
    WidgetRef ref,
    List<PartVariant> variants,
  ) {
    if (variants.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aucun équivalent direct trouvé',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Nous n\'avons pas trouvé de correspondance exacte pour cette référence dans notre base de données.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${variants.length} Équivalents trouvés',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...variants.map((v) {
          final bestPriceAsync = ref.watch(bestPriceProvider(v.mpn));
          final pricesAsync = ref.watch(variantPricesProvider(v.mpn));

          final priceText = bestPriceAsync.when(
            data: (price) => price != null
                ? '${price.amount.toStringAsFixed(2)} ${price.currency}'
                : '-- €',
            loading: () => '...',
            error: (_, __) => '-- €',
          );

          final hasMultipleOffers = pricesAsync.when(
            data: (prices) => prices.length >= 2,
            loading: () => false,
            error: (_, __) => false,
          );

          return _buildEquivalentCard(
            context,
            v.brand,
            '${v.supplier} • ${v.mpn}',
            priceText,
            'Référence OEM : ${v.oemReference ?? "N/A"}',
            brand: v.brand,
            hasMultipleOffers: hasMultipleOffers,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    PriceComparisonSheet(mpn: v.mpn, brand: v.brand),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildIdentificationHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Confiance : ${(searchQuery.confidence * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Icon(Icons.verified, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            searchQuery.partName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (searchQuery.category != null) ...[
            const SizedBox(height: 8),
            Text(
              searchQuery.category!.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 1.2,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTechnicalDetails(BuildContext context, WidgetRef ref) {
    // Si on a des variantes, on peut essayer de récupérer le CPN (Canonical Part)
    // pour afficher des détails plus riches (Schémas, etc.)
    final oemResults = searchQuery.oemNumber != null
        ? ref.watch(oemSearchProvider(searchQuery.oemNumber!))
        : const AsyncValue<List<PartVariant>>.data([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informations identifiées',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.business,
                'Marque',
                searchQuery.manufacturer ?? 'Non détecté',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.tag,
                'Référence',
                searchQuery.oemNumber ?? 'Non détectée',
              ),
              const Divider(height: 24),
              _buildInfoRow(
                Icons.directions_car,
                'Véhicule',
                searchQuery.carMake ?? 'Non détecté',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        oemResults.when(
          data: (variants) {
            if (variants.isEmpty) return const SizedBox.shrink();
            final cpnId = variants.first.cpnId;
            final canonicalPartAsync = ref.watch(canonicalPartProvider(cpnId));

            return canonicalPartAsync.when(
              data: (part) => part != null
                  ? _buildCPNDetails(context, part)
                  : const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),
        oemResults.when(
          data: (variants) {
            if (variants.isEmpty) return const SizedBox.shrink();
            final cpnId = variants.first.cpnId;
            final fitmentAsync = ref.watch(fitmentProvider(cpnId));

            return fitmentAsync.when(
              data: (fitments) => fitments.isNotEmpty
                  ? _buildFitmentSection(context, fitments)
                  : const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildFitmentSection(BuildContext context, List<dynamic> fitments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Compatibilité Véhicules',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Text(
                '${fitments.length} modèles',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fitments.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final f = fitments[index];
              return ListTile(
                leading: _buildBrandLogo(f.make),
                title: Text(
                  f.vehicleTrimId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  f.make,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (f.yearFrom != null)
                      Text(
                        '${f.yearFrom}${f.yearTo != null ? " - ${f.yearTo}" : "+"}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    const Icon(Icons.verified, color: Colors.green, size: 14),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrandLogo(String make) {
    Color brandColor = Colors.grey.shade400;
    String initial = make.isNotEmpty ? make[0].toUpperCase() : '?';

    switch (make.toUpperCase()) {
      case 'VW':
      case 'VOLKSWAGEN':
        brandColor = const Color(0xFF001E50); // VW Blue
        break;
      case 'AUDI':
        brandColor = Colors.black;
        break;
      case 'TOYOTA':
        brandColor = const Color(0xFFEB0A1E); // Toyota Red
        break;
      case 'PEUGEOT':
        brandColor = const Color(0xFF002244); // Peugeot Blue
        break;
      case 'RENAULT':
        brandColor = const Color(0xFFFFCC33); // Renault Yellow
        break;
      case 'BMW':
        brandColor = const Color(0xFF0066B3); // BMW Blue
        break;
      case 'MERCEDES':
        brandColor = Colors.grey.shade800;
        break;
      case 'BOSCH':
        brandColor = const Color(0xFFE30613); // Bosch Red
        break;
      case 'BREMBO':
        brandColor = const Color(0xFFE21017); // Brembo Red
        break;
      case 'MANN-FILTER':
        brandColor = const Color(0xFF009640); // Mann Green
        break;
      case 'VALEO':
        brandColor = const Color(0xFF00A19B); // Valeo Green
        break;
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: brandColor.withValues(alpha: 0.1),
      child: Text(
        initial,
        style: TextStyle(
          color: brandColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildCPNDetails(BuildContext context, dynamic part) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Schéma Technique',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.architecture, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Schéma pour : ${part.label}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Text(
                'Famille : ${part.family}',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEquivalentCard(
    BuildContext context,
    String name,
    String brandName,
    String price,
    String info, {
    String? brand,
    bool hasMultipleOffers = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasMultipleOffers
                ? Colors.blue.shade200
                : Colors.grey.shade200,
            width: hasMultipleOffers ? 1.5 : 1.0,
          ),
          boxShadow: hasMultipleOffers
              ? [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            _buildBrandLogo(brand ?? ''),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    brandName,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (hasMultipleOffers) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.compare_arrows,
                          size: 10,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Comparer',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
