# Summary
- from Ubuntu Xenial
- QGIS from git repo branch master (actually v2.99)
- GDAL 2.1.3
- libkml from git repo branch master
- libecw 2-3.3-2006-09-06

## Running the image
To allow access through ssh session:
```
docker run --rm --name qgis01 -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $HOME/.Xauthority:/data/.Xauthority -e 
"DISPLAY=$DISPLAY" --net=host -v /share:/vmshare:rw pci06/qgis
```
where the value of DISPLAY could be for example: localhost:10.0

## To run qgis through ssh
```
ssh -t YOU_QGIS_SSH_HOST docker exec -it  qgis01 /opt/qgis/bin/qgis
```

