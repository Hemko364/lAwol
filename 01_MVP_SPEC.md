# lAwôl — MVP Specification (Final)

## 0. Objectif du MVP
Construire un hub d’identification de pièces automobiles permettant :
- d’identifier une pièce sans expertise mécanique,
- de sécuriser la compatibilité,
- de révéler les équivalences inter-marques,
- d’optimiser le choix économique,
- de rediriger vers des partenaires (affiliation).

Le MVP ne doit PAS gérer la vente, le paiement ou la logistique.

---

## 1. Scope MVP

### IN
- Identification par photo (IA)
- Identification par référence OEM
- Identification par VIN / immatriculation
- Écran Résultats unique (quel que soit le mode d’entrée)
- Schéma comme outil d’assistance (si disponible)
- Compatibilités multi-véhicules
- Équivalences inter-marques
- Calcul du % d’économie
- Liens affiliés partenaires
- Tracking des clics

### OUT
- Paiement in-app
- Logistique lAwôl
- Couverture exhaustive marques / pièces
- Historique prix long terme
- Comptes garages avancés

---

## 2. Entrées utilisateur

L’utilisateur peut initier une identification via :
- Photo de la pièce (caméra ou galerie)
- Référence OEM / MPN
- VIN / immatriculation

⚠️ Le schéma n’est PAS une entrée utilisateur.

---

## 3. Principe fondamental
> L’utilisateur fournit ce qu’il a.  
> lAwôl fournit ce qui lui manque.

Toute identification converge vers une **pièce canonique (CPN)**.

---

## 4. Parcours utilisateur

### Flow A — Photo
1. Choix : caméra ou galerie
2. Upload image
3. IA → pré-identification (CPN + confidence)
4. Affichage écran Résultats

### Flow B — OEM
1. Saisie référence
2. Résolution vers CPN
3. Affichage écran Résultats

### Flow C — VIN
1. Saisie VIN
2. Décodage véhicule
3. Résolution CPN
4. Affichage écran Résultats

   ## 3.1 — Identification par VIN : Choix d’intention (UX différenciante)

Lorsque l’utilisateur fournit un VIN, lAwôl identifie le véhicule
(marque, modèle, année, motorisation).

Le VIN définit un **contexte véhicule**, mais pas une intention utilisateur.

Après identification du véhicule, lAwôl affiche un écran intermédiaire
permettant à l’utilisateur de préciser son intention.

### Question affichée
**Que souhaitez-vous faire ?**

### Options proposées

#### Option A — Identifier une pièce précise (ACTIVE — MVP)
- L’utilisateur dispose d’une pièce à identifier
- Actions disponibles :
  - Scanner une pièce
  - Entrer une référence OEM

Cette option déclenche le parcours MVP principal
(VIN → scan de pièce → résultats).

#### Option B — Explorer les pièces compatibles avec ce véhicule (ACTIF — MVP PROGRESSIF)

- L’utilisateur ne dispose pas d’une pièce précise à identifier
- L’utilisateur souhaite comprendre quelles pièces sont compatibles avec son véhicule
- Cette option s’appuie sur le véhicule identifié via le VIN

Bouton :
- **Voir les pièces courantes compatibles**

Comportement attendu :
- L’application affiche une sélection de **familles de pièces à forte valeur**
- Ces familles sont choisies pour leur :
  - fréquence de remplacement
  - faible risque d’erreur
  - pertinence pour une première exploration

Exemples de familles affichées :
- filtres
- freinage
- entretien courant

⚠️ ATTENTION :
- Il ne s’agit **pas d’un catalogue exhaustif**
- Seules des **familles de pièces à forte valeur** sont affichées
- Aucun panier, paiement ou commande n’est affiché à ce stade

Objectif :
- Introduire la logique de standardisation des pièces
- Permettre à l’utilisateur de comprendre avant d’acheter
- Préparer la décision sans la déclencher
## 5. Écran Résultats (invariant)

L’écran Résultats est IDENTIQUE pour tous les flows.
