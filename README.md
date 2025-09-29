# README BY CHATGPT
# StuTrac - Gestor de Estudiantes

Una aplicación móvil desarrollada en Flutter para la gestión integral de estudiantes, cursos y matrículas académicas.

## 📱 Descripción

StuTrac es una aplicación de gestión académica que permite administrar estudiantes, cursos y sus respectivas matrículas de manera eficiente y moderna. La aplicación consume una API REST de desarrollo propio para el control de estudiantes y materias.

## ✨ Características

### 🎓 Gestión de Estudiantes
- **Listado completo** de estudiantes con búsqueda en tiempo real
- **Creación** de nuevos estudiantes con validación de datos
- **Edición** de información existente
- **Eliminación** de registros
- **Vista detallada** con información completa y cursos matriculados

### 📚 Gestión de Cursos
- **Creación** de cursos con nombre y créditos
- **Visualización** de cursos disponibles
- **Integración** con el sistema de matrículas

### 📋 Sistema de Matrículas
- **Matriculación** de estudiantes en cursos
- **Gestión de notas** por matrícula
- **Visualización** de cursos por estudiante
- **Seguimiento académico** completo

## 🎨 Diseño

La aplicación cuenta con un diseño moderno y limpio que incluye:

- **Material Design 3** con esquemas de color personalizados
- **Gradientes sutiles** y sombras para profundidad visual
- **Iconos redondeados** y tipografía moderna
- **Cards elevadas** con bordes redondeados
- **Colores temáticos** por sección:
  - 🔵 Azul para estudiantes
  - 🟢 Verde para cursos  
  - 🟠 Naranja para matrículas
- **Interfaz responsiva** y amigable al usuario

## 🏗️ Arquitectura

### Estructura del Proyecto
```
lib/
├── models/           # Modelos de datos
│   ├── student.dart
│   ├── course.dart
│   └── student_course.dart
├── services/         # Servicios de API
│   └── api_service.dart
├── screens/          # Pantallas principales
│   ├── students_list_screen.dart
│   ├── student_detail_screen.dart
│   ├── edit_student_screen.dart
│   └── form_screen.dart
├── widgets/          # Componentes reutilizables
│   ├── student_card.dart
│   ├── student_info_card.dart
│   ├── search_field.dart
│   ├── courses_list.dart
│   ├── student_form.dart
│   ├── course_form.dart
│   └── enrollment_form.dart
└── main.dart         # Punto de entrada
```

### Patrones Implementados
- **Separación de responsabilidades** con modelos, servicios y UI
- **Widgets reutilizables** para componentes comunes
- **Gestión de estado** con StatefulWidget
- **Manejo de errores** y estados de carga
- **Validación de formularios** integrada

## 🔌 API Integration

La aplicación consume una **API REST de desarrollo propio** que proporciona endpoints para:

### Estudiantes
- `GET /students` - Obtener todos los estudiantes
- `POST /students` - Crear nuevo estudiante
- `PUT /students/{id}` - Actualizar estudiante
- `DELETE /students/{id}` - Eliminar estudiante

### Cursos
- `GET /courses` - Obtener todos los cursos
- `POST /courses` - Crear nuevo curso

### Matrículas
- `GET /student_courses` - Obtener todas las matrículas
- `GET /student_courses/student/{id}` - Obtener cursos de un estudiante
- `POST /student_courses` - Crear nueva matrícula

## 🚀 Instalación y Configuración

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/davzshaw/stutra
cd stutrac
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar la API**
   - Asegúrate de que la API esté ejecutándose
   - Verifica la URL base en `lib/services/api_service.dart`

4. **Ejecutar la aplicación**
```bash
flutter run
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  cupertino_icons: ^1.0.2
```

## 🔧 Configuración de la API

La aplicación está configurada para conectarse a una API local. Para cambiar la configuración:

1. Abrir `lib/services/api_service.dart`
2. Modificar la variable `baseUrl` con tu endpoint
3. Asegurar que la API esté disponible y funcionando

## 📱 Funcionalidades por Pantalla

### Pantalla Principal (Lista de Estudiantes)
- Búsqueda en tiempo real por nombre, apellido o ID
- Cards con información resumida de cada estudiante
- Botones de acción rápida (editar/eliminar)
- Botón flotante para agregar nuevos estudiantes

### Detalle de Estudiante
- Información completa del estudiante
- Lista de cursos matriculados con notas
- Botones para editar o eliminar
- Indicadores visuales de rendimiento académico

### Formularios
- Validación en tiempo real
- Campos con iconos descriptivos
- Mensajes de error claros
- Estados de carga durante operaciones

## 🎯 Características Técnicas

- **Manejo de estados** asíncrono con Future/async-await
- **Gestión de errores** robusta con try-catch
- **Validación de formularios** integrada
- **Navegación** fluida entre pantallas
- **Feedback visual** para todas las operaciones
- **Diseño responsivo** para diferentes tamaños de pantalla

## 🤝 Contribución

Este proyecto fue desarrollado como una aplicación de gestión académica con fines educativos y de demostración de capacidades en Flutter y desarrollo de APIs.

## Video

[Click aquí](https://youtu.be/2_JILV7QAMk)

---

**Desarrollado con estres usando Flutter**