# Email Subscription Feature - Integration Guide

## Quick Start

The email subscription feature has been fully implemented following the clean architecture pattern. Here's how to integrate it into your app:

## 1. Dependency Injection Setup

You'll need to register the following dependencies in your dependency injection container (likely in `injection_container.dart` or similar):

```dart
// Data Sources
sl.registerLazySingleton<EmailSubscriptionRemoteDataSource>(
  () => EmailSubscriptionRemoteDataSourceImpl(sl()),
);

// Repositories
sl.registerLazySingleton<EmailSubscriptionRepository>(
  () => EmailSubscriptionRepositoryImpl(sl()),
);

// Use Cases
sl.registerLazySingleton(() => SubscribeEmailUsecase(sl()));
sl.registerLazySingleton(() => UnsubscribeEmailUsecase(sl()));

// BLoC
sl.registerFactory(
  () => EmailSubscriptionBloc(
    subscribeEmailUsecase: sl(),
    unsubscribeEmailUsecase: sl(),
  ),
);
```

## 2. Add Route

Add the email subscription screen to your app router:

```dart
GoRoute(
  path: '/email-subscription',
  name: 'emailSubscription',
  builder: (context, state) => BlocProvider(
    create: (context) => sl<EmailSubscriptionBloc>(),
    child: const EmailSubscriptionScreen(),
  ),
),
```

## 3. Navigate to Screen

Navigate to the screen from anywhere in your app:

```dart
context.pushNamed('emailSubscription');
// or
context.push('/email-subscription');
```

## 4. Backend Requirements

Ensure your backend has these endpoints:

- **POST** `/email-subscription/subscribe`
  - Request body: `{ "email": "user@example.com" }`
  - Success response: 2xx status code
  
- **POST** `/email-subscription/unsubscribe`
  - Request body: `{ "email": "user@example.com" }`
  - Success response: 2xx status code

## Feature Overview

The screen provides:
- Email input with validation
- Subscribe button
- Unsubscribe button
- Loading states
- Success/error feedback via SnackBar
- Auto-clear email field on success

## Files Created

All files are in `lib/features/email_subscription/`:
- Domain: entities, repositories, use cases
- Data: models, data sources, repository implementation
- Application: BLoC, events, states
- Presentation: UI screen
