# UnixRemoteBackup
Script for configuring backup automation

Este script sólo copia los archivos modificados o nuevos, así que evita recopiar todo el contenido de la carpeta elegida.
Además, le he incorporado bastantes controles de errores, por lo que ahora es más fácil saber si hay algo mal en algún sistema. Entre otras cosas compruebo que exista disco libre suficiente para lo que queremos copiar, por lo que si se configura mal el script o hay algún error extra, se evita que se llene el disco.
El Script también crea un log en la propia carpeta de copia con información del último back-up y de las operaciones que ha realizado.

**Nota: Es recomendable probar en local antes de ponerlo en el Crontab para ver que las rutas de los directorios son correctos. Cualquier duda me comentais.
Os dejo también por aquí la descripción del script:
backup.sh a script to back-copy files to a mounted remote directory
Usage - backup.sh machine_name mount_directory local_directory
                 - 1) machine_name is the name of your machine-or-user on box2
                 - 2) mount_directory is the LOCAL directory in which remote dir will be mounted 				(Name has to match with a local directory to mount correctly and must be empty)
                 - 3) local_directory is the local directory that will be copied (backed-up) to the remote machine
**It is NEEDED to use the crontab as ROOT - if not mount command will not work.
Example of use with the Crontab:
05 2 * * Mon /home/oscar/Escritorio/Scripts/backup_v1.3.sh brisa /backup /home/oscar box2.dep.usal.es
This will:
1- mount the remote directory of box2:brisa on /backup
2- copy the whole /home/oscar dir (but just the new/modified files) on the mounted dir /backup (and thus, on box2) at 2:05AM every Monday

Known common Error Troubleshoting:
**Mount Partition filesystem error** Install nfs-common drivers:
sudo apt-get install nfs-common
**Start the service
sudo service portmap start

1.4 Version July 2019 - Oscar G. Velasco - Cic Lab-19
    * Added rsync command for copying instead of cp
  - 1.3 Version March 2019 - Oscar G. Velasco - Cic Lab-19
    *added umount error code checking
  - 1.2 Version July 2018 - Oscar G. Velasco - Cic Lab-19

chicken chicken chicken chicken chicken chicken chicken chicken
