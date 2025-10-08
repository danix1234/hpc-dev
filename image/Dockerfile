FROM fedora

RUN dnf update -y && dnf install @development-tools neovim libX11-devel wget curl -y && dnf clean all

RUN mkdir -p /root/hpc && \ 
    wget -O /tmp/hpc.zip https://www.moreno.marzolla.name/teaching/HPC/HPC2526.zip && \
    unzip /tmp/hpc.zip -d /root/
    
