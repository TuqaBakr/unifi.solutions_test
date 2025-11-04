 Unifi Solutions Flutter Project

This project is a Flutter application created as part of the Unifi Solutions test. It aims to demonstrate the ability to build an efficient and maintainable application using Clean Architecture, State Management (Cubit/Bloc), Routing (GoRouter), Network Integration (Dio), and Native Code Integration.

✨ Implemented Key Features

Users Management:

User List: Displays a list of users fetched from the GoRest API.

Infinite Pagination: Intelligently fetches users page by page while scrolling down.

Add New User: Interface to add a new user (Name, Email, Gender, Status) via API, with immediate local list update.

Application Architecture and Code Quality:

Clean Architecture: The project is divided into three main layers: Data, Domain, and Presentation.

State Management: Uses flutter_bloc (Cubit) to manage the state of the user list and addition processes.

Dependency Injection: Uses GetIt to register and manage dependencies (Dio, Repositories, Cubit).

Error Handling: Implemented the Failure and Either pattern across layers, with a global interceptor to convert DioException into standardized application-specific errors (Server, Validation, Network Failures).

Routing:

Uses GoRouter to manage navigation and routes.

The initial path issue has been resolved: The application starts from the /users path (User List Screen).

Native Integration:

Method Channel: Implementation of basic communication between Flutter and Native code (iOS/Android).

Endpoint: The dedicated route for this feature is /native-info.

Channel Name: com.app/native_utils

🛠️ Setup and Run Instructions

To run the project locally, please follow these steps:

1. Prerequisites

Flutter SDK: Version 3.22.x or later is preferred.

IDE: Visual Studio Code or Android Studio.

Device: Android/iOS emulator or a physical device.

2. Execution Steps

Clone the repository:

git clone [https://github.com/TuqaBakr/unifi.solutions_test.git](https://github.com/TuqaBakr/unifi.solutions_test.git)
cd unifi.solutions_test


Fetch Dependencies:

flutter pub get


Code Generation:
To generate freezed or json_serializable files:

flutter pub run build_runner build --delete-conflicting-outputs


Run the Application:

flutter run


3. Application Entry Points

Initial Location (initialLocation): The application is automatically directed to the User List Screen.

Path: /users

Add User Screen: Accessible via the Add button on the User List Screen.

Native Integration Screen: Path /native-info.

📂 Project Structure (Folder Structure)

The project is organized according to Clean Architecture principles:

lib/
├── core/
│   ├── constants/    (Api Endpoints)
│   ├── di/           (GetIt setup)
│   ├── errors/       (Failure & Exception classes)
│   ├── network/      (Dio Interceptor)
│   ├── router/       (GoRouter configuration)
│   └── utils/        (General utilities)
├── data/
│   ├── datasources/  (Remote/Local Data Sources - Api Calls)
│   ├── models/       (Data Transfer Objects - DTOs)
│   └── repositories/ (Implementation of Repository Interface)
├── domain/
│   ├── entities/     (Core business objects - UserEntity)
│   └── repositories/ (Abstract Interfaces)
├── presentation/
│   ├── user_list/    (User Cubit, Screens)
│   ├── add_user/     (Add User Screen)
│   └── widgets/      (Reusable components)
