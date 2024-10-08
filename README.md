# Echo Server Tech Challenge (Babbel)

### API documentation
[Details](https://documenter.getpostman.com/view/9180978/2sAXxPAsgo)

### Stack
| Description                     | Name            | Documentation                                          |
| ------------------------------- |:--------------: | :----------------------------------------------------: |
| Web Server                      | Puma            | [link](https://puma.io/)                               |
| Framework                       | Rails           | [link](https://rubyonrails.org/)                       |
| API                             | Grape           | [link](https://github.com/ruby-grape/grape)            |
| ORM                             | Activerecord    | [link](https://guides.rubyonrails.org/active_record_basics.html) |
| Service composition             | ServiceActor    | [link](https://github.com/sunny/actor)                 |


### Key Features:

- **Dynamic endpoint creation**: Easily create mock HTTP endpoints that respond with predefined data.
- **Endpoint management**: Update and delete existing endpoints.
- **Grape API**: Built using the Grape framework for rapid API development.
- **Authentication**: Secured API requests with API keys.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [Running Tests](#running-tests)
- [Available Endpoints](#available-endpoints)
- [Authentication](#authentication)


## Prerequisites

Make sure you have the following installed before setting up the project:

- Ruby version `3.0.1`
- Rails version `6.1.7.8`
- PostgreSQL for the database
- Bundler: `gem install bundler`

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/echo_server.git
   cd echo_server
   ```
   
2. **Install dependencies**:

    ```bash
    bundle install
    ```
   
## Database Setup
1. **Create the database**:

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

## Running the Application

1. **Start the Rails server**:

To start the Rails server on http://localhost:3000, use the following command:
 ```bash
  rails s
 ```

The server will run using Puma and listen on port 3000 by default.

2. **Check app up and running**:

Open url in local browser http://localhost:3000/status if app run successfully response will be as: 
   ```json 
    {"status":"OK"}
   ```

## Running Tests
This project uses RSpec for unit and integration testing.

1. **Run the test suite:**
   ```bash 
      bundle exec rspec
   ```

If you want to run a specific test, use:
   ```
   bundle exec rspec spec/path/to/your/test_file.rb
   ```
2. **Test Coverage:**

The tests ensure that the application’s core services, including endpoint creation, update, and deletion, are functioning correctly. 
Unit tests cover individual services, while integration tests ensure the API works as expected.

## Available Endpoints 
Covered in API documentation section

In project root also added postman folder with collection available for import and testing

## Authentication

The API uses API keys for authentication. Each request must include a valid Authorization header

```bash
Authorization: Bearer YOUR_API_KEY
```

To create an API key, use Rails console: 
```ruby
ApiKey.create!(name: 'Test Client', access_token: SecureRandom.hex(20))
```

or get one from the seeds data imported earlier.

To use postman collection :
- copy token to postman authorization section (notice: postman collection does't updated with git pull when already imported in postman client, after git pull it need to be reimported to see changes from repo)
- if needed add additional request headers (example of simpliest request for test - GET  /endpoints)
- perform request and be sure that it was successfull


