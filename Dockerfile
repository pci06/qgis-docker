FROM nerdnobs/xenial
ENV PATH=/opt/qgis/bin:/opt/gdal/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/libecw/lib:/opt/gdal/lib:/opt/libkml/lib
ENV	QT_SELECT=5
ENV PYTHONPATH=/opt/gdal/lib/python3.5/site-packages/
#ENV CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0 -Wabi-tag"
RUN wget http://download.osgeo.org/gdal/2.1.3/gdal213.zip && wget http://meuk.technokrat.nl/libecwj2-3.3-2006-09-06.zip && apt update && devBuildDeps='build-essential qtcreator libbz2-dev libcrypto++-dev libexpat1-dev libfcgi-dev libgeos-dev libgsl0-dev libjpeg8-dev libpq-dev libproj-dev libqca-qt5-2-dev libqt5scintilla2-dev libqt5svg5-dev libqt5webkit5-dev libqt5xmlpatterns5-dev libqwt-qt5-dev libspatialindex-dev libspatialite-dev libsqlite3-dev libutil-freebsd-dev pyqt5-dev pyqt5-dev-tools python3-cxx-dev python3-dev python3-sip-dev qtbase5-dev qtbase5-dev-tools qtdeclarative5-dev qtdeclarative5-private-dev qtpositioning5-dev qtscript5-dev qttools5-dev qttools5-dev-tools libboost-dev liburiparser-dev libminizip-dev bison cmake flex g++ gcc git' && apt install -y --no-install-recommends bash-completion libqca-qt5-2-plugins libqt5positioning5 libqt5positioning5-plugins libqwt-headers libqwt-qt5-6 lighttpd locales make openjdk-8-jdk pkg-config poppler-utils python3 python3-numpy python3-psycopg2 python3-yaml python3-future python3-pip python3-pyqt5 python3-pyqt5.qsci python3-pyqt5.qtpositioning python3-pyqt5.qtsql python3-pyqt5.qtsvg python3-pyqt5.qtwebkit python3-pyqt5.qtwebsockets python3-sip qca-qt5-2-utils qtdeclarative5-privatewidgets-plugin spawn-fcgi unzip vim wget xauth xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable xvfb $devBuildDeps && unzip libecwj2-3.3-2006-09-06.zip && cd libecw* && ./configure --prefix=/opt/libecw && make -j $(nproc) && mkdir -p /opt/libecw/include/ && make install && rm -rf /libecw* && cd / && git clone https://github.com/libkml/libkml && cd libkml* && mkdir -p build && cd build && rm -rf * && cmake -DCMAKE_INSTALL_PREFIX:PATH=/opt/libkml .. && make && mkdir -p /opt/libkml/lib && make install && rm -rf /libkml* && cd / && unzip gdal213.zip && cd gdal* && PYTHON=python3 ./configure --prefix=/opt/gdal --with-ecw=/opt/libecw --with-libkml-inc=/opt/libkml/include/ --with-cryptopp --with-libkml-lib=/opt/libkml/lib --with-jpeg --with-java=/usr --with-python && make -j $(nproc) && make install && rm -rf /gdal* && cd / && find /opt/ -iname '*.pc' -exec cp '{}' /usr/share/pkgconfig/ ';' && ln -nfs /usr/include/x86_64-linux-gnu/qt5 /usr/include/ && ln -nfs /usr/include/QtCrypto /usr/include/qt5/ && cd / && git clone git://github.com/qgis/QGIS.git && cd /QGIS && mkdir -p build && cmake -DCMAKE_INSTALL_PREFIX=/opt/qgis -DQWT_INCLUDE_DIR=/usr/include/qwt -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPYTHON_EXECUTABLE=/usr/bin/python3 -DQSCINTILLA_INCLUDE_DIR=/usr/include/qt5 -DWITH_DESKTOP=ON  -DWITH_SERVER=OFF -DBUILD_TESTING=OFF && make -j $(nproc) && make install && rm -rf /QGIS* && apt purge -y $devBuildDeps
RUN echo "# QGIS libraries" >> /etc/ld.so.conf.d/qgis.conf
RUN echo "/opt/qgis/lib" >> /etc/ld.so.conf.d/qgis.conf
RUN echo "/opt/gdal/lib" >> /etc/ld.so.conf.d/qgis.conf
RUN echo "/opt/libkml/lib" >> /etc/ld.so.conf.d/qgis.conf
RUN echo "/opt/libecw/lib" >> /etc/ld.so.conf.d/qgis.conf
RUN ldconfig
ENTRYPOINT "/opt/qgis/bin/qgis"
