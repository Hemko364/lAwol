# lAwôl — API Contracts (MVP)

## Identification
POST /identify/photo
POST /identify/oem
POST /identify/vin

Response:
{
  "cpn": "CPN-123",
  "confidence": 0.92,
  "candidates": []
}

## Résultats
GET /results/{cpn}?vehicle_trim_id=

Response:
{
  "cpn": "...",
  "schematic": true,
  "vehicles": [],
  "equivalents": [],
  "offers": []
}

## Affiliation
POST /affiliate/click
Body:
{
  "mpn": "...",
  "partner_id": "...",
  "session_id": "..."
}
