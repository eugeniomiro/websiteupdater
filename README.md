# websiteupdater

Este proyecto tiene como objetivo actualizar un sitio web que ya está instalado, con nuevo contenido.
Supone que existe el contenido de dos directorios con el directorio destino (tiene el código viejo) y el origen (tiene el código nuevo)

Los pasos a seguir serán los siguientes:
1) Obtener una lista de archivos nuevos, o sea que existan en el directorio origen pero no en el destino
2) Obtener una lista de archivos eliminados, o sea que existan en el directorio destino pero no en el origen
3) Obtener una lista de archivos actualizados, o sea archivos que existan en ambos directorios y tienen diferente contenido
3.1) Guardar las tres listas (nuevos, eliminados y actualizados) en archivos de texto.
4) Crear un directorio de Backup con todo el contenido destino (Backup, Backup1, ...)
5) Remover los archivos del directorio destino que se encuentren en la lista de archivos eliminados
6) Copiar los archivos origens del directorio origen al destino	(sin pisar)
7) Copiar los archivos destinoizados del directorio origen al destino (pisando)
8) Eliminar los que no se modificaron :)

