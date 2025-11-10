# lawol

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# lAwol
# lAwôl – Spécification fonctionnelle & technique


## 1) Vision produit (MVP)

**lAwôl** est une application qui permet aux particuliers et grossistes & garages d’identifier rapidement des pièces auto et de les acheter via des partenaires (ex. Rockauto), avec suivi simple de commande et de livraison.

**Objectifs MVP **

* Mise en ligne d’un site/app (web responsive) avec parcours d’identification → panier → paiement → redirection partenaire → suivi.
* Back‑office opérateur pour gérer commandes/clients/expéditions.
* Authentification de base (client / garage / admin), paiements via Stripe.
* Optionnel (Phase 1.5) : module IA d’assistance à l’identification (OCR + classification image) en mode beta.

## 2) Personae & rôles

* **Client** (particulier) : cherche une pièce par code VIN/ code OEM/photo& Schéma, passe commande, suit la livraison.
* **Garage** (pro) : mêmes besoins client + gestion multi‑véhicules.
* **Admin/Opérateur** : traite commandes, met à jour expéditions, support.

**Rôles techniques**

* `client` · `garage/grossistes` · `admin` (gestion des autorisations UI/API).

## 3) Parcours utilisateurs (happy paths)

1. **Découverte & Auth**

   * Visite du site → création de compte (email/password, SSO social optionnel) → profil.
2. **Identification de la pièce**

  
   * a) Par **VIN / immatriculation** (champ de recherche) → suggestion de pièces compatibles.
   * b) code OEM
   * c) Par **photo** (optionnel v1.5) → upload → suggestion IA (OCR + vision) → résultat.
   * d)Par **schéma cliquable** (SVG) → sélection composant → liste de pièces.
3. **Commande & paiement**

   * Ajout au panier → **Stripe Checkout** → confirmation → redirection affiliée vers le marchand si besoin.
4. **Suivi & support**

   * Page **Commandes** : statut, transporteur, numéro de suivi, historique.
   * Centre d’aide / création de ticket (email ou formulaire interne).

## 4) Écrans (web responsive)

* Accueil / Recherche
* Identification (schéma | VIN | photo beta)
* Résultats & fiche pièce (réf, compatibilités, dispo, prix, lien partenaire)
* Panier & Paiement (Stripe Checkout)
* Commandes (liste + détail, tracking)
* Profil (coordonnées, adresses, véhicules)
* Admin : Dashboard, Commandes, Clients, Expéditions, Paramètres

## 5) Spécifications fonctionnelles clés

### 5.1 Identification par schéma (prioritaire)

* Composants **SVG cliquables** par famille (freinage, éclairage, filtration…)
* Clic → filtre la liste de pièces (catégorie + compatibilité véhicule si renseignée)

### 5.2 Recherche VIN / immatriculation

* Champ de recherche → fonction edge (filtrage par tables `pieces` / `compatibilites`)
* Normalisation (uppercase, trim, longueur VIN=17)

### 5.3 Upload photo + IA (beta)

* Upload image → stockage temporaire → pipeline OCR (texte OEM) → fallback classification visuelle → suggestion.
* Retour utilisateur si échec (bouton “ça ne correspond pas”).

### 5.4 Panier & paiement

* Panier local (session) + création **Commande** côté backend au moment du paiement.
* **Stripe Checkout** (produits/services ou liens affiliés). Webhooks pour statut paid/failed.

### 5.5 Suivi des expéditions

* Tables **expéditions** et **colis** (transporteur, tracking, événements). Mise à jour par opérateur.

### 5.6 Back‑office opérateur (Retool)

* CRUD **Commandes/Clients/Expéditions** + recherche + actions (changer statut, ajouter tracking).

### 5.7 Authentification & rôles

* Provider d’auth (Clerk/Auth0) ou Auth intégrée du backend. Rôles appliqués aux routes et aux vues UI.

## 6) Architecture & stack (MVP)

