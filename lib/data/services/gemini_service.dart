import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import '../../domain/models/part_search_query.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService({GenerativeModel? model})
    : _model =
          model ??
          FirebaseAI.googleAI().generativeModel(
            model: 'gemini-3-flash-preview',
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              temperature: 0.2,
            ),
          );

  Future<PartSearchQuery> analyzeText(String userQuery) async {
    final prompt = Content.text('''
      Analyse cette requête utilisateur concernant une pièce automobile : "$userQuery"
      
      Instructions :
      1. Extraire le nom de la pièce (part_name).
      2. Identifier la catégorie (category) si possible (ex: Freinage, Moteur, Carrosserie).
      3. Extraire les références techniques ou codes (oem_number) si présents.
      4. Identifier le véhicule mentionné (car_make, car_model, year).
      
      Retourne UNIQUEMENT un JSON valide avec cette structure exacte :
      {
        "part_name": "Nom technique",
        "category": "Catégorie ou null",
        "manufacturer": "Marque de la pièce ou null",
        "oem_number": "Référence détectée ou null",
        "car_make": "Marque véhicule ou null",
        "car_model": "Modèle véhicule ou null",
        "year": année en entier ou null,
        "confidence": score entre 0.0 et 1.0
      }
      ''');

    try {
      final response = await _model.generateContent([prompt]);
      final jsonText = response.text;

      if (jsonText == null) {
        throw Exception('Réponse vide de Gemini');
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonText);
      return PartSearchQuery.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse textuelle Gemini: $e');
    }
  }

  Future<PartSearchQuery> analyzeImage(Uint8List imageBytes) async {
    final prompt = Content.text('''
      Analyse cette image de pièce automobile. Identifie-la avec précision selon le concept de Pièce Canonique (CPN).
      
      Instructions de classification :
      - part_name : Doit être le nom technique standardisé (ex: Alternateur, Disque de frein, Projecteur principal).
      - category : Catégorie fonctionnelle (ex: Moteur, Freinage, Éclairage, Suspension).
      - manufacturer : Marque visible sur la pièce (ex: Bosch, Valeo, Continental) ou null.
      - oem_number : Référence constructeur (OEM) ou référence fabricant (MPN) visible.
      
      Retourne UNIQUEMENT un JSON valide avec cette structure exacte :
      {
        "part_name": "Nom technique CPN",
        "category": "Catégorie",
        "manufacturer": "Fabricant ou null",
        "oem_number": "Référence ou null",
        "car_make": "Marque véhicule compatible ou null",
        "car_model": "Modèle véhicule compatible ou null",
        "year": null,
        "confidence": score entre 0.0 et 1.0
      }
      ''');

    final imagePart = Content.inlineData('image/jpeg', imageBytes);

    try {
      final response = await _model.generateContent([prompt, imagePart]);
      final jsonText = response.text;

      if (jsonText == null) {
        throw Exception('Réponse vide de Gemini');
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonText);
      return PartSearchQuery.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse Gemini: $e');
    }
  }
}
