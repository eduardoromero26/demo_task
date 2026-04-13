# demo_task

This repository contains the Flutter solution for part 2 of the Stellar technical exercise.

The base app structure and UI direction were reused from part 1, and this second part adapts that foundation into a field-service work-order flow. The result is a focused Flutter take-home built with BLoC and a light clean-architecture split.

The app shows a list of work orders backed by local mock data and enforces the main business rule when advancing a work order through its lifecycle.

## Scope

- View a list of work orders.
- Open an individual work order.
- Move a work order to `In Progress`.
- Move a work order to `Completed` only if it has at least one photo.
- Capture a completion photo with the local device camera through `image_picker`.

## Environment

- Flutter: `3.32.2`
- Dart: `3.8.1`
- DevTools: `2.45.1`
- Dart SDK constraint in project: `^3.8.1`
- Android NDK used by the project: `27.0.12077973`

## How to run

1. Install Flutter `3.32.2` or a compatible stable version.
2. From the project root, run `flutter pub get`.
3. If you run on Android, make sure Android NDK `27.0.12077973` is installed.
4. Launch the app with `flutter run`.
5. Run checks with `flutter analyze` and `flutter test`.

## Packages used

Main dependencies:

- `flutter`
- `bloc: ^9.2.0`
- `flutter_bloc: ^9.1.1`
- `equatable: ^2.0.7`
- `image_picker: ^1.1.2`
- `cupertino_icons: ^1.0.8`

Development and tooling:

- `flutter_test`
- `flutter_lints: ^5.0.0`
- `flutter_native_splash: ^2.4.6`
- `flutter_launcher_icons: ^0.14.3`

## Assumptions

- This is intentionally scoped as a small feature, not a production-complete app.
- I reused the technical base from part 1 of the Stellar exercise and adapted it to the work-order requirements for part 2.
- I used a work-order domain instead of a minimal generic job title because it gives better surface area for the business rules requested in the assignment.
- Mock data is stored in-memory and loaded as a single local collection.
- The primary business action is advancing a work order to its next valid state rather than supporting arbitrary status edits from the UI.
- Photo handling is local only. There is no backend upload or persistence outside the running app session.

## Architecture and state management

- `domain`: the `WorkOrderModel`, repository contracts, and the single business use case that matters here: advancing status with transition validation and photo-before-completion enforcement.
- `data`: a fake in-memory work-order repository plus a camera-backed photo repository.
- `presentation`: one `WorkOrdersBloc`, a home screen, and a work-order preview flow. Home-specific UI is kept close to the screen, while the larger reusable visual pieces stay in separate widgets.

### Why BLoC here

- `WorkOrdersBloc` owns the loading flow, filtering, status updates, photo capture flow, and user feedback state.
- Widgets stay mostly declarative and dispatch events instead of containing business rules.
- The completion rule is enforced in the domain layer, not in the UI.

## Feature notes

- Work orders load when the screen opens.
- Work orders can advance only through allowed transitions such as `Pending -> In progress -> Completed`.
- Completing a work order requires at least one attached photo.
- Filters only affect the visible list in memory; they do not trigger a new fetch.

## Dummy or placeholder functionality

Some UI elements are intentionally non-functional because they are outside the requested scope of part 2:

- `New Job` shows a mock snackbar only.
- The notifications icon is present as a visual placeholder.
- Bottom navigation items are placeholders and do not navigate to real screens.