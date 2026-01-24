# lAwôl — MVP Repository

Bienvenue dans la V2 du repository du **MVP lAwôl**.

Ce projet vise à construire un **assistant d’identification de pièces automobiles**, neutre et non marchand, permettant à un utilisateur d’identifier une pièce **sans expertise mécanique**, puis de prendre une **décision éclairée** avant l’achat via affiliation. 

---

## Objectif du projet

lAwôl permet :
- d’identifier une pièce automobile (photo IA, OEM, VIN),
- de sécuriser la compatibilité,
- de révéler les équivalences inter-marques,
- d’optimiser le choix économique,
- de rediriger vers des partenaires marchands (affiliation).

⚠️ **Cette V2 du MVP ne gère ni vente, ni paiement, ni logistique.**

---

##  Principe fondamental

> **L’utilisateur fournit ce qu’il a.  
> lAwôl fournit ce qui lui manque.**

- L’utilisateur n’a pas besoin d’être mécanicien.
- La complexité est absorbée par le produit.
- Toute identification converge vers une **pièce canonique (CPN)**.

### UX différenciante lAwôl — Identification par VIN

Contrairement aux sites classiques, lAwôl ne lance pas automatiquement
une recherche de pièces après la saisie d’un VIN.

Le VIN sert à définir un contexte véhicule.
L’utilisateur précise ensuite son intention.

---

## 📁 Structure du repository

```txt
/
├── docs/                # Source de vérité produit & métier
│   ├── 01_MVP_SPEC.md
│   ├── 02_BUSINESS_RULES.md
│   ├── 03_DATA_MODEL.md
│   └── 04_API_CONTRACTS.md
├── src/                 # Code applicatif
├── README.md            # Ce fichier
└── CODEOWNERS           # Validation des specs (optionnel)
