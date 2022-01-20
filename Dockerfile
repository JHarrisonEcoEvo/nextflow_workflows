# Set the base image to debian jessie
FROM ubuntu:18.04

# File Author / Maintainer
MAINTAINER Josh Harrison <joshua.grant.harrison@gmail.com>

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3.6 python3-distutils python3-pip python3-apt

RUN apt-get install -y make
RUN apt-get install -y wget

#WORKDIR /usr/src

RUN wget https://github.com/weizhongli/cdhit/releases/download/V4.8.1/cd-hit-v4.8.1-2019-0228.tar.gz && \
	tar xfz cd-hit-v4.8.1-2019-0228.tar.gz && \
	rm cd-hit-v4.8.1-2019-0228.tar.gz && \
	cd cd-hit-v4.8.1-2019-0228 && \
	make && \
	cd cd-hit-auxtools && \
	make

ENV PATH=${PATH}:/usr/src/cd-hit-v4.8.1-2019-0228:/usr/src/cd-hit-v4.8.1-2019-0228/cd-hit-auxtools

# install vsearch
RUN wget https://github.com/torognes/vsearch/archive/v2.21.1.tar.gz && \
 tar xzf v2.21.1.tar.gz && \
cd vsearch-2.21.1 && \
./autogen.sh && \
./configure CFLAGS="-O3" CXXFLAGS="-O3" && \
make && \
make install

#install bwa

RUN git clone https://github.com/lh3/bwa.git
RUN cd bwa; make

#install samtools

#Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
	tar jxf samtools-1.9.tar.bz2 && \
	rm samtools-1.9.tar.bz2 && \
	cd samtools-1.9 && \
	./configure --prefix $(pwd) && \
	make
