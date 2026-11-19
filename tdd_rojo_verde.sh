#!/usr/bin/env bash
# Demuestra el ciclo TDD con las pruebas del manual:
#   ROJO : esconde temporalmente el código de la ronda -> la prueba DEBE fallar
#   VERDE: restaura el código                          -> la prueba DEBE pasar
# Uso:  ./tdd_rojo_verde.sh            (las 3 etapas)
#       ./tdd_rojo_verde.sh 1|2|3      (solo una etapa)
set -u
cd "$(dirname "$0")"
RESPALDO=".respaldo_tdd"
ESCONDIDOS=()

restaurar() {
  for f in "${ESCONDIDOS[@]:-}"; do
    [ -n "$f" ] && [ -f "$RESPALDO/$f" ] && mkdir -p "$(dirname "$f")" && mv "$RESPALDO/$f" "$f"
  done
  ESCONDIDOS=()
  rm -rf "$RESPALDO"
}
trap restaurar EXIT

etapa() {  # $1 nombre  $2 archivo de prueba  $3.. archivos de lib a esconder
  local nombre="$1" prueba="$2"; shift 2
  echo; echo "================ $nombre ================"
  for f in "$@"; do mkdir -p "$(dirname "$RESPALDO/$f")"; mv "$f" "$RESPALDO/$f"; ESCONDIDOS+=("$f"); done
  echo "--- 🔴 ROJO (sin implementación, debe FALLAR) ---"
  if flutter test "$prueba" >/dev/null 2>&1; then echo "❌ Esperaba rojo y pasó"; else echo "🔴 Falló, como debe ser"; fi
  restaurar
  echo "--- 🟢 VERDE (con implementación, debe PASAR) ---"
  if flutter test "$prueba"; then echo "🟢 Verde"; else echo "❌ Sigue en rojo"; fi
}

D=lib/dominio; A=lib/datos; V=lib/presentacion/vm
[ "${1:-1}" = 1 ] || [ -z "${1:-}" ] && etapa "Rondas 2-5: dominio" test/dominio_test.dart \
  $D/dinero.dart $D/producto.dart $D/excepciones.dart $D/carrito.dart $D/validadores.dart $D/tarjeta.dart
[ "${1:-2}" = 2 ] && etapa "Rondas 6-8: servicios" test/servicios_test.dart \
  $D/contratos.dart $A/pasarela_simulada.dart $D/servicio_checkout.dart $D/bloqueo_intentos.dart \
  $A/auth_simulada.dart $A/almacenes.dart $A/catalogo_memoria.dart
[ "${1:-3}" = 3 ] && etapa "Ronda 9: ViewModels" test/viewmodels_test.dart \
  $V/catalogo_vm.dart $V/carrito_vm.dart $V/sesion_vm.dart $V/checkout_vm.dart
echo; echo "Listo."
