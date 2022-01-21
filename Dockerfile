FROM ubuntu:18.04

# File Author / Maintainer
MAINTAINER Josh Harrison <joshua.grant.harrison@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

RUN apt-get update && apt-get install -y python3.6 python3-distutils python3-pip python3-apt

RUN apt-get install -y apt-utils
RUN apt-get install -y autoconf
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y make
RUN apt-get install -y wget
RUN apt-get install -y libncurses5-dev
RUN apt-get install -y libncursesw5-dev
RUN apt-get install -y install-info
RUN apt-get install -y git-all
RUN apt-get install -y libbz2-dev
RUN apt-get install liblzma-dev

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

#bwa
RUN git clone https://github.com/lh3/bwa.git && \
  cd bwa && \
  make && \
  cp bwa /usr/local/bin/bwa


#Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
	tar jxf samtools-1.9.tar.bz2 && \
	rm samtools-1.9.tar.bz2 && \
	cd samtools-1.9 && \
	./configure --prefix $(pwd) && \
	make

  ENV PATH=${PATH}:/usr/src/samtools-1.9

#bcftools
RUN  wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && \
 tar -vxjf bcftools-1.9.tar.bz2 && \
 rm bcftools-1.9.tar.bz2 && \
 cd bcftools-1.9 && \
 make && \
 make install

#Copy all the stuff for this Nextflow workflow (python and perl scripts)
COPY . .
