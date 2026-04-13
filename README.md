# demo_task

This project demonstrates a reasonably scoped Flutter feature built with BLoC and Clean Architecture principles. The app shows a paginated work-order list backed by mock data, supports retrying a failed pagination request, and applies domain rules when advancing a work order through its lifecycle.

## How to run

1. Install Flutter for your platform.
2. From the project root, run `flutter pub get`.
3. Launch the app with `flutter run`.
4. Run checks with `flutter analyze` and `flutter test`.

## Assumptions

- I used a work-order domain instead of a minimal generic job title because the repository structure in the starter code already suggested that direction and it gives a better surface area for business rules.
- Mock data is stored in-memory and page 3 is intentionally configured to fail once so the pagination error and retry path can be demonstrated.
- The primary business action is advancing a work order to its next valid state rather than supporting arbitrary status edits from the UI.

## Architecture and state management

- `domain`: entities, repository contract, and use cases. Business rules for valid status transitions live in the domain layer and are enforced before repository updates.
- `data`: a fake in-memory repository that simulates paginated responses and a one-time failure on page 3.
- `presentation`: a `WorkOrdersBloc` with explicit events and a single immutable state model. The state separately tracks initial loading, pagination loading, pagination failure, filters, and per-item update progress so the UI can stay predictable.

## Feature notes

- Page 1 loads when the screen opens.
- Scrolling near the bottom requests the next page.
- When page 3 fails, already loaded items remain visible and an inline retry card is shown.
- Work orders can advance only through allowed transitions such as `Open -> Scheduled -> In progress -> Completed`.
