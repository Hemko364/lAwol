# lAwôl — Backlog & Sprint Planning (MVP)

## 1. Brainstorming & Analyse des Écarts

### État Actuel vs MVP
- **Authentification** : En place (`auth_service`, `login_screen`).
- **Scan/IA** : En place (`gemini_service`, `scanner_screen`), mais le prompt doit être aligné avec le concept de CPN (Pièce Canonique).
- **Recherche** : Écrans existants, mais besoin d'intégrer les flux OEM et VIN.
- **Hors Scope** : Le dossier `orders/` et les fonctionnalités de commande doivent être retirés ou désactivés (Scope OUT).
- **Manquant** :
    - Logique de résolution CPN (Canonical Part Number).
    - Base de données locale ou Firebase structurée selon `03_DATA_MODEL.md`.
    - Écran de Résultats unifié avec les sections Schéma, Compatibilité, et Équivalences.
    - Gestion de l'affiliation (Liens partenaires et Tracking).

### Modifications Requises
1.  **Suppression** : Retirer l'écran "Commandes" (`orders_screen`) de la navigation principale.
2.  **Refonte Gemini** : Adapter le prompt pour retourner une structure compatible avec `parts_canonical` (ou un mapping intermédiaire).
3.  **Data** : Implémenter les collections Firestore correspondant au Data Model.

---

## 2. Product Backlog

### Epic 1 : Core Identification (Le "Cerveau")
- **ST-101** : Configurer la structure Firestore (`parts_canonical`, `parts_variant`, `fitment`).
- **ST-102** : Améliorer le Service Gemini pour cibler l'identification de CPN (Prompt Engineering).
- **ST-103** : Implémenter la recherche par Référence OEM (Input texte -> Résolution CPN).
- **ST-104** : Implémenter la recherche par VIN (Input VIN -> Décodage Véhicule -> Filtre CPN).

### Epic 2 : Expérience Utilisateur (UI/UX)
- **ST-201** : Créer l'Écran de Résultats Unifié (Squelette commun pour Photo/OEM/VIN).
- **ST-202** : Afficher le bloc "Schéma Technique" (Conditionnel : si disponible pour le CPN).
- **ST-203** : Afficher la liste de compatibilité (Véhicules "Fitment").
- **ST-204** : Désactiver/Masquer les écrans hors-scope (Orders).

### Epic 3 : Moteur d'Équivalences & Affiliation
- **ST-301** : Implémenter la logique d'Interchange (Affichage des équivalents inter-marques validés).
- **ST-302** : Intégrer les offres partenaires (Affichage prix et liens).
- **ST-303** : Calculer et afficher le pourcentage d'économie (Règle R5).
- **ST-304** : Tracker les clics sortants (`affiliate_clicks`).

---

## 3. Sprint Planning

### Sprint 1 : Fondations & Identification Visuelle (Focus : "Ça marche ?")
**Objectif** : L'utilisateur peut prendre une photo et obtenir une identification de pièce correcte.
- **Tasks** :
    - [ ] Setup Firestore collections (ST-101).
    - [ ] Refonte Prompt Gemini pour CPN (ST-102).
    - [ ] Nettoyage UI (Suppression Orders) (ST-204).
    - [ ] Écran Résultats V1 (Nom de la pièce + Confiance) (ST-201 partial).

### Sprint 2 : Diversification des Entrées (Focus : "Je peux tout scanner")
**Objectif** : L'utilisateur peut utiliser une référence ou un VIN si la photo échoue.
- **Tasks** :
    - [ ] Recherche par OEM (ST-103).
    - [ ] Recherche par VIN (ST-104).
    - [ ] Intégration Schémas Techniques (ST-202).
    - [ ] Affichage Compatibilité Véhicules (ST-203).

### Sprint 3 : Valeur & Monétisation (Focus : "Je fais une bonne affaire")
**Objectif** : L'utilisateur voit les équivalences et les meilleures offres.
- **Tasks** :
    - [ ] Moteur d'équivalences (ST-301).
    - [ ] Affichage Offres Partenaires (ST-302).
    - [ ] Calcul Économie (ST-303).
    - [ ] Tracking Affiliation (ST-304).
