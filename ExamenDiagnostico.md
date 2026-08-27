# Instituto Tecnológico de Morelia
## Examen Diagnóstico - Fundamentos de Ingeniería de Software

**Materia:** Tópicos Selectos de Tecnologías Web y Móvil  
**Profesor:** Jesús Eduardo Alcaraz Chávez  

---

| **Nombre del alumno:** | Pacheco Gaona Aldo Noé |
| **Fecha:** | 27 – 08 - 2026 |

---

> [!NOTE]
> **Instrucciones:** Responde de manera clara y concisa a cada una de las siguientes preguntas abiertas. El propósito de esta evaluación es medir tus conocimientos previos en Ingeniería de Software.

---

### 1. Metodologías
**¿Cuál es la diferencia principal entre una metodología de desarrollo tradicional (como Cascada) y una metodología ágil (como Scrum) frente a los cambios en los requisitos?**

> A diferencia de un desarrollo tradicional una Metodología ágil se caracteriza en hacer entregables cada cierto periodo corto de tiempo. En caso de scrum estos periodos se llaman sprints,.

---

### 2. Requerimientos
**Explica la diferencia entre requerimientos funcionales y no funcionales, dando un ejemplo de cada uno aplicable a una plataforma web.**

> Los funcionales describen la funcionalidad del sistema mientras que los no funcionales explican como el sistema debe de operar. Por ejemplo:
> 
> * **Funcional**
>   - Los usuarios se deben de poder registrar con correo y contraseña
> 
> * **No Funcional:**
>   - La Aplicación debe de ser compatible con Android y IOS

---

### 3. Arquitectura
**Describe el modelo Cliente-Servidor y explica brevemente cómo se comunican el frontend y el backend en una aplicación web moderna.**

> Es un modelo el cual se caracteriza por que el cliente (Por ejemplo, nuestro navegador) le envía una petición al servidor para que pedir algo (Por ejemplo, el HTML de la página la cual estemos visitando) , el servidor recibe esta solicitud y envía el recurso pedido. 
> 
> El frontend se comunica con el backend principalmente mediante API´s. En donde por ejemplo el front envia una petición a `api/user/getUsers`. El back recibirá esta petición y enviará la respuesta al front

---

### 4. Bases de Datos
**¿En qué escenarios recomendarías utilizar una base de datos relacional (SQL) frente a una no relacional (NoSQL) para el almacenamiento de datos en una aplicación?**

> NoSQL se caracteriza por que sus datos no están tan bien estructurados que SQL, se usa en casos en donde quieres más rapidez en la lectura de datos además NoSQL también es más fácil de escalar que una SQL.
> 
> SQL se usa en casos de que quieras tener en tus tablas estrictas relaciones entre ellas o cuando se necesitan hacer complejos análisis de datos

---

### 5. APIs
**¿Qué es una API REST y qué papel fundamental juega en la integración entre una aplicación móvil y los servidores (backend)?**

> Son un tipo de modelado de API que se base principalmente en el modelo cliente-servidor y el uso de métodos HTTP como GET, POS T, DELETE o UPDATE

---

### 6. Control de Versiones
**Explica la importancia de utilizar Git en un equipo de desarrollo de software y describe brevemente qué es un "merge conflict" (conflicto de fusión).**

> El Git es una herramienta que nos permite controlar los que se sube a nuestro repositorio. Es especialmente útil para equipos de desarrollo ya que nos permite gestionar quien esta subiendo cada cosa y que se sube e incluso si se sube algo que destruye nuestro código nos permitirá volver a una versión a este en donde no esté el código mal. Nos permite trabaja en ramas que son una bifurcación del código principal y cuando hayamos acabado poder hacer un merge a la rama principal para aplicar los cambios hechos a producción. Un merge comflict se produce cuando dos o mas personas editan el mismo archivo de código y Git no sabe con qué versión se debe de quedar.

---

### 7. Pruebas
**¿Qué son las pruebas unitarias (unit testing) y por qué son cruciales para asegurar la calidad del software antes de su paso a producción?**

> Es un tipo de prueba que verifica que nuestro código se comporte como debería. Esta prueba se aplica a secciones pequeñas del código como métodos o clases

---

### 8. POO
**Define los conceptos de encapsulamiento y polimorfismo de la Programación Orientada a Objetos, y menciona cómo ayudan a crear un código más mantenible.**

> * **Encapsulamiento:** Es cuando haces que tus métodos o variables solo sean accesibles por una instancia del mismo objeto.  Nada ni nadie más en el código podría modificar el valor o mandar a llamar un método que esta encapsulado en una clase solo la misma instancia de esa clase
> 
> * **Polimorfismo:** Se usa cuando una clase hereda el método de una clase Padre, pero necesitas que ese método tenga un funcionamiento diferente al de la clase padre. Por ejemplo, si tengo una clase Vehículo con un método llamado VelociadaMaxima y hago dos clases una llamada Carro y otra llamada Camión que heredan el mismo método de la Clase Padre Vehículo. Aquí yo cambiaria el comportamiento del método VelocidadMaxima para que cumpla con los requisitos de cada clase hija.

---

### 9. Patrones de Diseño
**¿Qué es el patrón de arquitectura Modelo-Vista-Controlador (MVC) y cómo ayuda a organizar el código en el desarrollo de software?**

> * **Modelo** – Logica de Negocio
> * **Vista** – UI/UX
> * **Controlador** – Recibe el Input del usuario y se conecta con la lógica de negocio

---

### 10. Seguridad
**Explica la diferencia técnica entre "autenticación" y "autorización" en el contexto de seguridad de una aplicación.**

> La autentificación es la que verifica quien es el usuario que esta entrando en nuestra página y la autorización es que permisos tiene el usuario en nuestra pagina
