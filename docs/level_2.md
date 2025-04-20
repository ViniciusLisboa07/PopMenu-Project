# Level 2: Restaurants and Multiple Menus

## Overview
Level 2 extends the menu system by introducing restaurants and a more flexible menu-item relationship:
- **Models**:
  - `Restaurant`: Represents a restaurant with attribute `name` (string).
  - Updated `Menu`: Now belongs to a `Restaurant` (`belongs_to :restaurant`) and has many `MenuItems` through `MenuMenuItem`.
  - Updated `MenuItem`: Has many `Menus` through `MenuMenuItem`.
  - `MenuMenuItem`: Join table for the many-to-many relationship between `Menu` and `MenuItem`.
- **Validations**:
  - `Restaurant`: `name` is required.
  - `MenuItem`: `name` is unique globally to avoid duplicates across menus.
- **Endpoints**:
  - `GET /api/restaurants`: List all restaurants with their menus.
  - `GET /api/restaurants/:id`: Show a specific restaurant with its menus.
  - `POST /api/restaurants`: Create a new restaurant.
  - `PUT /api/restaurants/:id`: Update a restaurant.
  - `DELETE /api/restaurants/:id`: Delete a restaurant.
  - **Nested Routes**:
    - `GET /api/restaurants/:restaurant_id/menus`: List menus for a specific restaurant.
    - `POST /api/restaurants/:restaurant_id/menus`: Create a menu for a specific restaurant.
- **Tests**:
  - Request specs (`spec/requests/api/restaurants_spec.rb`) cover restaurant endpoints.
  - Updated specs (`spec/requests/api/menus_spec.rb`, `spec/requests/api/menu_items_spec.rb`) test the many-to-many relationship.
  - Model specs validate uniqueness of `MenuItem` names and relationships.
- **Database**:
  - Added `restaurants` table and `menu_menu_items` join table.
  - Updated `menus` table to include `restaurant_id`.

## Running Level 2 Tests
```bash
docker-compose run web rspec spec/requests/api/restaurants_spec.rb spec/requests/api/menus_spec.rb spec/requests/api/menu_items_spec.rb
```

## Notes
- The many-to-many relationship allows a `MenuItem` to appear in multiple `Menus` (e.g., "Burger" in both lunch and dinner menus).
- Uses FactoryBot for test fixtures and RSpec for request and model specs.
- See PR #1 for details: [Pull Request #1](https://github.com/ViniciusLisboa07/PopMenu-Project/pull/1)

[Back to Main README](../README.md)