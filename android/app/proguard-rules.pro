# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.sdk.** { *; }
-keep class com.google.firebase.** { *; }

# Flutter embedding references Play Feature Delivery types for deferred
# components. This app does not ship deferred components, so those classes
# are absent from the classpath. R8 must ignore the unused references.
-dontwarn com.google.android.play.core.**

# Older Firebase KTX extensions still name com.google.firebase.ktx.Firebase.
# The app uses the main Firebase artifacts, which no longer ship that type.
-dontwarn com.google.firebase.ktx.**
