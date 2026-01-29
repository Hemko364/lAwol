# lAwôl — MVP Repository (V2)

Bienvenue dans le repository du **MVP lAwôl**.

lAwôl est un **assistant d’identification de pièces automobiles**, neutre et non marchand,
conçu pour permettre à un utilisateur d’identifier une pièce **sans expertise mécanique**
et de **comprendre avant d’acheter**.

lAwôl intervient **avant l’acte d’achat** et redirige vers des partenaires marchands
via un modèle d’affiliation.

⚠️ **Cette V2 du MVP ne gère ni vente, ni paiement, ni logistique.**

---

## 🎯 Objectif du MVP

Le MVP a pour objectif de démontrer que :
- une pièce automobile peut être identifiée sans expertise,
- la compatibilité peut être comprise avant toute décision,
- les équivalences inter-marques peuvent être expliquées clairement,
- les erreurs de commande peuvent être réduites en amont.

---

## 🧠 Principe fondamental

> **L’utilisateur fournit ce qu’il a.  
> lAwôl fournit ce qui lui manque.**

- La complexité est absorbée par le produit.
- L’utilisateur n’a pas besoin d’être mécanicien.
- Toute identification converge vers une **pièce canonique (CPN)**.

---

## 🧩 Principes produit (à ne jamais casser)

- **La pièce est au centre**, pas le véhicule.
- Le **VIN définit un contexte**, jamais une décision automatique.
- L’utilisateur **choisit explicitement son intention**.
- L’IA **assiste**, elle ne décide pas seule.
- Aucune compatibilité critique n’est validée sans confirmation.

---

## 🔁 Parcours principaux du MVP

### 1️⃣ Identification par scan de pièce
- Photo → analyse IA
- Pré-identification avec score de confiance
- Affichage des véhicules compatibles
- Comparaison des équivalences inter-marques
- Redirection vers partenaires (si confirmé)

### 2️⃣ Identification par VIN
Après saisie du VIN :
- le véhicule est identifié (contexte),
- l’utilisateur choisit son intention :

**Option A — Identifier une pièce précise**  
Scanner une pièce ou entrer une référence OEM.

**Option B — Explorer les pièces compatibles**  
Explorer des **familles de pièces à forte valeur**
(filtres, freinage, entretien), sans achat.

---

## 🚦 Logique moteur & sécurité

Les familles de pièces sont classées selon leur dépendance
à la motorisation :

- **SAFE** → affichage direct
- **WARNING** → confirmation requise
- **CRITICAL** → scan ou OEM obligatoire

👉 Cette logique est **centrale pour la fiabilité du produit**.

---

## 📁 Documentation — Source de vérité

Toute la logique produit, métier et technique se trouve dans `/docs`.

### Ordre de lecture recommandé
1. [`01_MVP_SPEC.md`](docs/01_MVP_SPEC.md)  
   Vision, périmètre MVP, parcours utilisateur.

2. [`02_BUSINESS_RULES.md`](docs/02_BUSINESS_RULES.md)  
   Règles métier et comportements attendus.

3. [`03_PARTS_FAMILY_FLAGS.md`](docs/03_PARTS_FAMILY_FLAGS.md)  
   **Source de vérité** pour SAFE / WARNING / CRITICAL.

4. [`04_API_CONTRACT.md`](docs/04_API_CONTRACT.md)  
   Contrat API attendu par le frontend.

5. [`05_DB_SCHEMA_MIN.md`](docs/05_DB_SCHEMA_MIN.md)  
   Schéma DB minimal du MVP.

---

## 🛠️ Règles de contribution

- Aucune logique métier ne doit être codée sans référence à `/docs`.
- En cas de doute, **la documentation fait foi**.
- Toute modification impactant les parcours ou règles
  doit mettre à jour les fichiers concernés dans `/docs`.

---

## 🔑 Mantra produit

> **Comprendre avant d’acheter.**

lAwôl n’est pas un site e-commerce.  
C’est une **couche de décision** placée avant l’achat.

---

## 📌 Statut du projet

- MVP en cours de développement
- Cible initiale : France
- Architecture compatible TecAlliance / TecDoc (V2)

---

## 📁 Structure du repository

```txt
/
├── docs/                # Source de vérité produit & métier
│   ├── 01_MVP_SPEC.md
│   ├── 02_BUSINESS_RULES.md
│   ├── 03_PARTS_FAMILY_FLAGS.md
│   ├── 04_API_CONTRACT.md
│   └── 05_DB_SCHEMA_MIN.md
├── src/                 # Code applicatif
├── README.md            # Ce fichier
└── CODEOWNERS           # Validation des specs (optionnel)
