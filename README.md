# Versionary Administration Application

This application is used to manage content, manage users, and monitor operations.

The [JSON serialization](https://docs.flutter.dev/data-and-backend/json) annotations
require the following command running in the background if you intend to make changes
to the model classes:

```bash
flutter pub run build_runner watch
```

Action Items:

* Home Screen (information about the API and the logged in user)
* Logged in User Icon (link to edit user screen)
* User List
  * List of User Names on the left
  * Filter by Organization, Role, or Status
  * Selected user info on the right (large screen)
  * Floating action button to add a new user
