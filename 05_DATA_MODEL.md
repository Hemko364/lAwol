# lAwôl — Data Model (MVP)

Ce document décrit le **modèle de données minimal**
nécessaire au fonctionnement du MVP lAwôl.

Le modèle est conçu pour :
- placer la **pièce canonique (CPN)** au centre,
- supporter la logique **multi-véhicules**,
- appliquer les règles **SAFE / WARNING / CRITICAL**,
- rester compatible avec une future intégration TecDoc.

---

## 1️⃣ Tables principales

### parts_canonical
Représente une **fonction mécanique unique**, indépendante de toute marque.

- id (UUID) — **CPN**
- label
- category
- family_id → part_family.id
- created_at

 Toute identification converge vers une CPN.

---

###  parts_variant
Représente une **référence réelle** (OEM ou aftermarket).

- mpn (PRIMARY KEY)
- cpn_id → parts_canonical.id
- brand
- supplier
- oem_reference
- ean_gtin
- interchange_type  
  (`OEM_EXACT | AFTERMARKET_EQUIVALENT`)
- confidence_score
- created_at

---

### 🔗 fitment
Lien entre une **CPN** et un **véhicule**.

- id (UUID)
- cpn_id → parts_canonical.id
- vehicle_trim_id → vehicle_trim.id
- year_from
- year_to
- confidence_score
- source (`internal | vin | manufacturer | tecdoc`)

Utilisé pour :
- afficher les véhicules compatibles
- alimenter l’Option B (exploration)

---

### interchange
Équivalences entre références.

- id (UUID)
- cpn_id → parts_canonical.id
- mpn_source
- mpn_equivalent
- status (`PENDING | VALIDATED`)
- confidence_score
- validated_by (`system | human`)
- created_at

---

## 2️⃣ Classification moteur (clé MVP)

### part_family
Définit la **dépendance moteur** d’une famille de pièces.

- id (UUID)
- name
- engine_dependency_flag  
  (`SAFE | WARNING | CRITICAL`)
- created_at

 **Source de vérité** pour le comportement UX / API  
(voir `04_PARTS_FAMILY_FLAGS.md`).

---

## 3️⃣ Véhicules & VIN

### vehicle_make
- id
- name

### 🚙 vehicle_model
- id
- make_id → vehicle_make.id
- name

### vehicle_trim
Représente une variante véhicule exploitable par le MVP.

- id (UUID)
- model_id → vehicle_model.id
- year_from
- year_to
- engine_code (nullable)
- fuel_type (nullable)
- source (`manual | vin | tecdoc`)
- created_at

---

### vin_decode_cache
Cache des décodages VIN.

- vin_hash (PRIMARY KEY)
- provider (`vindecoder | tecdoc`)
- provider_vehicle_id (nullable)
- make
- model
- year
- engine (nullable)
- decoded_at
- expires_at

 Le VIN brut ne doit jamais être stocké.

---

## 4️⃣ Partenaires & affiliation

### partners
- id
- name
- country
- affiliate_type
- created_at

---

### partner_products
Mapping entre une référence et un partenaire.

- mpn
- partner_id → partners.id
- product_url
- last_checked_at

---

### affiliate_clicks
Tracking affiliation.

- id (UUID)
- user_session
- mpn
- partner_id
- timestamp

---

## 5️⃣Règles de cohérence (à respecter)

- Une **CPN** peut avoir plusieurs `parts_variant`
- Une **CPN** peut être liée à plusieurs `vehicle_trim`
- La compatibilité moteur dépend exclusivement de  
  `part_family.engine_dependency_flag`
- Aucune logique moteur ne doit être codée en dur côté frontend
- Le VIN fournit un contexte, jamais une compatibilité validée

---

## 6️⃣ Compatibilité future TecDoc

Le modèle est compatible avec TecDoc via :
- `provider_vehicle_id` dans `vin_decode_cache`
- `source = tecdoc` dans `vehicle_trim` et `fitment`

Aucune migration lourde ne sera nécessaire.

