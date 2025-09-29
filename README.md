# PRODUCTO ACADEMICO 3 BASE DE DATOS

La empresa DataTrack Solutions, dedicada a la analítica y procesamiento de datos, ha implementado una base de datos relacional para gestionar su información de proyectos, clientes, empleados y finanzas. Para mantener la integridad y confidencialidad de los datos, además de garantizar el acceso adecuado, necesitan realizar consultas avanzadas, gestionar transacciones y establecer vistas para distintos niveles de acceso.

**La base de datos de DataTrack Solutions contiene las siguientes tablas:**
1.	Proyectos: Información sobre los proyectos en curso (ID, nombre del proyecto, fecha de inicio, fecha de fin, cliente_ID).
2.	Clientes: Datos de los clientes de la empresa (ID, nombre, sector, país).
3.	Empleados: Información de los empleados (ID, nombre, posición, salario).
4.	Asignaciones: Registro de la asignación de empleados a proyectos específicos (empleado_ID, proyecto_ID, horas_asignadas, rol).
5.	Finanzas: Información financiera de cada proyecto (proyecto_ID, costo_estimado, costo_real, ingresos).

**Instrucciones para el Estudiante:**

**•	Formulación de Consultas Avanzadas en SQL:**
Construye consultas avanzadas en SQL para obtener la siguiente información:
1.	Lista de proyectos en curso, incluyendo el nombre del cliente y el país, ordenados por fecha de inicio.
2.	Información de los empleados asignados a cada proyecto, mostrando el total de horas asignadas y el rol en el proyecto.
3.	Informe financiero de cada proyecto, que incluya el costo estimado, costo real, y la diferencia entre ambos.
4.	Salarios totales asignados por proyecto, agrupados por posición de los empleados.
**•	Implementación de Transacciones y Control de Concurrencia:**
Diseña una transacción en SQL que permita actualizar el estado financiero de un proyecto (es decir, su costo real e ingresos), garantizando que si ocurre un error durante el proceso de actualización, se reviertan todos los cambios para mantener la integridad de los datos.

**•	Creación de Vistas y Control de Acceso:**
Crea dos vistas SQL:
o	Una vista que permita a los gerentes de proyecto ver únicamente la información de proyectos, clientes y empleados asignados, sin acceso a la información financiera.
o	Otra vista que permita al departamento financiero acceder solo a la información de proyectos y finanzas.
•	Análisis de Seguridad y Eficiencia:
o	Explica brevemente cómo las transacciones, vistas y controles de acceso implementados contribuyen a la seguridad y eficiencia en la gestión de la información en DataTrack Solutions.

