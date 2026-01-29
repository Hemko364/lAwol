# Parts Family Flags — lAwôl (SAFE / WARNING / CRITICAL)

## Principe fondamental (à graver)
Chaque **famille de pièces** possède un flag `engine_dependency_flag` qui détermine :
- ce que l’application peut afficher automatiquement,
- ce que l’utilisateur doit confirmer,
- ce qui doit être bloqué sans scan/OEM.

Mantra :
**SAFE → afficher**
**WARNING → confirmer**
**CRITICAL → bloquer**

---

## 1) Définitions

### SAFE
**Compatibilité peu ou pas dépendante** de la motorisation fine.
- Compatibilités affichables directement
- Pas de confirmation moteur requise

### WARNING
Compatibilité **potentiellement dépendante** de la motorisation.
- Famille visible
- Compatibilité non validée automatiquement
- Confirmation requise : scan de pièce ou référence OEM

### CRITICAL
Compatibilité **directement dépendante** de la motorisation / variantes fines.
- Aucun auto-match fiable
- Scan de pièce ou référence OEM obligatoire
- Affichage bloquant si pas de confirmation

---

## 2) Règles produit (comportement)

### Règle R6.1 — SAFE
- `auto_compatible = true`
- afficher fitment + équivalences + offres (si pièce identifiée)

### Règle R6.2 — WARNING
- `auto_compatible = false`
- afficher la famille
- afficher un message “confirmation requise”
- demander scan/OEM pour confirmer avant d’afficher compatibilité finale + offres

### Règle R6.3 — CRITICAL
- `auto_compatible = false`
- ne pas afficher de compatibilité “validée”
- bloquer l’accès aux offres tant qu’aucune confirmation (scan/OEM) n’est fournie

---

## 3) Liste des familles (MVP)

### SAFE
- Freinage (disques, plaquettes)
- Pneus
- Filtres habitacle
- Suspension (hors versions sport)
- Direction mécanique
- Roulements
- Bras / triangles / silentblocs
- Carrosserie standard
- Éléments intérieurs

### WARNING
- Filtres à air
- Filtres à huile
- Bougies
- Capteurs génériques
- Échappement (hors catalyseur)
- Batterie (cas spécifiques)

### CRITICAL
- Pièces moteur internes
- Turbo / compresseur
- Injection
- Distribution (courroie / chaîne)
- Embrayage / volant moteur
- Catalyseur / FAP
- Pompes (huile / carburant)
- ECU / gestion moteur

---

## 4) Messages UX (requis)

### WARNING (message)
"Plusieurs variantes possibles selon la motorisation. Scannez la pièce ou entrez la référence pour confirmer."

### CRITICAL (message bloquant)
"Cette pièce dépend de la motorisation exacte. Une confirmation est nécessaire avant toute compatibilité."

---
## 5) Tests d’acceptation (QA)

- Une famille SAFE n’affiche jamais un message WARNING/CRITICAL.
- Une famille WARNING ne montre pas d’offres tant qu’aucune confirmation n’est faite.
- Une famille CRITICAL bloque la compatibilité tant qu’aucune confirmation n’est faite.
