###############################################
## Flutter default keep rules
###############################################

-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**


###############################################
## Google MLKit
###############################################

-keep class com.google.mlkit.** { *; }
-keep interface com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

###############################################
## Image Picker & QR Scanner
###############################################

-keep class com.yanzhenjie.** { *; }
-keep class com.journeyapps.** { *; }
-keep class com.google.zxing.** { *; }
-dontwarn com.journeyapps.**
-dontwarn com.google.zxing.**

###############################################
## flutter_doc_scanner
###############################################

-keep class com.scanlibrary.** { *; }
-dontwarn com.scanlibrary.**

###############################################
## url_launcher
###############################################

-keep class io.flutter.plugins.urllauncher.** { *; }
-dontwarn io.flutter.plugins.urllauncher.**

###############################################
## fluttertoast
###############################################

-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }
-dontwarn io.github.ponnamkarthik.toast.fluttertoast.**

###############################################
## General safe rules
###############################################

-keepattributes *Annotation*
-keepattributes Signature
