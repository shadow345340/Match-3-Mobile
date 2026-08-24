# Match 3 Mobile - Godot 4.7.1

<p align="center">
  <strong>Un motor de Match-3 de alto rendimiento para dispositivos móviles.</strong>
  <br>
  Desarrollado en <strong>Godot Engine v4.7.1</strong> con arquitectura de Máquina de Estados, Componentes desacoplados y Guardado Persistente.
</p>

---

## 🚀 Características Principales

*   **Arquitectura Decoupled (State Machine):** El ciclo de juego del tablero se maneja mediante nodos hijos asíncronos (`IdlingState`, `SwappingState`, `MatchingState`, `FallingState`), eliminando los scripts monolíticos sobrecargados.
*   **Diseño Mobile-First (Portrait):** Interfaz adaptada al 100% para pantallas verticales en teléfonos móviles, controlada por gestos táctiles directos (*swipes*).
*   **Dificultad Dinámica Progresiva (100 Niveles):** Sistema algorítmico que incrementa de forma automática y matemática el puntaje meta y reduce los movimientos límites según avanzas.
*   **Persistencia de Datos (Save System):** El progreso del jugador se guarda automáticamente en archivos binarios locales en el almacenamiento del dispositivo (`user://`).
*   **Audio Separado por Buses:** Menú de opciones interactivo con reguladores de decibelios lineales (`linear_to_db`) nativos independientes para la Música (`Music`) y los Efectos Especiales (`SFX`).

---

## 📁 Estructura del Proyecto

El código fuente y los recursos del juego siguen un diseño jerárquico estricto y limpio estructurado por responsabilidades:

```text
📦 Match 3 Proyect
 ┣ 📂 scenes                          # Escenas principales de Godot (.tscn)
 ┃ ┣ 📜 main.tscn                     # Tablero y render de juego central
 ┃ ┣ 📜 main_menu.tscn                # Menú principal y llamadas a popups
 ┃ ┣ 📜 options_menu.tscn             # Panel de opciones translúcido
 ┃ ┣ 📜 pause_menu.tscn               # Ventana modal de pausa (When Paused)
 ┃ ┣ 📜 sparkles.tscn                 # Emisor de partículas GPU
 ┃ ┣ 📜 splash_screen.tscn            # Reproductor de vídeo introductorio
 ┃ ┗ 📜 tile.tscn                     # Objeto interactivo Area2D para fichas
 ┣ 📂 scripts                         # Lógica interna escrita en GDScript
 ┃ ┣ 📂 board_states                  # Máquina de estados finita del tablero
 ┃ ┃ ┣ 📜 board_state.gd              # Clase base abstracta de estados
 ┃ ┃ ┣ 📜 board_state_machine.gd      # Orquestador del flujo y transiciones
 ┃ ┃ ┣ 📜 falling_state.gd            # Estado de colapso y spawn de fichas
 ┃ ┃ ┣ 📜 game_over_state.gd          # Estado de bloqueo táctil por derrota
 ┃ ┃ ┣ 📜 idling_state.gd             # Estado de espera de input del jugador
 ┃ ┃ ┣ 📜 matching_state.gd           # Estado de validación matemática y destrucción
 ┃ ┃ ┣ 📜 swapping_state.gd           # Estado de animación e intercambio físico
 ┃ ┃ ┗ 📜 victory_state.gd            # Estado de fin de nivel por victoria
 ┃ ┣ 📂 components                    # Módulos de lógica desacoplada
 ┃ ┃ ┣ 📜 grid_matcher.gd             # Matriz matemática y algoritmos Match-3
 ┃ ┃ ┣ 📜 input_handler.gd            # Gestor de toques en pantalla y arrastres
 ┃ ┃ ┗ 📜 score_manager.gd            # Administrador de puntajes y dificultad
 ┃ ┗ 📂 global                        # Autoloads globales (Singletons nativos)
 ┃   ┣ 📜 audio.gd                    # Centralizador dinámico de audio multicanal
 ┃   ┗ 📜 game_manager.gd             # Controlador de nivel activo y persistencia
 ┣ 📂 music                           # Archivos de sonido de fondo (.mp3)
 ┣ 📂 sounds                          # Efectos sonoros de interacción (.ogg)
 ┣ 📂 sprites                         # Recursos gráficos (.png)
 ┃ ┣ 📂 backgrounds                  # Fondos para menús y tableros
 ┃ ┣ 📂 cursors                      # Sprites del puntero interactivo
 ┃ ┣ 📂 particles                    # Texturas para los fuegos artificiales GPU
 ┃ ┗ 📂 tiles                        # Diseños de las gemas coleccionables
 ┣ 📂 screenshots                     # Material gráfico promocional del juego
 ┣ 📜 icon.png                        # Icono de la aplicación móvil
 ┗ 📜 README.md                       # Documentación técnica del repositorio
```

---

## 🛠️ Tecnologías Empleadas

*   **Motor de Desarrollo:** Godot Engine v4.7.1
*   **Lenguaje de Programación:** GDScript (Tipado Estático Avanzado)
*   **Formato de Audio Soportado:** MP3 (Music Loop) / OGG Theora Vorbis (SFX)
*   **Base Gráfica:** Match 3 Starter Kit por **Kenney** (Adaptado y reescalado de 16:9 horizontal a formato vertical móvil).

---

## 📱 Requisitos para Compilación en Android

El proyecto está diseñado bajo estándares nativos de la API de Android. Para generar tu propio paquete instalable de pruebas (`.apk`), realiza el siguiente proceso técnico:

1.  **Herramientas SDK:** Instala Android Studio, descarga las herramientas de consola (*SDK Command-line Tools*), CMake y el compilador NDK (Side by side).
2.  **Firma de Depuración:** Genera una clave criptográfica RSA de desarrollo ejecutando en consola:
    ```bash
    keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 10000
    ```
3.  **Configuración de Godot:** Vincula la ruta del SDK de Android y tu archivo `debug.keystore` en los Ajustes del Editor de Godot (*Editor Settings > Export > Android*).
4.  **Exportación:** Ve a *Proyecto > Exportar*, añade el perfil de Android y marca las arquitecturas móviles `arm64-v8a` y `armeabi-v7a`.

---

## 📄 Licencia y Derechos de Autor (Copyright)

**© 2026 Mathias Capote. Todos los derechos reservados.**

Este proyecto de software, incluyendo todo su código fuente, scripts de GDScript, lógica de programación, arquitectura de máquina de estados, layouts de escenas y documentación técnica asociada, es propiedad exclusiva y con propiedad intelectual reservada de **Mathias Capote**.

*   **Prohibida la Copia o Clonación:** No se concede permiso para descargar, clonar, copiar, bifurcar (*fork*) ni redistribuir este código en repositorios públicos o privados con el fin de publicar, vender o lucrarse con este juego bajo ningún otro nombre de desarrollador.
*   **Prohibido el Uso Comercial:** Queda estrictamente prohibida la explotación comercial de este software en cualquier tienda de aplicaciones móviles (Google Play Store, Apple App Store, etc.) sin la autorización expresa y firmada por escrito del autor original.
*   **Uso con Fines Educativos:** Se permite la visualización del código en este repositorio únicamente con propósitos educativos de análisis arquitectónico o aprendizaje de GDScript.

Cualquier infracción a estos derechos de propiedad intelectual será reportada inmediatamente bajo la ley de derechos de autor digital (**DMCA**) de GitHub y las plataformas de distribución pertinentes.
