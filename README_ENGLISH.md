# README

## Overview

This is a simple Task Management API designed to help teams manage users and tasks efficiently.  
It supports user registration and login, as well as creating, updating, retrieving, and deleting tasks.  

Tasks can have assignees, priorities, statuses, start/end dates, and optional descriptions.  
Task operations are secured with JWT authentication.  

For full API details, please refer to the API Specification(schema/schema.yml) included in this repository.

## Setup Instructions and Dependency Installation

* Please run the following commands in order:
  * Assumes a macOS environment.
  * For Windows environments, you may encounter an error at line 9 of the Dockerfile (`COPY entrypoint.sh /usr/bin/`) because `/usr/bin/` may not exist.

```bash
docker compose build
docker compose run web rails db:create
docker compose run web rails db:migrate
```


## Running Tests

### How to Run
Execute the following command to run all tests in the `spec` directory:

```bush
docker compose run web bundle exec rspec
```

If you want to run tests for a specific file only, use the following command:

```bush
docker compose run web bundle exec rspec spec/models/user_spec.rb
```

After running the specs, the test results will appear in the terminal:
	•	Green indicates the test passed.
	•	Red indicates the test failed.

## Linter/Formatter Usage and Configuration

### Usage

Check code:

```bush
docker compose run web  bundle exec rubocop
```

Auto-correct code:

```bush
docker compose run web  bundle exec rubocop -a
```

Check specific file or directory:

```bush
docker compose run web  bundle exec rubocop path/to/file.rb
```

### Configuration

* Customize project-specific styles in .rubocop.yml
* Based on rubocop-rails-omakase (default for Rails 7.2)

### Guard

* Guard watches files and runs tasks (tests, lint, app restart)
* `guard` is a Ruby tool that monitors file changes and automatically executes specified tasks, such as running tests, applying lint, or restarting the application.
* Since `rspec` and `rubocop` are included in the watch list, when `guard` is running, any file changes will **automatically trigger tests and lint checks**.
* You can start `guard` with the following command:

```sh
docker compose exec bundle exec guard
```

## API Specification
Refer to:

* `schema/schema.yml`

## System Overview and Design Choices

### System Architecture
* **Ruby, Ruby on Rails**
  * It is the server-side language I am most comfortable with, and I chose it because it is especially effective for short-term development.
  
* **PostgreSQL**
  * I was unsure whether to choose MySQL, but after seeing that PostgreSQL has a high adoption rate in [the Stack Overflow 2024 Developer Survey](https://survey.stackoverflow.co/2024/technology#1-databases), I became interested and decided to use it.

* **Docker**
  * When considering the runtime environment for others to review the code, I thought a container-based setup would make environment configuration easier.
  * Podman was also an option, but since I am more familiar with Docker, I decided it was better suited for short-term development.

### Implementation Highlights

#### Error Handling
* Centralized error handling in `ApplicationController` to standardize error processing across controllers.
* Simplified error handling by designing it so that generating an instance of the error class is sufficient when an error occurs.
* However, since error messages were fixed per status, it sometimes limited the flexibility of information provided during error investigation. There is room for improvement to pass dynamic error messages.

#### Use of Form, Service, and Repository Objects
* **Form Object**: Handles validation and ensures requests are processed safely.
* **Service Object**: Consolidates the "what" of business logic, making processing more intuitive to understand.
* **Repository Object**: Encapsulates the "how" of operations and clearly separates responsibilities.
* Interfaces were defined for each Service and Repository class, with YARD comments documenting inputs and outputs to help other developers understand the code more easily.

#### Database Structure
* User information and authentication information were split into separate tables because they are used in different use cases.
* This design allows handling only the minimal required data per use case, which is expected to have a positive impact on performance.

#### Authentication Logic
* The application was designed under the assumption that the frontend and backend operate on the same domain.
* Using `SameSite: Strict` for cookies makes CSRF protection straightforward.
* Setting `httpOnly: true` also protects against XSS attacks, providing a robust security measure.
  * [Reference](https://qiita.com/Hiro-mi/items/18e00060a0f8654f49d6#session%E3%82%92%E7%94%A8%E3%81%84session%E3%82%92%E8%A8%80%E3%81%86%E3%81%8B%E5%89%8D)
* JWT encryption keys are stored encrypted in `credentials.yml` to ensure security.
* `credentials.yml` manages sensitive information (API keys, passwords, etc.) safely within a Rails application.
* Without `master.key`, decryption is impossible, allowing safe uploading of secrets to the server. The key is added to `.gitignore` to prevent leaks.

#### GitHub Actions CI Integration
* Configured to automatically run lint checks and tests upon pushing to GitHub.
* This helps maintain code quality continuously and catch issues early.
* Used Secrets to allow authentication-related tests to run safely in the CI environment.
