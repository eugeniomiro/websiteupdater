# websiteupdater

Este proyecto tiene como objetivo actualizar un sitio web que ya está instalado con nuevo contenido.
Supone que existe el contenido de dos directorios con el directorio actual y el nuevo
Los pasos a seguir serán los siguientes:
1) Obtener una lista de archivos nuevos, o sea que existan en el directorio nuevo pero no en el actual
2) Obtener una lista de archivos eliminados, o sea que existan en el directorio actual pero no en el nuevo
3) Obtener una lista de archivos actualizados, o sea archivos que existan en ambos directorios
4) Crear un directorio de Backup con todo el contenido actual
5) Remover los archivos del directorio actual que se encuentren en la lista de archivos eliminados
6) Copiar los archivos nuevos del directorio nuevo al actual
7) Copiar los archivos actualizados del directorio nuevo al actual

