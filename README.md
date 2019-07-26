# Stuttherapy

## Technologies used

The application user the framework [Flutter](https://flutter.dev/). The language
used by this framework is [Dart](https://dart.dev/).

The entry point of the application is `lib/main.dart`.

## Database
Stuttherapy used the NoSQL database Firestore (powered by Google) to store
progress and Firebase authentication to managed accounts.

Once your Firebase project created you need to :
- Add the mail/password sign-in method in Firebase > Authentication > Sign-in method tab
- Link your Firebase project to the Android app (Refer to
[this tutoriel](https://firebase.google.com/docs/flutter/setup) to add your
Firebase project to the application to used the Firestore database.)
- Update the Firestore security rules (see appendices)

Once these steps done, the app is ready to use with the Firebase project.

### Links

- [Firebase plans](https://firebase.google.com/pricing?authuser=0)
- [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)

### Appendices
#### Firestore prices
*Firestore prices (July 27, 2019) :*

![](doc_res/prices.png)
*First column : Free plan, Second column : 25$/Month, Third column : Pay as you go*
#### Firestore security rules
```
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
    	allow read: if true;
    }

    match /users/{userId}/{document=**} {
      allow read, update, delete, create: if request.auth.uid == userId
      			|| get(/databases/$(database)/documents/users/$(userId)).data.test == true;
    }
  }
}
```

## Signed app

You can find a copy of the keystore in the following file : `./key.jks.save`
(not available on the git repo)

Then, simply build the app bundle : [Build an app bundle](https://flutter.dev/docs/deployment/android#build-an-app-bundle)

To test the bundle :
`java -jar bundletool.jar build-apks --bundle=build/app/outputs/bundle/release/app.aab --output build/app/outputs/bundle/release/stuttherapy.apks --ks=keystore.jks --ks-pass=file:keystore.pwd --ks-key-alias=key --key-pass=file:keystore.pwd`
