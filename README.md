# 👩🏻‍🍳 Popmenu Interview Project

This repository contains the implementation of the Popmenu Interview Project, a RESTful API for managing restaurant menus and menu items. The project is built with **Ruby on Rails**, uses **PostgreSQL** as the database, and is containerized with **Docker** using **docker-compose**. Tests are written with **RSpec** and use **FactoryBot** and **Faker** for test data.

The project follows an iterative approach, with each level implemented in separate commits and pull requests to reflect incremental development. This README documents the progress up to **Level 1**.

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

## Level 2: Restaurants | Multiple Menus
The complete description of Level 2 implementation:
https://github.com/ViniciusLisboa07/PopMenu-Project/pull/1

## Level 3: Json file support

### Technologies
- **Ruby**: 3.3.5
- **Rails**: 7.2.x
- **Database**: PostgreSQL 15
- **Testing**: RSpec, FactoryBot, Faker
- **Containerization**: Docker, Docker Compose

## Setup

### Prerequisites
- **Docker** and **Docker Compose** installed.
- A GitHub repository to push the code.

### Installation
1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd popmenu-interview
2. make build
3. make up
