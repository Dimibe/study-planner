# Study Planner!
![Dart CI](https://github.com/Dimibe/study-planner/workflows/Dart%20CI/badge.svg?branch=master)

Plan and analyse your course of studies with Study Planner!

## Getting Started

For Flutter Web development the flutter beta channel must be used. Follow [this](https://flutter.dev/docs/get-started/web) guideline for setup.

* Generate dart classes with `flutter pub run build_runner build`
* Run for dev with `flutter run -d chrome`
* Build for web with `flutter build web`

# Structure
```
| - assets
| - build
  | - web
| - web
| - lib 
  | - main.dart
  | - models
  | - pages
  | - services
  | - utils
  | - widgets
    | - common
| - pubspec.yaml
```

The whole code is under the lib folder, categorized by models, pages, services, utils or widgets. Common widgets are in the common folder with a "CW" as prefix, where as widget specific for this app are in the root widgets folder and have the prefix "SP". The entry point of the app is main.dart which lays directly under the lib folder. 

Assets are located in the assets folder, the index.html is located in the web folder. When building a (release) version all sources (including the index.html) are located under build/web.
    

## Impressions
![Welcome image](https://raw.githubusercontent.com/Dimibe/study-planner/master/assets/welcome.png?token=ADXXI5JLGZGIWFW4GVBPEUC7SGM46)
