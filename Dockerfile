FROM phusion/baseimage

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# ...put your own build instructions here...
RUN apt-get update && apt-get install -y \
    git \
    libxml2-dev \
    python \
    build-essential \
    make \ 
    gcc \
    python-dev \
    locales

RUN apt-get install -y freetype* libpng*
RUN apt-get install -y gfortran
RUN apt-get install -y python-pip
RUN apt-get build-dep -y python-numpy python-scipy

RUN pip install pip --upgrade
RUN pip install distribute==0.6.49
RUN easy_install pyparsing
RUN easy_install tornado
RUN easy_install matplotlib
RUN easy_install numpy
RUN easy_install scipy
RUN easy_install pandas
RUN easy_install scikit-learn
RUN easy_install ipython[all]

RUN pip install pymc==2.3.2

#RUN dpkg-reconfigure locales && \
#    locale-gen C.UTF-8 && \
#    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup iPython boot
RUN mkdir /etc/service/ipython
RUN echo "#!/bin/sh\nexec ipython notebook --pylab=inline --ip=* --port=80 --MappingKernelManager.time_to_dead=10 --MappingKernelManager.first_beat=3 >>/var/log/ipython.log 2>&1" > /etc/service/ipython/run
RUN chmod 755 /etc/service/ipython/run

ADD id_dsa.pub /tmp/id_dsa.pub
RUN cat /tmp/id_dsa.pub >> /root/.ssh/authorized_keys && rm -f /tmp/id_dsa.pub

EXPOSE 80

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]