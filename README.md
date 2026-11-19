# Talavera Dolores — tienda móvil con TDD y "Ver en tu espacio" (RA)

Código y pruebas completos del *Manual paso a paso con TDD* (Desarrollo Móvil Integral · UTNG).
Esta carpeta trae `lib/`, `test/`, `pubspec.yaml` y `analysis_options.yaml`.
Las carpetas de plataforma (android/, ios/) las genera Flutter.

## 1. Preparar (una sola vez)
```bash
flutter create tienda_talavera          # crea android/ ios/ ...
# copia encima de esa carpeta: lib/, test/, pubspec.yaml, analysis_options.yaml, tdd_rojo_verde.sh
cd tienda_talavera
flutter pub get
```
Android: en `android/app/src/main/AndroidManifest.xml` agrega
`<uses-permission android:name="android.permission.INTERNET"/>` (arriba de `<application>`).

## 2. Pruebas en VERDE (todo el proyecto)
```bash
flutter test                                   # las 3 suites
flutter test --reporter expanded               # nombre de cada prueba
flutter test test/dominio_test.dart            # Rondas 2-5
flutter test test/servicios_test.dart          # Rondas 6-8
flutter test test/viewmodels_test.dart         # Ronda 9
flutter test --plain-name "Luhn"               # solo pruebas cuyo nombre contenga "Luhn"
flutter analyze                                # análisis estático
```

## 3. Ciclo ROJO → VERDE
Automático (esconde el código de cada ronda, comprueba que falle, lo restaura y comprueba que pase):
```bash
chmod +x tdd_rojo_verde.sh
./tdd_rojo_verde.sh        # las 3 etapas
./tdd_rojo_verde.sh 1      # solo dominio  (2 = servicios, 3 = viewmodels)
```
Manual, como en el libro (ejemplo con el dominio):
```bash
mkdir -p .rojo/lib/dominio
mv lib/dominio/{dinero,producto,excepciones,carrito,validadores,tarjeta}.dart .rojo/lib/dominio/
flutter test test/dominio_test.dart            # 🔴 ROJO: no compila, faltan archivos
mv .rojo/lib/dominio/*.dart lib/dominio/
flutter test test/dominio_test.dart            # 🟢 VERDE
```

## 4. Correr la app
```bash
flutter run            # emulador: se ve el visor 3D, pero la AR real requiere teléfono físico con ARCore / iPhone
```
Lista de verificación: compra con `4242 4242 4242 4242`; `4000 0000 0000 0002` es rechazada y no descuenta inventario;
5 logins fallidos bloquean la cuenta; cerrar y reabrir conserva carrito y sesión.
