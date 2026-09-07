# BloodLink

BloodLink is a Flutter mobile application prototype for connecting people who need blood with nearby blood donors.

## Main implemented features

- Find a Blood Donor
- Request Blood
- Donor profile view
- Request confirmation
- Dashboard navigation

## Run the project

1. Open the project in VS Code.
2. Run `flutter pub get`.
3. Run `flutter analyze`.
4. Start an Android emulator or connect a device.
5. Run `flutter run`.

The app currently uses local sample data for the front-end prototype.


## Assessment 4 Front-End Improvements

The BloodLink prototype includes two connected major front-end features:

1. **Find a Blood Donor**
   - Blood-group selection
   - Distance filtering
   - Donor search results
   - Donor profile
   - Contact donor confirmation

2. **Request Blood**
   - Blood-group selection
   - Units validation
   - Hospital/location input
   - Request confirmation
   - Submitted requests are shown in **My Requests**

The request data is kept in an in-memory store during the app session so the user can see a submitted request across the dashboard and My Requests screens. This is prototype/front-end behaviour and does not represent a production backend or database.
