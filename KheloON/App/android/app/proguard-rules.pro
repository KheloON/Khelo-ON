# Keep all Play Core and Health Connect classes
-keep class com.google.android.play.** { *; }
-keep class androidx.health.connect.** { *; }

# Keep OkHttp classes
-keep class com.squareup.okhttp.** { *; }
-keep class okhttp3.** { *; }

# Don't warn about missing references
-dontwarn com.google.android.play.**
-dontwarn androidx.health.connect.**
-dontwarn com.squareup.okhttp.**
