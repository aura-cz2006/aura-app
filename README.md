# aura-app

## development

1. Install flutter sdk
2. Install firebase tools, [instructions here](https://firebase.google.com/docs/cli/#windows)
3. Login to firebase, `firebase login` -> make sure that you are a member of the firebase project
4. Get Flutter dependencies, `flutter pub get`
5. Add a `gradle.properties` file to `«USER_HOME»/.gradle` (for windows, `C:\Users\<<your user name>>\.gradle`)
6. Add `MAPBOX_DOWNLOADS_TOKEN=<<paste secret key here>>` to gradle.properties

## build app

Run the following command to successfully build the apk
```bash
    flutter build apk --no-tree-shake-icons
```
