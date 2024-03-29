FROM debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    vim \
    curl \
    cmake \
    libeigen3-dev \
    make \
    gdb \
    openssh-server \
    wget \
    clang llvm ninja-build \
    libboost-all-dev clang-tidy \
    xorg-dev libglfw3-dev libglu1-mesa-dev libxkbcommon-dev
    # libxss-dev libxxf86vm-dev libxkbfile-dev libxv-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \


WORKDIR /usr/include
RUN ln -sf eigen3/Eigen Eigen

ENV CC=clang CXX=clang++

# Install pmp-library
WORKDIR ${HOME}
RUN git clone https://github.com/pmp-library/pmp-library.git /workspaces/part_thickness/pmp-library
WORKDIR /workspaces/part_thickness/pmp-library
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS=-stdlib=libstdc++ -DPMP_STRICT_COMPILATION=OFF  \
    -DBUILD_SHARED_LIBS=OFF .
RUN make
RUN make install
RUN cd tests && ctest --output-on-failure