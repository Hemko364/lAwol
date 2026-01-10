import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';
import '../../domain/models/part_search_query.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService()
    : _model = FirebaseAI.googleAI().generativeModel(
        model:
            'gemini-3-flash-preview', 
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          temperature: 0.2,
        ),
      );

  Future<PartSearchQuery> analyzeImage(Uint8List imageBytes) async {
    final prompt = Content.text('''
      Analyse cette image de pièce automobile. Identifie-la avec précision pour un catalogue technique.
      Retourne UNIQUEMENT un JSON valide avec cette structure exacte :
      {
        "part_name": "Nom technique standard (CPN) (ex: Alternateur, Disque de frein)",
        "category": "Catégorie fonctionnelle (ex: Moteur, Freinage, Suspension)",
        "manufacturer": "Fabricant visible sur la pièce (ex: Bosch, Valeo) ou null",
        "oem_number": "Numéro de référence visible ou null",
        "car_make": "Marque de véhicule compatible ou null",
        "car_model": "Modèle de véhicule compatible ou null",
        "year": Année approximative (int) ou null,
        "confidence": Score de confiance entre 0.0 et 1.0
      }
      ''');

    final imagePart = Content.inlineData('image/jpeg', imageBytes);

    try {
      print(
        'Envoi de la requête à Gemini avec une image de ${imageBytes.lengthInBytes} bytes',
      );
      final response = await _model.generateContent([prompt, imagePart]);
      final jsonText = response.text;
      print('Réponse brute Gemini: $jsonText');

      if (jsonText == null) {
        throw Exception('Réponse vide de Gemini');
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonText);
      print('JSON décodé: $jsonMap');
      return PartSearchQuery.fromJson(jsonMap);
    } catch (e, stackTrace) {
      print('Erreur détaillée Gemini: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Erreur lors de l\'analyse Gemini: $e');
    }
  }
}
