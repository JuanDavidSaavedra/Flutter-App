# 🚴 GreenGo Logistics - Flutter Delivery Tracking App

Una aplicación móvil desarrollada en Flutter para la gestión y seguimiento de entregas sostenibles en bicicleta. Diseñada para repartidores y supervisores de GreenGo Logistics, una startup ficticia que coordina repartidores en bicicleta para entregas ecológicas.

# Para ejecutar la app:
Si modificas el .yaml:
flutter pub get

Si vas a ejecutar todo el código:
flutter clean
flutter pub get
flutter run


## 🎯 Características

### 👨‍💼 Modo Repartidor
- **Lista de entregas pendientes**: Visualización clara de las entregas asignadas
- **Marcado rápido de entregas**: Confirmación de entrega con un solo toque
- **Interfaz intuitiva**: Diseño moderno y fácil de usar
- **Barra de progreso**: Seguimiento visual del progreso de entregas
- **Animaciones fluidas**: Experiencia de usuario mejorada

### 👩‍💼 Modo Supervisor
- **Dashboard en tiempo real**: Resumen completo de todas las entregas
- **Estadísticas visuales**: Porcentaje de completado, totales y métricas clave
- **Vista por repartidor**: Agrupación de entregas por cada repartidor
- **Gestión centralizada**: Monitorización del progreso del equipo completo

### 🎨 Diseño y Experiencia de Usuario
- **Tema personalizado**: Colores verdes consistentes con la marca ecológica
- **Imágenes customizadas**: Logo, bicicleta de reparto y patrones únicos
- **Animaciones fluidas**: Transiciones suaves y feedback visual
- **Responsive**: Adaptable a diferentes tamaños de pantalla
- **Material Design 3**: Implementación de las últimas guías de diseño

### 💾 Persistencia de Datos
- **Almacenamiento local**: Uso de SharedPreferences para guardar el estado
- **Datos simulados**: Lista inicial de entregas para demostración
- **Estado persistente**: Los datos sobreviven a reinicios de la aplicación

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.0+**: Framework de UI para aplicaciones nativas compiladas
- **Dart**: Lenguaje de programación moderno y type-safe
- **Provider**: Gestión de estado simple y efectiva
- **Shared Preferences**: Almacenamiento persistente de datos
- **Material Design 3**: Sistema de diseño moderno de Google

## 🚀 Instalación y Ejecución

### Prerrequisitos
- Flutter SDK (versión 3.0 o superior)
- Dart SDK
- Dispositivo móvil o emulador
- IDE recomendado: Visual Studio Code

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/green-go-logistics.git
   cd green-go-logistics
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

### Ejecución en Diferentes Plataformas

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/
│   └── delivery_model.dart   # Modelo de datos Delivery
├── providers/
│   └── delivery_provider.dart # Gestión de estado con Provider
├── screens/
│   ├── home_screen.dart      # Pantalla principal con pestañas
│   ├── delivery_person_screen.dart # Pantalla del repartidor
│   └── supervisor_screen.dart # Pantalla del supervisor
├── theme/
│   └── app_theme.dart        # Tema personalizado de la app
└── widgets/
    └── logo_widget.dart      # Widget del logo personalizado

assets/
├── images/
│   ├── logo.png             # Logo principal de la aplicación
│   ├── logo_white.png       # Logo para fondos oscuros
│   ├── delivery_bike.png    # Ilustración de bicicleta de reparto
│   └── background_pattern.png # Patrón de fondo personalizado
```

## 🎨 Personalización

### Colores de la Marca
Los colores principales están definidos en `lib/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF00C853);    // Verde principal
static const Color primaryDark = Color(0xFF00A844);     // Verde oscuro
static const Color primaryLight = Color(0xFF5EFC82);    // Verde claro
```

### Imágenes Personalizadas
Para cambiar las imágenes, reemplaza los archivos en `assets/images/`:
- `logo.png` - Logo principal (recomendado: 512x512px)
- `logo_white.png` - Logo para fondos oscuros
- `delivery_bike.png` - Ilustración de bicicleta
- `background_pattern.png` - Patrón de fondo

## 🔧 Funcionalidades Técnicas

### Gestión de Estado
```dart
// Ejemplo de uso del Provider
final deliveryProvider = Provider.of<DeliveryProvider>(context);
deliveryProvider.markAsDelivered(deliveryId);
```

### Persistencia de Datos
```dart
// Los datos se guardan automáticamente usando SharedPreferences
await prefs.setStringList('deliveries', deliveriesJson);
```

### Navegación
- **TabBar**: Navegación entre Repartidor y Supervisor
- **TabBarView**: Contenido dinámico por pestaña

## 🧪 Testing

### Ejecutar tests
```bash
flutter test
```

### Estructura de Tests
```
test/
├── widget_test.dart     # Tests de widgets
├── provider_test.dart   # Tests del provider
└── model_test.dart      # Tests de modelos
```

## 📦 Dependencias

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| `provider` | ^6.1.0 | Gestión de estado |
| `shared_preferences` | ^2.2.2 | Almacenamiento local |
| `cupertino_icons` | ^1.0.2 | Iconos de iOS |

## 🚀 Despliegue

### Build para Producción

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autores

- **Juan David Saavedra González - 2214111** - *Desarrollo inicial* - [TuUsuarioGitHub](https://github.com/tuusuario)

---

**Desarrollado con 💚 y Flutter para Entornos de Programación Grupo E1 - UIS**
