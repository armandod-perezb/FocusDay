# FocusDay

FocusDay es una aplicación móvil de productividad diseñada para ayudarte a organizar tus actividades, priorizar tareas y mantener el enfoque en lo realmente importante cada día.

## 📱 Características

- ✅ **Gestión de Tareas**: Crea, edita, elimina y completa tareas fácilmente
- 🎯 **Priorización**: Organiza tareas por prioridad (Alta, Media, Baja)
- 📅 **Vistas por Fecha**: Visualiza tareas por día o semana
- ⏰ **Recordatorios**: Sistema de notificaciones para tareas importantes
- 🎨 **UI Minimalista**: Interfaz limpia y enfocada en la productividad
- 💾 **Almacenamiento Local**: Datos guardados de forma segura en SQLite

## 🏗️ Arquitectura

FocusDay está construido siguiendo los principios de **Clean Architecture**:

```
lib/
├── core/                    # Configuración y utilidades
│   └── injection.dart      # Dependency Injection (GetIt)
├── domain/                 # Capa de Dominio
│   ├── entities/          # Entidades de negocio
│   ├── repositories/      # Interfaces de repositorios
│   └── usecases/          # Casos de uso
├── data/                   # Capa de Datos
│   ├── models/            # Modelos de datos
│   ├── datasources/       # Fuentes de datos (SQLite)
│   └── repositories/      # Implementaciones de repositorios
└── presentation/          # Capa de Presentación
    ├── bloc/              # Estado (BLoC pattern)
    ├── screens/           # Pantallas
    └── widgets/           # Widgets reutilizables
```

### Capas

1. **Domain Layer**: Contiene la lógica de negocio pura
   - Entidades: Modelos de dominio inmutables
   - Repositorios: Interfaces abstractas
   - Use Cases: Casos de uso específicos

2. **Data Layer**: Maneja el almacenamiento y recuperación de datos
   - Models: Implementaciones de entidades con serialización
   - DataSources: SQLite para almacenamiento local
   - Repositories: Implementación de interfaces de dominio

3. **Presentation Layer**: UI y gestión de estado
   - BLoC: Gestión de estado reactiva
   - Screens: Pantallas de la aplicación
   - Widgets: Componentes reutilizables

## 🚀 Instalación

### Requisitos previos

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (para desarrollo móvil)

### Pasos de instalación

1. Clona el repositorio:
```bash
git clone https://github.com/armandod-perezb/FocusDay.git
cd FocusDay
```

2. Instala las dependencias:
```bash
flutter pub get
```

3. Ejecuta la aplicación:
```bash
flutter run
```

## 🧪 Testing

Ejecuta los tests:
```bash
flutter test
```

Para tests con cobertura:
```bash
flutter test --coverage
```

## 📦 Dependencias Principales

- **flutter_bloc**: Gestión de estado
- **get_it**: Inyección de dependencias
- **sqflite**: Base de datos local
- **equatable**: Comparación de objetos
- **intl**: Internacionalización y formato de fechas
- **flutter_local_notifications**: Notificaciones locales

## 🛠️ Desarrollo

### Estructura de Commits

Seguimos el estándar de commits convencionales:
- `feat:` Nueva característica
- `fix:` Corrección de bugs
- `docs:` Cambios en documentación
- `test:` Añadir o modificar tests
- `refactor:` Refactorización de código

### Code Style

El proyecto sigue las guías de estilo de Flutter y Dart. Ejecuta el linter:
```bash
flutter analyze
```

Formatea el código:
```bash
flutter format .
```

## 📝 Uso

1. **Crear una tarea**: Presiona el botón "+" en la pantalla principal
2. **Editar una tarea**: Toca cualquier tarea para editarla
3. **Completar una tarea**: Marca el checkbox junto a la tarea
4. **Cambiar vista**: Usa el icono en la barra superior para alternar entre vista diaria y semanal
5. **Navegar fechas**: Usa las flechas para moverte entre días/semanas

## 🎯 Roadmap

- [ ] Notificaciones push para recordatorios
- [ ] Sincronización en la nube
- [ ] Temas personalizables
- [ ] Estadísticas de productividad
- [ ] Integración con calendario
- [ ] Modo offline mejorado
- [ ] Soporte para subtareas
- [ ] Etiquetas y categorías personalizadas

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Autor

Armando D. Perez B. - [@armandod-perezb](https://github.com/armandod-perezb)

## 🙏 Agradecimientos

- Flutter Team por el excelente framework
- Comunidad de Flutter por los paquetes y recursos
- Todos los contribuidores del proyecto
