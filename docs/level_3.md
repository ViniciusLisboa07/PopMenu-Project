# Level 3: JSON File Support

## Overview
Level 3 adds support for importing restaurant, menu, and menu item data from a JSON file:
- **Models**:
  - Updated `Menu` and `MenuItem`: Made `description` optional to align with `restaurant_data.json`.
- **Endpoint**:
  - `POST /api/import`: Accepts a JSON payload, processes it, and returns logs and status.
- **Service**:
  - `ImportService`: Parses JSON, creates or updates restaurants, menus, and menu items, and generates detailed logs for each operation.
  - Handles `menu_items` and `dishes` keys, duplicate `MenuItem` names (e.g., "Chicken Wings"), and missing fields.
  - Uses transactions for atomicity.
- **Validations**:
  - Ensures `name` and `price` are present for `MenuItem`s.
  - Logs errors for invalid data (e.g., missing names, negative prices).
- **Tests**:
  - Request specs (`spec/requests/api/imports_spec.rb`) test the import endpoint for valid JSON, duplicates, invalid JSON, and empty arrays.
  - Service specs (`spec/services/import_service_spec.rb`) test `ImportService` logic, including duplicate handling and error cases.
- **Database**:
  - Migration to make `description` optional in `menus` and `menu_items` tables.

## Running Level 3 Tests
```bash
docker-compose run web rspec spec/requests/api/imports_spec.rb spec/services/import_service_spec.rb
```

## Testing the Import Endpoint
Use the provided `restaurant_data.json`:
```bash
curl -X POST http://localhost:3000/api/import \
  -H "Content-Type: application/json" \
  -d @restaurant_data.json
```

Example response:
```json
{
  "logs": [
    "Restaurant 'Poppo's Cafe' created or found successfully",
    "Menu 'lunch' created or found for restaurant 'Poppo's Cafe'",
    "Processing MenuItem 'Burger' (index 0) for menu 'lunch'",
    "MenuItem 'Burger' created with price 9.0",
    "MenuItem 'Burger' associated with menu 'lunch'",
    "Processing MenuItem 'Chicken Wings' (index 0) for menu 'lunch'",
    "MenuItem 'Chicken Wings' created with price 9.0",
    "MenuItem 'Chicken Wings' associated with menu 'lunch'",
    "Processing MenuItem 'Chicken Wings' (index 1) for menu 'lunch'",
    "MenuItem 'Chicken Wings' already associated with menu 'lunch'"
  ],
  "status": "success"
}
```

## Notes
- Handles duplicate `MenuItem`s (e.g., "Chicken Wings" in the same menu) by associating only once, with clear logs.
- Logs every `MenuItem` attempt, including index for traceability.
- Updates prices for existing `MenuItem`s when different prices are provided.
- Logs are returned in the response and written to `log/development.log`.
- See PR #2 for details: [Pull Request #2](https://github.com/ViniciusLisboa07/PopMenu-Project/pull/2)

[Back to Main README](../README.md)