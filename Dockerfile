FROM ubuntu:18.04
LABEL maintainer "fweber <fweber@schutzwerk.com>"

RUN apt update \
  && apt install -y --no-install-recommends \
  make \
  cmake \
  gcc \
  g++ \
  libusb-1.0-0-dev \
  libbluetooth-dev \
  pkg-config \
  libpcap-dev \
  python-numpy \
  python-pyside \
  python-qt4

RUN apt update \
    && apt install -y --no-install-recommends wget

# Install libbtbb (required to decode Bluetooth packets)
RUN wget https://github.com/greatscottgadgets/libbtbb/archive/2018-12-R1.tar.gz -O libbtbb-2018-12-R1.tar.gz --no-check-certificate  \
  && tar -xf libbtbb-2018-12-R1.tar.gz \
  && cd libbtbb-2018-12-R1 \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make \
  && make install

# Install Uberooth tools
RUN wget https://github.com/greatscottgadgets/ubertooth/releases/download/2018-12-R1/ubertooth-2018-12-R1.tar.xz --no-check-certificate \
  && tar xf ubertooth-2018-12-R1.tar.xz \
  && cd ubertooth-2018-12-R1/host \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make \
  && make install 

RUN ldconfig

RUN mkdir /root/shared_folder

CMD ["/bin/bash", "sleep 10 && ubertooth-btle -f -c /root/shared_folder/pipe"]
#CMD ["/bin/bash" ]
