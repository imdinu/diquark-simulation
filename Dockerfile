FROM almalinux:9 as builder

RUN dnf update -y
RUN dnf install -y epel-release xxhash-libs wget rsync
RUN dnf groupinstall -y "Development Tools"

WORKDIR /home

# Download ROOT, Pythia, and Delphes
RUN wget https://root.cern/download/root_v6.30.02.Linux-almalinux9.3-x86_64-gcc11.4.tar.gz
RUN tar -xzvf root_v6.30.02.Linux-almalinux9.3-x86_64-gcc11.4.tar.gz

RUN wget https://www.pythia.org/download/pythia83/pythia8310.tgz
RUN tar -zxf pythia8310.tgz

RUN wget http://cp3.irmp.ucl.ac.be/downloads/Delphes-3.5.0.tar.gz
RUN tar -zxf Delphes-3.5.0.tar.gz

# Compile Pythia
WORKDIR /home/pythia8310
RUN source /home/root/bin/thisroot.sh && ./configure --prefix=/home/pythia8310 && make -j 8 && make install

# Set Pythia Environment Variable
ENV PYTHIA8="/home/pythia8310"

# Compile Delphes with Pythia
WORKDIR /home/Delphes-3.5.0
RUN source /home/root/bin/thisroot.sh && make -j 8 HAS_PYTHIA8=true PYTHIA8_INCLUDE=${PYTHIA8}/include PYTHIA8_LIBRARY=${PYTHIA8}/lib


# Runtime Image
FROM almalinux:9 as runtime

RUN dnf install -y xxhash-libs tbb freetype gcc-c++ libstdc++-devel

# Copy compiled Delphes and Pythia
COPY --from=builder /home/Delphes-3.5.0 /home/Delphes-3.5.0
COPY --from=builder /home/pythia8310 /home/pythia8310

# Copy ROOT
COPY --from=builder /home/root /home/root

# Set environment variables for runtime
ENV PYTHIA8="/home/pythia8310"
ENV LD_LIBRARY_PATH="/home/root/lib:/home/pythia8310/lib:${LD_LIBRARY_PATH}"

WORKDIR /home
COPY cards /home/cards
COPY run_simulation.sh /home/run_simulation.sh
RUN chmod +x /home/run_simulation.sh
RUN mkdir  -p /home/output
CMD run_simulation.sh | tee output/01_gg_bbar.log

