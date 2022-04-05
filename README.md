# aura-app

## development

1. Install flutter sdk
2. Install firebase tools, [instructions here](https://firebase.google.com/docs/cli/#windows)
3. Login to firebase, `firebase login` -> make sure that you are a member of the firebase project
4. Get Flutter dependencies, `flutter pub get`
5. Copy the `local.properties.example` in /android, rename it to `local.properties`, and change the
   relevant keys
6. Run the app with android studio

## build app

Run the following command to successfully build the apk
```bash
    flutter build apk --no-tree-shake-icons
```