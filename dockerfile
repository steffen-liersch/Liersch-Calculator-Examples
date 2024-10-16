#:----------------------------------------------------------------------------
#:
#:  Copyright © 2023-2024 Steffen Liersch
#:  https://www.steffen-liersch.de/
#:
#:----------------------------------------------------------------------------

FROM frolvlad/alpine-fpc
#FROM alpine:latest

# TODO: Add dotnet8-sdk
RUN apk --update add bash file mc nano deno nodejs go php python3 && rm -rf /var/cache/apk/*

# Set up .NET 8.0
RUN mkdir /dotnet
RUN wget https://dot.net/v1/dotnet-install.sh -O /dotnet/dotnet-install.sh
RUN chmod +x /dotnet/dotnet-install.sh 
RUN /dotnet/dotnet-install.sh --channel 8.0 --install-dir /dotnet
ENV DOTNET_ROOT="/dotnet/.dotnet"
ENV PATH="${PATH}:/dotnet"

# Set up Java
RUN wget -O - https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.4%2B7/OpenJDK21U-jdk_x64_alpine-linux_hotspot_21.0.4_7.tar.gz | tar -xz
ENV JAVA_HOME="/jdk-21.0.1+12"

# Set up Maven for Java
RUN wget -O - https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz | tar -xz
ENV PATH="${PATH}:/apache-maven-3.9.6/bin"

# Set up Julia
# - https://julialang.org/downloads/
# - https://julialang.org/downloads/platform/
RUN wget -O - https://julialang-s3.julialang.org/bin/musl/x64/1.11/julia-1.11.0-rc2-musl-x86_64.tar.gz | tar -xz
ENV PATH="${PATH}:/julia-1.11.0-rc2/bin"
RUN julia -e 'using Pkg; Pkg.add("JSON")'

COPY . /calculator
RUN chmod +x /calculator/*.sh
RUN chmod +x /calculator/**/*.sh
 
RUN echo -e "#!/bin/bash\n\necho -e \"\\n\$DOCKER_IMAGE_INFO\"\nuname -sr\necho" > /root/.bashrc
RUN chmod +x /root/.bashrc 
ENV ENV="/root/.bashrc"

LABEL Description="Alpine with Liersch Calculator Examples" Vendor="Steffen Liersch" Version="1.0.0"
ENV DOCKER_IMAGE_INFO="Alpine with Liersch Calculator Examples"