* **Frontend** : Next.js (React) déployé sur Vercel · Design system simple · SVG maps.
* **Backend/DB** : Supabase (Postgres, Auth, Storage, Edge Functions) · API REST/SQL.
* **Paiement/Affiliation** : Stripe (Checkout, Webhooks) + redirections partenaires.
* **Admin** : Retool connecté à Supabase.
* **Option IA beta** : Supabase Storage → Edge Functions → Google Vision (OCR) → Roboflow (classification).

### Environnements

* **dev** (préprod) · **prod** (Vercel + Supabase project dédié) · variables d’env chiffrées.

## 7) Modèle de données (proposition)

```
utilisateurs(id, role, email, created_at)
clients(id, user_id, nom, prenom, telephone)
garages(id, user_id, raison_sociale, siret_optional)
vehicules(id, user_id, vin, immatriculation, marque, modele, annee)
pieces(id, ref_oem, nom, categorie, prix, fournisseur, lien_affilie)
compatibilites(id, piece_id, vin_prefix, marque, modele, annee_min, annee_max)
commandes(id, user_id, total, devise, statut, stripe_session_id, created_at)
ligne_commandes(id, commande_id, piece_id, quantite, prix_unitaire)
expeditions(id, commande_id, transporteur, tracking, statut, eta)
colis(id, expedition_id, poids, dimensions, statut)
retours(id, commande_id, motif, statut)
logs(id, type, payload_json, created_at)
```

## 8) API (brouillon de routes)

**Public**

* `POST /auth/signup` · `POST /auth/signin`
* `GET /pieces?categorie=&vin=&q=` (recherche)
* `POST /upload` (photo) → `POST /identify` (retour IA)

**Sécurisé (token requis)**

* `GET /me` (profil) · `PUT /me`
* `POST /cart` (local côté front, mais création de commande côté backend au checkout)
* `POST /checkout` → crée session Stripe
* `POST /webhooks/stripe` (paiement events)
* `GET /commandes` · `GET /commandes/:id`
* `GET /expeditions/:commande_id`

**Admin** (role=`admin`)

* CRUD sur `pieces`, `compatibilites`, `commandes`, `expeditions`

## 9) Sécurité & conformité

* Tokens courts, refresh sécurisé, rotation des clés.
* Webhooks Stripe signés, validation de signature.
* Stockage d’images en bucket privé, URLs signées temporaires.
* Journalisation (table `logs`) + monitoring basique.

## 10) Intégrations externes & secrets

* **Stripe** : clés live/test, produits/services, webhooks.
* **Clerk/Auth0** (si utilisé) : clés API + configuration des rôles.
* **Google Vision / Roboflow** (si IA beta) : clés API via variables d’env.

## 11) Analytique & observabilité

* Événements clés : signup, recherche, ajout panier, checkout, paiement_succeeded, shipment_updated.
* Table `logs` + (option) PostHog/Amplitude v2.

## 12) Roadmap & jalons

* **Sprint 1** (Semaine 1–2) : Setup repo, CI/CD, Auth, schémas SVG, tables de base.
* **Sprint 2** (Semaine 3–4) : Recherche VIN, liste/fiche pièce, panier, Stripe Checkout.
* **Sprint 3** (Semaine 5–6) : Suivi commandes/expéditions, Retool admin.
* **Sprint 4** (Semaine 7–8) : IA photo (beta), feedback, hardening, launch.

## 13) Déploiement & CI/CD

* GitHub → Vercel (front) · Supabase migrations SQL versionnées · Lint/format/test.
* Branching : `main` (prod), `develop` (préprod), PRs obligatoires.

## 14) Definition of Done (exemples)

* Tests unitaires critiques verts · Accessibilité AA de base · Perf LCP < 2.5s page clé.
* Parcours commande complet testé (happy path) en préprod.

---

**Notes pour le dev**

* Fournir un `.env.example` (STRIPE_SECRET_KEY, SUPABASE_URL, SUPABASE_ANON_KEY, …)
* Commencer par les schémas SVG + recherche (impact UX maximal) avant IA.
* Back‑office Retool en parallèle (accélère l’opérationnel).


