# demo_task

This project demonstrates a focused Flutter take-home built with BLoC and a light clean-architecture split. The app shows a work-order list backed by local mock data and enforces the main business rule when advancing a work order through its lifecycle.

## How to run

1. Install Flutter for your platform.
2. From the project root, run `flutter pub get`.
3. Launch the app with `flutter run`.
4. Run checks with `flutter analyze` and `flutter test`.

## Assumptions

- I used a work-order domain instead of a minimal generic job title because the repository structure in the starter code already suggested that direction and it gives a better surface area for business rules.
- Mock data is stored in-memory and loaded as a single local collection.
- The primary business action is advancing a work order to its next valid state rather than supporting arbitrary status edits from the UI.

## Architecture and state management

- `domain`: the `WorkOrderModel`, repository contracts, and the single business use case that matters here: advancing status with transition validation and photo-before-completion enforcement.
- `data`: a fake in-memory work-order repository plus a camera-backed photo repository.
- `presentation`: one `WorkOrdersBloc`, a home screen, and a work-order preview flow. Home-specific UI is kept close to the screen, while the larger reusable visual pieces stay in separate widgets.

## Feature notes

- Work orders load when the screen opens.
- Work orders can advance only through allowed transitions such as `Pending -> In progress -> Completed`.
- Completing a work order requires at least one attached photo.
- Filters only affect the visible list in memory; they do not trigger a new fetch.
