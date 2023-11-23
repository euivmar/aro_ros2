# ARO ROS2 Dockerfile

En este documento se describe el procedimiento para compilar y ejecutar una imagen Docker con el software necesario para llevar a cabo las prácticas de la asignatura de Automática y Robótica. La imagen utilizada parte de la imagen oficial de NVIDIA, permitiendo así la aceleración por GPU.

Los scripts de instalación de ROS2, gazebo y el software necesarios están suministrados a través de [ros2_setup_scripts_ubuntu](https://github.com/euivmar/ros2_setup_scripts_ubuntu#main).

## Compilar la imagen

Para compilar la imagen, utilizamos la orden `docker build`. Con el argumento `-t` le asignamos el tag que queramos (nombre:version).

```sh
docker build . -t {usuario}/ros2-humble-nvidia:{tag}
```

## Push de la imagen a DockerHub

Iniciar sesión en DockerHub:

```sh
docker login
```

Pushear la imagen.

```sh
docker push {usuario}/ros2-humble-nvidia:{tag}
```

## docker-compose

Para crear una instancia de nuestro contenedor, utilizaremos el fichero `docker-compose.yaml`. Este fichero contiene la descripción de la imagen que queremos utilizar. Además, incluye:

1. Las variables de entorno necesarias para utilizar aplicaciones con GUI.
2. Dos volúmenes en el contenedor. Uno de ellos contiene el socket unix de X11 para poder isntanciar interfaces gráficas en el host y el otro monta el directorio actual dentro del contenedor en la ruta `/mnt/scripts`. Esto es muy útil, pues de esta forma podemos modificar los scripts que vayamos a desarrollar desde el PC anfitrión a través del editor de código que queramos y ver los cambios automáticamente reflejados dentro del contenedor.

## Crear el contenedor

```sh
docker compose up -d
```

## Abrir una terminal dentro del contenedor

```sh
docker exec -it ros2 bash
```

## Parar el contenedor

```sh
docker compose stop
```

Podemos comprobar que el estado del contenedor es `Exited()` a través de

```sh
docker ps -a
```

## Arrancar el contenedor

```sh
docker compose start
```

Podemos comprobar que el estado del contenedor es `Up` a través de

```sh
docker ps -a
```

## Eliminar el contenedor

```sh
docker compose down
```

**WARNING: Esta acción elimina el contenedor, los volúmenes y la red que crea por defecto. Esta opción no es reversible.**
