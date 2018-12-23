# Flist IOS App

[![Flist](https://flist.me/css/favicons/android-icon-72x72.png)](https://flist.me)

Website: https://flist.me

Download App: http://bit.ly/flist-ios

Flist is my personal open-source project. It is intended to help you in keeping all your social contacts at one place so you can easily share them at once with people you meet. The platform allows you to create a profile, which you then fill with the list of any contacts that you want to share; from large social networks such as Facebook, to emails and phone numbers, and to your profiles at small thematic forums. In short, you create your own profile in the online contact book.

### Project

This specific repository is dedicated to the IOS application of Flist. The app is written in Swift, using various third-party libraries.

### TODO
   - **Refactoring**: implement further abstractions for more maintanable code.
   - **QR Generator**: generate custom looking QR codes that link to the profile page.
   - **Dynamic Links**: integrate Firebase's dynamic links that would lead directly to the in-app profile page.

### Dependencies
  - [Firebase](https://cocoapods.org/pods/Firebase) by Google (core, auth, db, storage, etc)
  - [Fabric](https://cocoapods.org/pods/Fabric) by Google
  - [Crashlitycs](https://cocoapods.org/pods/Crashlytics) by Google
  - [SkeletonView](https://cocoapods.org/pods/SkeletonView) by Juanpe Catalán

See the Podfile for details.

### Other Repos of Flist
   - [Website Repo](https://github.com/romatallinn/flist-web) -- the repository for the web part of Flist. Includes both the landing page and the user's profile page.
   - [Firebase Cloud Functions Repo](https://github.com/romatallinn/flist-firebase-funcs) -- the repository for the custom backend scripts for more delicate and custom way of handling the events in safe and controlled environment.
   - [Extras](https://github.com/romatallinn/flist-extras.git) -- the repository for the extra material of Flist. Mainly focuses on the structure of the database and the storage, but also includes some media and press content.


### License
This project is licensed under the MIT License - see the LICENSE file for details.

