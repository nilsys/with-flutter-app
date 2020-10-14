# with_app

## Docs

1. [Data models schema](https://docs.google.com/drawings/d/1ajfmi8cEDffEGTRlMbKvoyijV7SPEjhBuKF0jYHLx5k/edit)
1. [Material Icons](https://material.io/resources/icons/?search=phone&style=baseline)
1. In the `pubspec.yaml` file You can find a links to each of the external libraries beeing used.

<br>

## Services

1. [Codemagic](https://codemagic.io/app/5f4515cd55449d000fe1b102)
1. [Firebase Console](https://console.firebase.google.com/u/0/project/with-flutter-app-ae099/firestore/data~2F)
1. [FlutterIcon](https://www.fluttericon.com/)

<br>

## Coding Guildlines

### Workflow

1. Update your develop branch to the latest commit
1. Branch out from develop branch. branch name should be as provided in the assignment ticket.
1. Complete the assignment
1. Create a pull request to the develop branch
1. Get paid!

### State Managemnt

1. State should be handled inside a `StatefulWidget` widget <br>
1. If the state should be acceced in more than one widget use a `ChangeNotifier` provider. (see: `lib/core/view_models`)

### Code Reuse

1. Use widgets from the sahred widgets folder if possible (see: `lib/ui/shared`)

### Code Style

1. try to mimic code style from already exsisting files
