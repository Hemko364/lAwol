# lAwôl — Data Model (MVP)

## Tables principales

### parts_canonical
- id (CPN)
- label
- category
- family
- criticality

### parts_variant
- mpn
- cpn_id
- brand
- supplier
- oem_reference
- ean_gtin
- interchange_type
- confidence_score

### fitment
- id
- cpn_id
- vehicle_trim_id
- year_from
- year_to
- confidence_score

### interchange
- id
- cpn_id
- mpn_source
- mpn_equivalent
- status
- confidence_score

### partners
- id
- name
- country
- affiliate_type

### partner_products
- mpn
- partner_id
- product_url

### affiliate_clicks
- id
- user_session
- mpn
- partner_id
- timestamp
