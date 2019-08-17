# websiteupdater

Este proyecto tiene como objetivo actualizar un sitio web que ya está instalado, con nuevo contenido.
Supone que existe el contenido de dos directorios con el directorio destino (tiene el código viejo) y el origen (tiene el código nuevo)

Los pasos a seguir serán los siguientes:
1) Obtener una lista de archivos nuevos, o sea que existan en el directorio origen pero no en el destino
2) Obtener una lista de archivos eliminados, o sea que existan en el directorio destino pero no en el origen
3) Obtener una lista de archivos actualizados, o sea archivos que existan en ambos directorios y tienen diferente contenido
4) Crear un directorio adonde almacenar el resultado del procesamiento
5) Guardar la lista de archivos a eliminar en archivos de texto.
6) Copiar los archivos nuevos al directorio de archivos procesados conservando la estructura de directorios
7) Copiar los archivos actualizados al directorio de archivos procesados conservando la estructura de directorios

