# دليل البناء والنشر: Mystery Link

## متطلبات البناء

### Windows Desktop

1. **Flutter SDK** (3.0.0 أو أحدث)
2. **Visual Studio 2022** مع:
   - Desktop development with C++
   - Windows 10/11 SDK
3. **Git** (لإدارة الإصدارات)

### Android

1. **Android Studio**
2. **Android SDK** (API 21 أو أحدث)
3. **Java Development Kit (JDK)** 11 أو أحدث

### iOS (للمستقبل)

1. **Xcode** (14.0 أو أحدث)
2. **CocoaPods**
3. **macOS** (مطلوب للبناء)

---

## خطوات البناء

### 1. إعداد البيئة

```bash
# التحقق من تثبيت Flutter
flutter doctor

# تفعيل Windows Desktop
flutter config --enable-windows-desktop

# التحقق من الأجهزة المتاحة
flutter devices
```

### 2. جلب التبعيات

```bash
# جلب جميع التبعيات
flutter pub get

# توليد ملفات JSON serialization
flutter pub run build_runner build --delete-conflicting-outputs

# توليد ملفات الترجمة
flutter gen-l10n
```

### 3. التحقق من الكود

```bash
# فحص الكود
flutter analyze

# تشغيل الاختبارات
flutter test

# تشغيل الاختبارات مع التغطية
flutter test --coverage
```

### 4. بناء نسخة Debug

#### Windows
```bash
flutter build windows
```

الملف الناتج: `build\windows\x64\runner\Debug\mystery_link.exe`

#### Android
```bash
flutter build apk --debug
```

الملف الناتج: `build\app\outputs\flutter-apk\app-debug.apk`

### 5. بناء نسخة Release

#### Windows
```bash
flutter build windows --release
```

الملف الناتج: `build\windows\x64\runner\Release\mystery_link.exe`

**ملاحظة**: لإنشاء ملف قابل للتثبيت (.msix أو .exe installer)، استخدم:
- **msix**: `flutter build windows --release` ثم استخدم `msix` tool
- **Installer**: استخدم WiX Toolset أو Inno Setup

#### Android
```bash
# APK
flutter build apk --release

# App Bundle (لـ Google Play)
flutter build appbundle --release
```

الملفات الناتجة:
- APK: `build\app\outputs\flutter-apk\app-release.apk`
- AAB: `build\app\outputs\bundle\release\app-release.aab`

---

## إعداد التوقيع (Android)

### 1. إنشاء Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. إعداد key.properties

أنشئ ملف `android/key.properties`:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

### 3. تحديث build.gradle

تأكد من أن `android/app/build.gradle` يحتوي على إعدادات التوقيع.

---

## تحسين الأداء

### 1. تحسين حجم التطبيق

```bash
# تحليل حجم التطبيق
flutter build apk --analyze-size

# بناء مع تقليل الحجم
flutter build apk --release --split-per-abi
```

### 2. تحسين الأداء

- استخدم `--profile` mode للاختبار:
```bash
flutter run --profile
```

- راقب الأداء باستخدام Flutter DevTools:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 3. تقليل حجم الصور

- استخدم تنسيقات مضغوطة (WebP)
- قم بتحسين الصور قبل الإضافة
- استخدم أحجام مناسبة للشاشات

---

## إعداد الأيقونات

### Windows

الأيقونة موجودة في: `windows/runner/resources/app_icon.ico`

لإنشاء أيقونة جديدة:
1. استخدم أداة مثل IcoFX أو GIMP
2. أنشئ أيقونة بحجم 256x256
3. احفظها كـ `.ico`
4. استبدل الملف الموجود

### Android

استخدم `flutter_launcher_icons` package:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  image_path: "assets/icon/app_icon.png"
```

ثم قم بتشغيل:
```bash
flutter pub run flutter_launcher_icons
```

---

## إعداد Splash Screen

تم إنشاء Splash Screen في `lib/shared/widgets/splash_screen.dart`.

لإضافة Splash Screen أصلي:

### Android

1. أضف الصورة في `android/app/src/main/res/drawable/`
2. أنشئ `android/app/src/main/res/drawable/launch_background.xml`
3. أنشئ `android/app/src/main/res/values/styles.xml`

### Windows

Splash Screen يتم عرضه من خلال الكود في `main.dart`.

---

## الاختبار قبل النشر

### قائمة التحقق

- [ ] جميع الاختبارات تمر
- [ ] لا توجد أخطاء في `flutter analyze`
- [ ] التطبيق يعمل على جميع المنصات المستهدفة
- [ ] الأداء جيد (60 FPS)
- [ ] حجم التطبيق معقول
- [ ] الأيقونات والصور واضحة
- [ ] الترجمة كاملة
- [ ] لا توجد معلومات Debug في Release
- [ ] التوقيع صحيح (Android)
- [ ] Privacy Policy و Terms of Service (إن لزم)

---

## النشر

### Google Play Store

1. أنشئ حساب مطور
2. أضف معلومات التطبيق
3. ارفع ملف AAB
4. أضف لقطات الشاشة
5. أضف وصف التطبيق
6. حدد الفئة والعمر
7. أرسل للمراجعة

### Microsoft Store

1. أنشئ حساب مطور
2. استخدم `flutter build windows --release`
3. أنشئ حزمة MSIX
4. ارفع الحزمة
5. أضف معلومات التطبيق
6. أرسل للمراجعة

---

## استكشاف الأخطاء

### مشاكل شائعة

**1. "flutter: command not found"**
- تأكد من إضافة Flutter إلى PATH
- أعد فتح Terminal

**2. "No devices found"**
- تأكد من تفعيل Desktop: `flutter config --enable-windows-desktop`
- تأكد من تثبيت Visual Studio

**3. "Gradle build failed"**
- تأكد من تثبيت Android SDK
- تحقق من إعدادات `build.gradle`

**4. "Code signing error"**
- تأكد من إعدادات التوقيع في `key.properties`
- تحقق من صحة Keystore

---

## الموارد

- [Flutter Documentation](https://flutter.dev/docs)
- [Windows Desktop Support](https://docs.flutter.dev/desktop)
- [Android Deployment](https://docs.flutter.dev/deployment/android)
- [App Size Optimization](https://docs.flutter.dev/perf/app-size)

