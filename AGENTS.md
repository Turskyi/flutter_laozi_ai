# Agent Instructions & Style Preferences

## Coding Style Guidelines

### 1. Control Flow & Branching
- **No Early Returns:** Avoid early `return;` statements in functions or methods.
- **Explicit `else` Blocks:** Always provide explicit `else` blocks rather than leaving branches empty or omitting them when handling binary conditions.
- **Positive Conditions:** Prefer positive conditions (e.g., `a == b && c == d`) over negated conditions with logical OR (`!(a != b || c != d)`).

### 2. Null Safety & Collections
- **Avoid Null Assertions (`!`):** Never use the `!` null assertion operator. Instead, use `?`, safe navigation, null-checks (`!= null`), or local variables that allow Dart type promotion.
- **Safe Collection Access:** Use `.firstOrNull`, `.lastOrNull`, or safe indexing instead of `.first` or `.last` on potentially empty collections or nullable lists/iterables.

### 3. Constants & Magic Numbers
- **No Magic Numbers or Hardcoded Constants:** Avoid inline numeric literals, magic numbers, and hardcoded string constants or keys. Replace them with well-defined `const` or `final` constants or enums (e.g., `kMinManuscriptPage`, `kMaxManuscriptPage`, `langParameter`).

### 4. Typography & Punctuation
- **No Em Dashes (`—`):** Never use em dashes. Use standard hyphens (`-`), colons (`:`), or commas instead.
- **No Hardcoded Font Sizes:** Never hardcode font sizes (e.g., `TextStyle(fontSize: ...)`); always use Material 3 `TextTheme` styles (e.g., `Theme.of(context).textTheme.bodySmall`, `labelMedium`, etc.).

### 5. Lint & Formatting Rules
- Follow Flutter lint rules strictly (`always_specify_types`, `prefer_single_quotes`, `require_trailing_commas`, line length limit of 80 characters).

### 6. Flutter Style & Architecture (Widgets vs Helper Methods)
- **Widgets Over Helper Methods:** Follow Flutter styling conventions by extracting UI sub-components into standalone `Widget` classes (`StatelessWidget` or `StatefulWidget`) rather than using helper methods returning widgets (e.g., `_build...()`). This ensures correct `BuildContext` scoping, optimal rebuild performance, clean widget lifecycle management, and readability in the Flutter Widget Inspector.

### 7. File Organization & Architecture
- **One Class Per File:** Maintain one class per file, except for obvious exceptions such as state classes for stateful widgets, or enum-like classes such as events and states for BLoC/Cubit.

### 8. Dependency Management & Architecture
- **Dependency Injection Over Service Locator:** Prefer constructor dependency injection adhering to the dependency inversion principle (depending on abstract interfaces rather than concrete implementations) over using service locators (such as direct service locator calls inside business logic or widgets).

### 9. File Maintenance & Guidelines Limit
- **Line Count Limit & File Maintenance:** The `AGENTS.md` file must never exceed 200 lines, and this rule must always be placed at the very end of the file (and must not be placed below line 200). If a new rule needs to be added, concise existing content or remove less critical rules to remain strictly under the 200 line limit.
