# Necessário para o flutter_local_notifications: em builds release, o R8/ProGuard
# pode remover as assinaturas genéricas que a biblioteca Gson usa internamente
# para (des)serializar as notificações agendadas, causando o erro:
# "TypeToken must be created with a type argument"

-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

# Mantém as classes internas do plugin de notificações intactas
-keep class com.dexterous.flutterlocalnotifications.** { *; }