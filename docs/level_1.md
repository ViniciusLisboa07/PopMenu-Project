## Level 1: Basics

### Overview
Level 1 implements a basic menu system with the following features:
- **Models**:
  - `Menu`: Represents a restaurant menu with attributes `name` (string), `description` (text), and `active` (boolean).
  - `MenuItem`: Represents an item in a menu with attributes `name` (string), `description` (text), `price` (decimal), and a reference to `Menu`.
  - Relationship: A `Menu` has many `MenuItems` (`has_many :menu_items, dependent: :destroy`).
- **Validations**:
  - `Menu`: `name` is required; `description` is required.
  - `MenuItem`: `name`, `price` and `description` required; `price` must be non-negative.
- **Endpoints**:
  - `GET /api/menus`: List all menus with their menu items.
  - `GET /api/menus/:id`: Show a specific menu with its menu items.
  - `POST /api/menus`: Create a new menu.
  - `PUT /api/menus/:id`: Update a menu.
  - `DELETE /api/menus/:id`: Delete a menu.
  - `GET /api/menu_items`: List all menu items.
  - `GET /api/menu_items/:id`: Show a specific menu item.
  - `POST /api/menu_items`: Create a new menu item.
  - `PUT /api/menu_items/:id`: Update a menu item.
  - `DELETE /api/menu_items/:id`: Delete a menu item.
  - **Nested Routes**:
    - `GET /api/menus/:menu_id/menu_items`: List menu items for a specific menu.
    - `POST /api/menus/:menu_id/menu_items`: Create a menu item for a specific menu.
    - `GET /api/menus/:menu_id/menu_items/:id`: Show a specific menu item.
    - `PUT /api/menus/:menu_id/menu_items/:id`: Update a menu item.
    - `DELETE /api/menus/:menu_id/menu_items/:id`: Delete a menu item.
- **Tests**:
  - Request specs (`spec/requests/api/menus_spec.rb` and `spec/requests/api/menu_items_spec.rb`) cover all endpoints.
  - Tests validate success cases (e.g., correct HTTP status, JSON structure) and error cases (e.g., not found, invalid parameters).
  - Database cleanup is handled using Rails' transactional fixtures.

[Back to Main README](../README.md)