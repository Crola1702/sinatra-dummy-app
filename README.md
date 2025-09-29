# Simple messaging app

## Padawan Task Status

| Task | Associated PR | Notes |
| ---- | ------------- | ----- |
| Code Coverage | https://github.com/Crola1702/sinatra-dummy-app/pull/1 | See **Setting up coverage** section |
| Behavior Driven Development (BDD) | https://github.com/Crola1702/sinatra-dummy-app/pull/1 | See **Writing tests** subsection and <code>spec/app_spec.rb</code> test file. RSpec library is based on BDD |
| Profiling | N/A | |
| TDD | N/A | |

## How to use

Run with:
```bash
bundle install
bundle exec ruby src/app.rb # Production
bundle exec rerun 'src/app.rb' --dir src # Development (auto-reload)
```

Test with:
```bash
# Ping
curl http://127.0.0.1:4567/

# Create users
curl -s --request POST http://127.0.0.1:4567/users --data '{"name": "someone 1"}' | jq
curl -s --request POST http://127.0.0.1:4567/users --data '{"name": "someone 2"}' | jq

# Get user
curl -s --request GET http://127.0.0.1:4567/users/1 | jq

# Send message
curl -s --request POST http://127.0.0.1:4567/users/1/messages --data '{"to": "2", "content": "Hi 2"}' | jq

# Send multiple messages to a user
curl -s --request POST http://127.0.0.1:4567/users/1/messages/multiple/2 --data '[{"content": "Hi 2 multiple 1"}, {"content": "Hi 2 multiple 2"}, {"content": "Hi 2 multiple 3"}, {"content": "Hi 2 multiple 4"}]' | jq

# Get messages
curl -s --request GET http://127.0.0.1:4567/users/1/messages | jq
```

# Application description

This app is written in Ruby using the [Sinatra Web Framework](https://sinatrarb.com/).

## Project structure:

```bash
├── data
│   └── data.db
├── Gemfile
├── Gemfile.lock
├── README.md
└── src
    ├── app.rb
    └── models.rb
```

- `data`: folder contains a sample sqlite3 database
- `Gemfile` and `Gemfile.lock` describe the required gems of the application:
    - `sinatra`: Web framework used in the app
    - `sqlite3`: Provides a library to interface with sqlite3 databases
    - `activerecord`: ORM used by Rails
- `src`
    - `app.rb`: Endpoints of the application
    - `models.rb`: Database schema definitions

<details>
<summary><h2>Domain diagram</h2></summary>

```mermaid
---
title: Domain Diagram
---
classDiagram
	class User {
		+String name
	}
	class Message {
		+String content
	}
	
	User "1" --|> "*" Message : sender
	User "1" --|> "*" Message : receiver
```

</details>
