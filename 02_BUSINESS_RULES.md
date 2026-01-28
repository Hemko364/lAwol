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


## R0 — Rôle de l’IA

- L’intelligence artificielle est utilisée comme **moteur de pré-identification**, jamais comme une vérité absolue.
- L’IA a pour rôle de :
  - analyser la photo fournie par l’utilisateur,
  - proposer une **pièce canonique (CPN)** probable,
  - retourner un **score de confiance (confidence_score)**,
  - fournir, le cas échéant, des **candidats alternatifs**.

L’IA ne valide jamais seule une pièce.  
Toute décision finale est **assistée** par :
- les schémas (si disponibles),
- les compatibilités véhicules,
- les équivalences inter-marques.

---

## R0.1 — Seuil de confiance IA

Un seuil de confiance est défini afin d’encadrer le comportement du produit.

- **confidence_score ≥ 0.8**
  - La pré-identification est considérée comme suffisamment fiable.
  - Affichage direct du résultat sur l’écran Résultats.

- **0.5 ≤ confidence_score < 0.8**
  - Le résultat est jugé incertain.
  - L’utilisateur doit confirmer l’identification proposée
    (ex. : “Est-ce bien cette pièce ?”).

- **confidence_score < 0.5**
  - L’identification est considérée comme non fiable.
  - Aucun résultat n’est affiché.
  - Fallback vers :
    - saisie manuelle de la référence OEM,
    - identification par VIN,
    - ou nouvelle prise de photo.

Ces seuils sont **pour le MVP** et pourront être ajustés
en fonction des données d’usage et des retours terrain.

---

## R0.2 — Fallback photo de mauvaise qualité

- Si la qualité de la photo est insuffisante (floue, mal cadrée, luminosité insuffisante) :
  - aucune tentative d’identification n’est effectuée,
  - l’utilisateur est invité à reprendre la photo.
- Le message affiché doit expliquer simplement la raison
  (ex. : netteté, cadrage ou lumière insuffisante).
- Aucun résultat approximatif ne doit être présenté.

## R3 — Logique VIN et choix d’intention

- Le VIN définit un **contexte véhicule fiable**.
- Le VIN ne doit jamais déclencher automatiquement :
  - une recherche de pièce,
  - un affichage de compatibilités validées,
  - ou un affichage de prix.

Après saisie du VIN :
- lAwôl affiche le véhicule identifié (marque, modèle, année, motorisation si disponible)
- lAwôl demande explicitement l’intention de l’utilisateur

  ### R3.1 — Cas A : Identifier une pièce précise

- L’utilisateur initie une identification par :
  - scan de pièce
  - ou référence OEM
- Le véhicule issu du VIN est **pré-sélectionné** comme contexte
- La liste complète des véhicules compatibles avec la pièce reste visible
- L’utilisateur peut changer de véhicule à tout moment
- Les équivalences inter-marques et les offres partenaires
  sont affichées selon les règles SAFE / WARNING / CRITICAL

  ### R3.2 — Cas B : Explorer les pièces compatibles

- L’utilisateur n’identifie pas de pièce précise
- lAwôl se limite à une **exploration guidée**, sans déclencher de décision

Comportement :
- lAwôl affiche le véhicule identifié via le VIN
- lAwôl affiche les véhicules partageant des pièces compatibles
- lAwôl propose un bouton :
  "Voir les pièces courantes compatibles"

Règles d’affichage :
- l’affichage se limite à des **familles de pièces à forte valeur**
  (ex. filtres, freinage, entretien)
- seules les familles SAFE et WARNING sont affichables
- les familles CRITICAL ne sont jamais affichées en mode exploration
- aucun panier, prix ou paiement n’est affiché à ce stade





    
