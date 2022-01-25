FROM ubuntu:18.04

# File Author / Maintainer
MAINTAINER Josh Harrison <joshua.grant.harrison@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src

RUN apt-get update && apt-get install -y software-properties-common gcc && \
    add-apt-repository -y ppa:deadsnakes/ppa

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
RUN apt-get install libfile-which-perl
RUN apt-get install -y unzip
RUN apt-get install -y build-essential
#Ugh python
RUN apt-get install -y python2.7
RUN apt-get install -y python

#bwa
RUN git clone https://github.com/audreyt/Text-LevenshteinXS && \
  cd Text-LevenshteinXS && \
  perl Makefile.PL && \
  make && \
  make install

#cd-hit
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

#Copy all the stuff in the local bin for this Nextflow workflow (python and perl scripts)
COPY ./bin/*  /usr/local/bin

#Bowtie 2
RUN wget https://github.com/BenLangmead/bowtie2/releases/download/v2.2.9/bowtie2-2.2.9-linux-x86_64.zip && \
    unzip bowtie2-2.2.9-linux-x86_64.zip && \
    rm bowtie2-2.2.9-linux-x86_64.zip && \
    cd bowtie2-2.2.9/

ENV PATH=${PATH}:/usr/src/bowtie2-2.2.9
