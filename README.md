# Alta de usuarios a partir de un fichero CSV con Shell Scripting

# Descripción
El script de Shell permite importar y procesar un archivo CSV que contiene información de usuarios y luego crear los usuarios correspondientes en el sistema. Esta solución es ideal para administrar grandes cantidades de usuarios de manera eficiente.

# Características principales:
- Procesamiento de CSV: El script lee un archivo CSV con datos de usuarios, y extrae la información necesaria para la creación de cuentas.

- Creación automática de usuarios: Los usuarios se crean de forma automática en el servidor de LDAP, utilizando el CSV como entrada, sin intervención manual.

- Validación de campos: El script valida la existencia de campos necesarios  antes de realizar la creación de cuentas.
  
# Casos de uso:
- Administración de sistemas: Ideal para administradores de sistemas que necesitan agregar múltiples usuarios a un servidor o plataforma de manera rápida.

- Automatización de tareas repetitivas: Perfecto para la automatización de tareas en entornos donde se requiera la creación masiva de cuentas de usuario.


## Prerrequisitos
- Una máquina virtual con: Ubuntu server, Ubuntu desktop, Lubuntu, o derivados de Ubuntu.

- Tener instalado slapd (No necesitarás hacer configuraciones complejas ya que en el archivo myscript.conf encontrarás la configuración, con un dominio .local y una OU (Unidad Organizativa) será suficiente).

### Configuración
- El archivo `myscript.conf` contiene las configuraciones predeterminadas necesarias para el funcionamiento del script. Un ejemplo de configuración básica podría ser:

# myscript.conf
- ldapBase="dc=garcia,dc=local"  (El parámetro ldapBase se debe adaptar al nombre de vuestro dominio)
- uidnum="10000"
- longPWD=8


# Instalación y uso
1) Clonar este repositorio.
git clone https://github.com/alvarogarcia1994/Alta-de-usuarios-a-partir-de-CSV.git

2) Acceder a la carpeta del repositorio
cd Alta-de-usuarios-a-partir-de-CSV/...

3) Otorgar permisos de ejecución al script
chmod +x nombre_del_script.sh

4) Ejecutar el script con el fichero CSV como parámetro
./nombre_del_script.sh archivo.csv

# Consideraciones
## Versión 1 - *Mayo 2020*

Esta es la primera versión del script, diseñada para automatizar la creación de usuarios en un sistema LDAP a partir de un archivo CSV. Sin embargo, **no realiza verificaciones exhaustivas sobre los parámetros de entrada**. Los datos del CSV (como el nombre, apellidos, y otros) son procesados y utilizados tal cual, sin comprobar su validez o formato. 

### Características de la versión 1:
- **Creación de usuarios en LDAP**: El script toma los datos del archivo CSV y genera entradas en formato LDIF para ser importadas al servidor LDAP.
- **Sin validación de datos**: Los datos de entrada del CSV se procesan sin realizar ningún tipo de verificación, lo que significa que si el archivo contiene errores o datos mal formateados, estos serán procesados tal cual.
- **Generación de contraseñas aleatorias**: Para cada usuario, se genera una contraseña aleatoria utilizando `openssl`.
- **Automatización del proceso de altas**: El script simplifica y automatiza la creación masiva de usuarios en un sistema LDAP, pero requiere que los datos del archivo CSV estén correctamente estructurados.

### Limitaciones:
- **Sin validación de datos**: Si los datos en el CSV están mal formateados o contienen información incorrecta, el script no verificará ni corregirá estos errores antes de crear los usuarios. Esto podría generar entradas incorrectas o incompletas en el sistema LDAP.

## Versión 2 - *Mayo 2020*

Esta versión introduce mejoras clave en la validación y flexibilidad del script, especialmente en la gestión del archivo CSV de entrada.

### Características principales:
- **Validación de parámetros**: Se incorpora una función para validar que el archivo de entrada no esté vacío y que sea accesible antes de procesarlo.
- **Soporte para parámetros de entrada**: El script ahora acepta el parámetro `-a` o `--archivo` para especificar el archivo CSV de manera más flexible.
- **Manejo de errores**: Si el archivo no se encuentra o no se especifica, el script muestra un mensaje de error y termina su ejecución para evitar problemas.
- **Generación de usuarios en LDAP**: A continuación, el script sigue creando automáticamente entradas para los usuarios en un servidor LDAP, como en la versión anterior.
- **Optimización en la creación de contraseñas**: Las contraseñas se siguen generando aleatoriamente para cada usuario, y se almacenan en un archivo de log.

### Limitaciones:
- Aunque se han mejorado las validaciones, el script todavía asume que los datos del archivo CSV están correctamente estructurados y no realiza una validación exhaustiva de los mismos.

## Versión 3 - *Enero 2025*

La **Versión 3** del script introduce importantes mejoras en la fiabilidad, gestión de errores y optimización del flujo de trabajo. Está diseñada para ser más robusta en entornos de producción y proporciona un manejo de errores más eficiente.

### Características principales:
- **Comprobación avanzada de parámetros**: El script asegura que el archivo de entrada sea válido y accesible antes de continuar con el procesamiento. Si el archivo no se encuentra o no se especifica, el script se detendrá con un mensaje de error claro.
- **Manejo de errores con `ldapadd`**: Se implementa un verificador para asegurarse de que las entradas se agreguen correctamente al servidor LDAP. Si ocurre un error durante la adición de entradas, el script muestra un mensaje y termina con un código de error.
- **Optimización en la lectura del archivo CSV**: El uso de `IFS` mejora la lectura y el procesamiento de datos del archivo CSV, haciendo que el script sea más eficiente.
- **Generación de usuarios LDAP**: Continúa generando automáticamente entradas LDAP para cada usuario a partir de los datos en el archivo CSV. El script sigue generando contraseñas aleatorias y configurando los atributos de usuario correspondientes.
- **Mejora en la legibilidad y claridad**: El código está más organizado, lo que facilita su comprensión y mantenimiento.
  
### Mejoras:
- **Mayor confiabilidad**: Las comprobaciones y el manejo de errores mejorados hacen que este script sea más confiable para entornos de producción.
- **Optimización**: El uso de `IFS` para la lectura de CSV y el manejo de parámetros hacen que el script sea más eficiente y flexible.
- **Mayor control**: El verificador de éxito al agregar entradas al servidor LDAP proporciona un control adicional sobre el proceso, asegurando que las entradas solo se agreguen cuando todo el proceso se haya realizado correctamente.

### Limitaciones:
- Aunque esta versión mejora la fiabilidad y la flexibilidad del script, todavía depende de que los datos en el archivo CSV estén correctamente estructurados.


## Consideraciones
Este script forma parte de una práctica para la asignatura de Administración de Sistemas Informáticos (ASIR/ASIX - M6). Está diseñado con fines educativos para mostrar cómo automatizar procesos en un entorno de servidor LDAP mediante el uso de Shell Script. Si bien el proyecto está pensado para ser un ejemplo de automatización, es importante considerar las limitaciones del script, como la necesidad de un archivo CSV bien estructurado y la falta de validación exhaustiva de los datos de entrada.
