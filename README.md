# Simple messaging app

Run with:
```bash
bundle install
bundle exec ruby src/app.rb # Production
bundle exec rerun 'src/app.rb' # Development (auto-reload)
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

# Get messages
curl -s --request GET http://127.0.0.1:4567/users/1/messages | jq
```