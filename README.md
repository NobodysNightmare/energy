# Energy

A small application to monitor the power generation and consumption of
a (solar powered) household.

## Managing users

The application is configured to authenticate via Google (using omniauth) and
only grant access to a few selected users. Everyone that is allowed to access
the application has full access.

Check `rake -T`, all commands starting with `users:` are intended for user
management.

## Managing API-Keys

The API-Endpoints require to pass an API-Key using the `X-Api-Key` HTTP-Header.

Check `rake -T` for additional details. All commands starting with `api_keys:`
are intended for management of API-Keys.
