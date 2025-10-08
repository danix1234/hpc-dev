FROM fedora

RUN dnf update -y && dnf install @development-tools neovim libX11-devel -y && dnf clean all

RUN mkdir -p /root/hpc && \ 
    wget -O /root/hpc/hpc.zip https://www.moreno.marzolla.name/teaching/HPC/HPC2526.zip && \
    unzip /root/hpc/hpc -d /root/hpc
    
