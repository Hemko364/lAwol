import '../models/part_search_query.dart';

class NormalizationLayer {
  /// Nettoie et valide la requête avant de l'envoyer aux APIs fournisseurs
  static PartSearchQuery normalize(PartSearchQuery rawQuery) {
    return PartSearchQuery(
      partName: _normalizePartName(rawQuery.partName),
      oemNumber: _cleanOemNumber(rawQuery.oemNumber),
      carMake: _capitalize(rawQuery.carMake),
      carModel: _capitalize(rawQuery.carModel),
      year: rawQuery.year,
      confidence: rawQuery.confidence,
    );
  }

  static String _normalizePartName(String name) {
    // Exemple : Transformer "Alternateur auto" en "Alternateur"
    return name.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static String? _cleanOemNumber(String? oem) {
    if (oem == null) return null;
    // Enlever les espaces et tirets pour la recherche API
    final cleaned = oem.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
    return cleaned.isEmpty ? null : cleaned;
  }

  static String? _capitalize(String? text) {
    if (text == null || text.isEmpty) return null;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
