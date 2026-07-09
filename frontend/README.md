```
MedApp/
├─ backend/
│  ├─ pom.xml
│  ├─ mvnw
│  ├─ mvnw.cmd
│  ├─ src/
│  │  ├─ main/
│  │  │  ├─ java/
│  │  │  │  └─ bino/laryssa/backend/
│  │  │  │     ├─ BackendApplication.java
│  │  │  │     ├─ config/
│  │  │  │     ├─ controller/
│  │  │  │     │  ├─ AuthController.java
│  │  │  │     │  ├─ MedicationController.java
│  │  │  │     │  └─ UserController.java
│  │  │  │     ├─ exception/
│  │  │  │     ├─ jwt/
│  │  │  │     ├─ model/
│  │  │  │     │  ├─ dto/
│  │  │  │     │  │  ├─ ChangePasswordRequest.java
│  │  │  │     │  │  ├─ CreateMemberRequest.java
│  │  │  │     │  │  ├─ ErrorResponse.java
│  │  │  │     │  │  ├─ ForgotPasswordRequest.java
│  │  │  │     │  │  ├─ LoginRequest.java
│  │  │  │     │  │  ├─ MedicationRequest.java
│  │  │  │     │  │  ├─ MedicationResponse.java
│  │  │  │     │  │  ├─ RegisterRequest.java
│  │  │  │     │  │  ├─ ResetPasswordRequest.java
│  │  │  │     │  │  ├─ UpdateUserRequest.java
│  │  │  │     │  │  └─ UserResponse.java
│  │  │  │     │  ├─ enums/
│  │  │  │     │  ├─ Medication.java
│  │  │  │     │  ├─ User.java
│  │  │  │     │  └─ UserRelationship.java
│  │  │  │     ├─ repository/
│  │  │  │     │  ├─ MedicationRepository.java
│  │  │  │     │  ├─ UserRelationshipRepository.java
│  │  │  │     │  └─ UserRepository.java
│  │  │  │     └─ service/
│  │  │  │        ├─ EmailService.java
│  │  │  │        ├─ MedicationService.java
│  │  │  │        └─ UserService.java
│  │  │  └─ resources/
│  │  │     ├─ application.properties
│  │  │     ├─ application-example.properties
│  │  │     ├─ static/
│  │  │     └─ templates/
│  │  └─ test/
│  └─ target/
```

```
MedApp/
├─ frontend/
│  ├─ pubspec.yaml
│  ├─ pubspec.lock
│  ├─ README.md
│  ├─ lib/
│  │  ├─ main.dart
│  │  ├─ core/
│  │  │  ├─ api/
│  │  │  ├─ routing/
│  │  │  ├─ state/
│  │  │  ├─ storage/
│  │  │  ├─ theme/
│  │  │  └─ utils/
│  │  ├─ features/
│  │  │  ├─ auth/
│  │  │  ├─ medication/
│  │  │  ├─ members/
│  │  │  ├─ models/
│  │  │  ├─ service/
│  │  │  ├─ settings/
│  │  │  └─ user/
│  │  └─ shared/
│  │     └─ widgets/
│  │        ├─ auth_bottom_container.dart
│  │        ├─ auth_header.dart
│  │        ├─ auth_link_text.dart
│  │        ├─ bottom_nav.dart
│  │        ├─ custom_drop_field_text.dart
│  │        ├─ custom_floating_action_button.dart
│  │        ├─ custom_text_field.dart
│  │        ├─ date_time_button.dart
│  │        ├─ dropdown_field.dart
│  │        ├─ error_message.dart
│  │        ├─ image_picker_card.dart
│  │        ├─ index.dart
│  │        ├─ info_chip.dart
│  │        ├─ info_row.dart
│  │        ├─ medication_card.dart
│  │        ├─ member_chip.dart
│  │        ├─ primary_button.dart
│  │        ├─ secondary_button.dart
│  │        └─ section_title.dart
│  ├─ assets/
│  ├─ android/
│  ├─ ios/
│  ├─ web/
│  ├─ windows/
│  ├─ linux/
│  └─ macos/
└─ .git/
```

```

MedApp/
├─ backend/
│ ├─ pom.xml
│ ├─ mvnw
│ ├─ mvnw.cmd
│ ├─ src/
│ │ ├─ main/
│ │ │ ├─ java/
│ │ │ │ └─ bino/laryssa/backend/
│ │ │ │ ├─ BackendApplication.java
│ │ │ │ ├─ config/
│ │ │ │ ├─ controller/
│ │ │ │ ├─ exception/
│ │ │ │ ├─ jwt/
│ │ │ │ ├─ model/
│ │ │ │ │ ├─ dto/
│ │ │ │ │ ├─ enums/
│ │ │ │ ├─ repository/
│ │ │ │ └─ service/
│ │ │ └─ resources/
│ │ │ ├─ application.properties
│ │ │ ├─ application-example.properties
│ │ │ ├─ static/
│ │ │ └─ templates/
│ │ └─ test/
│ └─ target/

```

```

MedApp/
├─ frontend/
│ ├─ pubspec.yaml
│ ├─ pubspec.lock
│ ├─ README.md
│ ├─ lib/
│ │ ├─ main.dart
│ │ ├─ core/
│ │ │ ├─ api/
│ │ │ ├─ routing/
│ │ │ ├─ state/
│ │ │ ├─ storage/
│ │ │ ├─ theme/
│ │ │ └─ utils/
│ │ ├─ features/
│ │ │ ├─ auth/
│ │ │ ├─ medication/
│ │ │ ├─ members/
│ │ │ ├─ models/
│ │ │ ├─ schedule/
│ │ │ ├─ service/
│ │ │ ├─ settings/
│ │ │ └─ user/
│ │ └─ shared/
│ │ └─ widgets/
│ ├─ assets/
│ ├─ android/
│ ├─ ios/
│ ├─ web/
│ ├─ windows/
│ ├─ linux/
│ └─ macos/
└─ .git/

```
