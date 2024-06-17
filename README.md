[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)
[![codecov](https://codecov.io/gh/Turskyi/flutter_laozi_ai/graph/badge.svg?token=JEURBJLKTI)](https://codecov.io/gh/Turskyi/flutter_laozi_ai)
[![Code Quality](https://github.com/Turskyi/flutter_laozi_ai/actions/workflows/code_quality_tests.yml/badge.svg)](https://github.com/Turskyi/flutter_laozi_ai/actions/workflows/code_quality_tests.yml)
[![Upload Android build to App Tester.](https://github.com/Turskyi/flutter_laozi_ai/actions/workflows/flutter_android_ci.yml/badge.svg?branch=master)](https://github.com/Turskyi/flutter_laozi_ai/actions/workflows/flutter_android_ci.yml)
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/Turskyi/flutter_laozi_ai">

# Daoism - Laozi AI Chatbot (Flutter Version)

This project is a Flutter-based mobile application that brings the wisdom of
Laozi and Daoist
teachings to users' fingertips. It is designed with a focus on user experience,
leveraging the
Flutter framework for a smooth and responsive interface.

## Getting Started

### Prerequisites:

- [Flutter SDK installed on your system](https://docs.flutter.dev/get-started/install).
- An [IDE with Flutter support](https://docs.flutter.dev/tools) (
  e.g., [Android Studio](https://developer.android.com/studio), [VS Code](https://code.visualstudio.com/download)).
- [Familiarity with Dart and Flutter development](https://docs.flutter.dev/get-started/codelab).

### Testing the App:

Join our testing program and provide valuable feedback:

- [Android App Distribution Tester Invite](https://appdistribution.firebase.dev/i/fa9deb62ac3a884b)

### Clone the Repository:

```bash
git clone https://github.com/Turskyi/flutter_laozi_ai
```

### Install Dependencies:

Navigate to the project directory and run:

```bash
flutter pub get
```

This will install all the necessary Flutter packages for the project.

## Running the App:

To run the app in debug mode, execute:

```bash
flutter run
```

## Building the App:

```bash
flutter build apk --release
```

## Libraries Used:

- [BLoC](https://pub.dev/packages/flutter_bloc) for state management.
- [Injectable](https://pub.dev/packages/injectable) for dependency injection.
- [Flutter Translate](https://pub.dev/packages/flutter_translate) for
  localization.
- [feedback](https://pub.dev/packages/feedback) for in-app user feedback.
- [Retrofit For Dart](https://pub.dev/packages/retrofit) for networking.
- [Shared preferences plugin](https://pub.dev/packages/shared_preferences) for
  local storage.
- [flutter_lints](https://pub.dev/packages/flutter_lints) for linting rules.

## Architecture:

The app follows a **monolithic onion architecture** pattern within the `lib`
folder:

- `application_services`: Contains `blocs` and repository implementations.
- `di`: Dependency injection setup.
- `domain_services`: Repository interfaces.
- `entities`: Base objects and enums used across the app.
- `infrastructure`: Web services, including models for remote calls and REST
  client implementation.
- `res`: Enums and constants.
- `router`: App routing setup with `AppRoute` enum and route implementations.
- `ui`: All the widgets used in the app.
- `main.dart` and `laozi_ai_app.dart`: Entry points of the app.

<details style="border: 1px solid #aaa; border-radius: 4px; padding: 0.5em 0.5em 0;">
  <summary style="font-weight: bold; margin: -0.5em -0.5em 0; padding: 0.5em; border-bottom: 1px solid #aaa;">Architectural pattern:

[Monolithic Onion Architecture](https://jeffreypalermo.com/2008/07/the-onion-architecture-part-1/)

  </summary>
<a href="https://sites.libsyn.com/412964/onion-architecture-episode-2">
<!--suppress CheckImageSize -->
<img src="assets/images/monolithic_onion_architecture.jpeg" width="800" title="Monolithic Onion Architecture" alt="Image of the Monolithic Onion Architecture Pattern">
</a>

## Layers

#### APPLICATION CORE - `entities`, `domain_services` and `application_services` (`core`)

The number of layers in the application `core` will vary, but remember that
the `Entities` is the very center, and since all couplings are toward the
center, the `Entities` is only coupled to itself.

#### Entities - `entities`

In the very center, we see the `Entities`, which represents the state and
behavior combination that models truth for the organization.
Around the Entities are other layers with more behavior.

#### DOMAIN SERVICES - `domain_services`

The first layer around the Entities is typically where we would find
interfaces that provide object saving and retrieving behaviour, called
`repository` interfaces. The implementation of the object-saving behavior is
not in the application core, however, because it typically involves a database.
Only the interface is in the application core.

#### APPLICATION SERVICES - `application_services`

`application_services` is the layer outside `domain_services`.
`Application Services` crosses the boundaries of the layers to communicate with
`Domain Services`, however, the **Dependency Rule** is never violated.
Using **polymorphism**, `Application Services` communicates with
`Domain Services` using inherited classes: classes that implement
or extend the `repository` presented in the `Domain Services` layer.
Since `polymorphism` is used, the `repository` passed to `Application Services`
still adhere to the **Dependency Rule** since as far as `Application Services`
is concerned, they are abstract. The implementation is hidden behind the
`polymorphism`.

#### UI, INFRASTRUCTURE, TESTS – `ui`, `infrastructure`, `android`, `ios` etc.

The outer layer is reserved for things that change often.
These things should be intentionally isolated from the application `core`.

</details>

**Code Readability:** code is easily readable with no unnecessary blank lines,
no unused variables or methods, and no commented-out code, all variables,
methods, and resource IDs are descriptively named such that another developer
reading the code can easily understand their function.

## Contributing:

Contributions are welcome! If you want to contribute to this project, you can
follow these steps:

- Fork this repository and clone it to your local machine.
- Create a new branch for your feature or bug-fix.
- Make your changes and commit them with a clear and descriptive message.
- Push your branch to your forked repository and create a pull request to the
  `master` brunch.
- Wait for your pull request to be reviewed and merged.

Please follow
[the Flutter style guide](https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md)
when contributing to this project. You can also use the issues and discussions
tabs to report bugs, request features, or give feedback.

<details style="border: 1px solid #aaa; border-radius: 4px; padding: 0.5em 0.5em 0;">
  <summary style="font-weight: bold; margin: -0.5em -0.5em 0; padding: 0.5em; border-bottom: 1px solid #aaa;">Style guides:

[Style guide for Flutter](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo),
[Dart style guide](https://dart.dev/effective-dart).

  </summary>

- [DO use trailing commas for all function calls and declarations unless the function call or definition, from the start of the function name up to the closing parenthesis, fits in a single line.](https://dart-lang.github.io/linter/lints/require_trailing_commas.html)

- [DON'T cast a nullable value to a non-nullable type. This hides a null check and most of the time it is not what is expected.](https://dart-lang.github.io/linter/lints/avoid_as.html)

- [PREFER using `const` for instantiating constant constructors](https://dart-lang.github.io/linter/lints/prefer_const_constructors.html)

If a constructor can be invoked as const to produce a canonicalized instance,
it's preferable to do so.

- [DO sort constructor declarations before other members](https://dart-lang.github.io/linter/lints/sort_constructors_first.html)

- ### Avoid Mental Mapping

A single-letter name is a poor choice; it’s just a placeholder that the reader
must mentally map to the actual concept. There can be no worse reason for using
the name `c` than because `a` and `b` were already taken.

- ### Method names

Methods should have verb or verb phrase names like `postPayment`, `deletePage`,
or `save`. Accessors, mutators, and predicates should be named for their value
and prefixed with `get`…, `set`…, and `is`….

- ### Use Intention-Revealing Names

If a name requires a comment, then the name does not reveal its intent.

- ### Use Pronounceable Names

If you can’t pronounce it, you can’t discuss it without sounding like an idiot.

- ### Class Names

Classes and objects should have noun or noun phrase names and not include
indistinct noise words:

```
GOOD:
Customer, WikiPage, Account, AddressParser.

BAD:
Manager, Processor, Data, Info.
```

- ### Functions should be small

Functions should hardly ever be 20 lines long.
Blocks within if statements, else statements, while statements, and so on
should be **_one_** line long. Probably that line should be a function call.

- ### Functions should do one thing

To know that a function is doing more than “one thing” is if you can extract
another function from it with a name that is not merely a restatement of its
implementation.

- ### One Level of Abstraction per Function

We want the code to read like a top-down narrative. We want every function to
be followed by those at the next level of abstraction so that we can read the
program, descending one level of abstraction at a time as we read down the list
of functions.

- ### Dependent Functions

If one function calls another, they should be vertically close, and the caller
should be **_above_** the callee, if possible.

- ### Use Descriptive Names

Don’t be afraid to make a name long. A long descriptive name is better than a
short enigmatic name. A long descriptive name is better than a long descriptive
comment.

- ### Function Arguments

The ideal number of arguments for a function is zero (niladic). Next comes one
(monadic), followed closely by two (dyadic). Three arguments (triadic) should
be avoided where possible.

```
GOOD:
includeSetupPage()

BAD:
includeSetupPageInto(newPageContent)
```

- ### Flag Arguments

Flag arguments are ugly. Passing a boolean into a function is a truly terrible
practice. It immediately complicates the signature of the method, loudly
proclaiming that this function does more than one thing. It does one thing if
the flag is true and another if the flag is false!

```
GOOD:
renderForSuite()
renderForSingleTest()

BAD:
render(bool isSuite)
```

- ### Explain Yourself in Code

Only the code can truly tell you what it does. Comments are, at best, a
necessary evil. Rather than spend your time writing the comments that explain
the mess you’ve made, spend it cleaning that mess. Inaccurate comments are far
worse than no comments at all.

```
BAD:
// Check to see if the employee is eligible
// for full benefits
if ((employee.flags & hourlyFlag) && (employee.age > 65))

GOOD:
if (employee.isEligibleForFullBenefits())

```

- ### TODO Comments

Nowadays, good IDEs provide special gestures and features to locate all the
`//TODO` comments, so it’s not likely that they will get lost.

- ### Public APIs

There is nothing quite so helpful and satisfying as a well-described public API.
It would be challenging, at best, to write programs without them.

```dart
/// dart doc comment
```

- ### Commented-Out Code

We’ve had good source code control systems for a very long time now. Those
systems will remember the code for us. We don’t have to comment it out anymore.

- ### Position Markers

In general, they are the clutter that should be eliminated—especially the noisy
train of slashes at the end. If you overuse banners, they’ll fall into the
background noise and be ignored.

```dart
// Actions //////////////////////////////////
```

- ### Don’t Return Null

When we return `null`, we are essentially creating work for ourselves and
foisting problems upon our callers. All it takes is one missing `null` check to
send an app spinning out of control.

- ### Don’t Pass Null

In most programming languages, there is no **GOOD** way to deal with a `null`
that is passed by a caller accidentally. Because this is the case, the rational
approach is to forbid passing null by default. When you do, you can code with
the knowledge that a `null` in an argument list is an indication of a problem,
and end up with far fewer careless mistakes.

- ### Classes Should Be Small!

With functions, we measured size by counting physical lines. With classes, we
use a different measure. **We count responsibilities.** The Single
Responsibility Principle (SRP) states that a class or module should have one,
and only one, reason to change. The name of a class should describe what
responsibilities it fulfills. The more ambiguous the class name, the more
likely it has too many responsibilities. The problem is that too many of us
think that we are done once the program works. We move on to the next problem
rather than going back and breaking the overstuffed classes into decoupled
units with single responsibilities.

- ### Artificial Coupling

In general, an artificial coupling is a coupling between two modules that
serves no direct purpose. It is a result of putting a variable, constant, or
function in a temporarily convenient, though inappropriate, location. For
example, general `enum`s should not be contained within more specific classes
because this forces the app to know about these more specific classes. The same
goes for general purpose `static` functions being declared in specific classes.

- ### Prefer Polymorphism to If/Else or Switch/Case

There may be no more than one switch statement for a given type of selection.
The cases in that switch statement must create polymorphic objects that take
the place of other such switch statements in the rest of the system.

- ### Replace Magic Numbers with Named Constants

In general, it is a bad idea to have raw numbers in your code. You should hide
them behind well-named constants. The term “Magic Number” does not apply only
to numbers. It applies to any token that has a value that is not
self-describing.

- ## Encapsulate Conditionals

Boolean logic is hard enough to understand without having to see it in the
context of an `if` or `while` statement. Extract functions that explain the
intent of the conditional.

```
GOOD:
if (shouldBeDeleted(timer))

BAD:
if (timer.hasExpired() && !timer.isRecurrent())
```

- ### Avoid Negative Conditionals

Negatives are just a bit harder to understand than positives. So, when
possible, conditionals should be expressed as positives.

```
GOOD:
if (buffer.shouldCompact())

BAD:
if (!buffer.shouldNotCompact())
```

- ### Encapsulate Boundary Conditions

Boundary conditions are hard to keep track of. Put the processing for them in
one place.

```
BAD:
if (level + 1 < tags.length) {
  parts = Parse(body, tags, level + 1, offset + endTag);
  body = null;
}

GOOD:
int nextLevel = level + 1;
if (nextLevel < tags.length) {
  parts = Parse(body, tags, nextLevel, offset + endTag);
  body = null;
}
```

- ### Constants versus Enums

Don’t keep using the old trick of public `static` `final` `int`s. `enum`s can
have methods and fields. This makes them very powerful tools that allow much
more expression and flexibility.

</details>

## Contact:

For any inquiries or suggestions, please open an issue on theGitHub repository
or reach out to me directly at [dmytro@turskyi.com](mailto:dmytro@turskyi.com).

• Screenshots:

<!--suppress CheckImageSize -->
<img src="screenshots/portrait_android_ua.png" width="400"  alt="screenshot">
<!--suppress CheckImageSize -->
<img src="screenshots/portrait_android_start_en.png" width="400"  alt="screenshot">
<!--suppress CheckImageSize -->
<img src="screenshots/portrait_tablet_android_chat_en.png" width="400"  alt="screenshot">

## Screen Recording:

<img src="screen_recordings/demo.gif" width="400"  alt="screenshot">
