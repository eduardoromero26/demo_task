Flutter Take-Home Project

Please build a small Flutter application that runs on either iOS or Android.
Objective
Create a simple work order flow for a field service app.
The app should allow a user to:
View a list of work orders
Open an individual work order
Mark a work order as In Progress
Mark a work order as Completed
Functional Requirements
The app must display a list of work orders.
Each work order should have enough information to make the UI meaningful.
A user must be able to open a work order and update its status.
A work order can be moved to In Progress.
A work order can only be moved to Completed if it has at least one photo attached.
If the work order does not have at least one photo, the app should prevent completion and communicate that clearly in the UI.
Photo handling can be mocked or implemented with a simple local image picker. Real backend upload is not required.
Technical Requirements
The project must be built with Flutter.
State management must use BLoC, not Cubit.
The project must follow Clean Architecture principles.
Code should be organized clearly with separation of concerns.
Business logic should not live inside widgets.
Data can be mocked locally. A real API is not required.
What We Are Evaluating
We are primarily evaluating:
Code organization
Understanding of BLoC
Understanding of Clean Architecture
State modeling
Readability and maintainability
Handling of business rules
General Flutter engineering quality
We are not primarily evaluating visual polish.
Deliverables
Please provide:
The full source code
A short README with:
How to run the project
Any assumptions you made
A brief explanation of your architecture and state management choices
Notes
Keep the solution reasonably scoped.
Mock data is completely acceptable.
The goal is not to build a production-complete app, but to demonstrate how you structure and implement a Flutter feature using BLoC and Clean Architecture.
