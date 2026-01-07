# lAwôl — Business Rules (MVP)

## R1 — Identification IA (photo)
- L’IA retourne :
  - CPN
  - confidence_score (0–1)
  - top_candidates (max 3)
- Si confidence < seuil :
  - demander confirmation utilisateur

## R2 — Schéma
- Si un schéma existe pour le CPN :
  - l’afficher systématiquement
- Sinon :
  - masquer le bloc

## R3 — Compatibilités véhicules
- Toujours afficher :
  - le véhicule issu du VIN (si fourni)
  - ou la liste des véhicules compatibles (fitment)

## R4 — Équivalences inter-marques
- Afficher uniquement :
  - interchange.status = VALIDATED
- Trier par :
  1. confidence_score DESC
  2. type (OEM_EXACT > AFTERMARKET)

## R5 — Calcul économie
- Calculer le % uniquement si ≥ 2 offres disponibles
- Base = prix le plus élevé

## R6 — Neutralité
- lAwôl ne recommande pas une marque
- lAwôl affiche les options avec transparence

## R7 — Erreurs
- Aucun match :
  - proposer autre mode d’identification
- Erreur IA :
  - fallback OEM / VIN
