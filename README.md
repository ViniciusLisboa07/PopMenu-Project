# 👩🏻‍🍳 Popmenu Interview Project

This repository contains the implementation of the Popmenu Interview Project, a RESTful API for managing restaurant menus and menu items. The project is built with **Ruby on Rails**, uses **PostgreSQL** as the database, and is containerized with **Docker** using **docker-compose**. Tests are written with **RSpec** and use **FactoryBot** and **Faker** for test data.

Features

Level 1: Basic menu system with Menu and MenuItem models, RESTful endpoints, and validations.

Level 2: Adds Restaurant model, many-to-many relationship between Menu and MenuItem, and nested routes.

Level 3: Implements JSON import endpoint (POST /api/import) to process restaurant data, with detailed logging and error handling.

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
   git clone https://github.com/ViniciusLisboa07/PopMenu-Project.git
   cd PopMenu-Project
2. make build
3. make migrate
4. make up
