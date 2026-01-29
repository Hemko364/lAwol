# lAwôl — API Contracts (MVP)

Ce document décrit les **contrats API minimums**
nécessaires au fonctionnement du MVP lAwôl.

Les endpoints sont conçus pour :
- distinguer **contexte véhicule** et **identification de pièce**
- supporter les **modes Identification / Exploration**
- appliquer les règles SAFE / WARNING / CRITICAL
- rester compatibles avec une future intégration TecDoc

---

## 1️⃣ Identification

### POST /identify/photo
Identifie une pièce à partir d’une photo.

**Body**
```json
{
  "image_base64": "...",
  "vehicle_trim_id": "optional"
}
{
  "cpn_id": "CPN-123",
  "confidence_score": 0.92,
  "candidates": [
    { "cpn_id": "CPN-123", "confidence": 0.92 },
    { "cpn_id": "CPN-456", "confidence": 0.61 }
  ]
}
{
  "reference": "OEM-REF-123",
  "vehicle_trim_id": "optional"
}
{
  "cpn_id": "CPN-123",
  "confidence_score": 1.0
}
{
  "vin": "VF3XXXXXXXXXXXXX"
}
{
  "vehicle_trim_id": "VT-789",
  "vehicle": {
    "make": "Audi",
    "model": "A4",
    "year": 2019,
    "engine": "2.0 TDI"
  },
  "source": "vindecoder"
}
{
  "vehicle_trim_id": "VT-789",
  "intents": [
    {
      "code": "IDENTIFY_PART",
      "label": "Identifier une pièce précise",
      "enabled": true
    },
    {
      "code": "EXPLORE_COMPATIBLE_PARTS",
      "label": "Explorer les pièces compatibles",
      "enabled": true
    }
  ]
}
{
  "vehicle_trim_id": "VT-789",
  "families": [
    {
      "family_id": "FAM-1",
      "name": "Freinage",
      "engine_dependency_flag": "SAFE",
      "requires_confirmation": false
    },
    {
      "family_id": "FAM-2",
      "name": "Filtres",
      "engine_dependency_flag": "WARNING",
      "requires_confirmation": true,
      "ux_message_key": "CONFIRM_ENGINE_VARIANT"
    }
  ]
}
{
  "cpn_id": "CPN-123",
  "label": "Filtre à huile",
  "confidence_score": 0.92,

  "family": {
    "name": "Filtres à huile",
    "engine_dependency_flag": "WARNING",
    "requires_confirmation": true
  },

  "schematic_available": true,

  "vehicles_compatible": [
    {
      "vehicle_trim_id": "VT-789",
      "make": "Audi",
      "model": "A4",
      "year_from": 2018,
      "year_to": 2021,
      "preselected": true
    }
  ],

  "equivalents": [
    {
      "mpn": "BOSCH-XYZ",
      "brand": "Bosch",
      "confidence_score": 0.95
    }
  ],

  "offers": [
    {
      "partner_id": "P-123",
      "mpn": "BOSCH-XYZ",
      "price": 29.90,
      "currency": "EUR",
      "available": true
    }
  ]
}
{
  "mpn": "BOSCH-XYZ",
  "partner_id": "P-123",
  "session_id": "SESSION-456"
}
{
  "status": "ok"
}

---

## Ce que cette mise à jour apporte

- ✔️ Distinction claire VIN / pièce
- ✔️ Support natif Option A / Option B
- ✔️ Flags moteur intégrés à l’API
- ✔️ Frontend 100 % guidé par le backend
- ✔️ API **safe by design**
- ✔️ TecDoc-ready

---



> L’API contract a été mis à jour pour intégrer :  
> - la logique VIN = contexte  
> - les modes Identification / Exploration  
> - les flags SAFE / WARNING / CRITICAL  
> Merci de l’utiliser comme référence.

---


