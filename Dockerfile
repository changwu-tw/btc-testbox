FROM phusion/baseimage:0.10.0

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# add bitcoind from the official PPA
# install bitcoind (from PPA) and make
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:bitcoin/bitcoin && \
    apt-get update && \
	apt-get install -y bitcoind make && \
    apt-get install -y vim zsh wget git sudo jq && \
    wget -qO- https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true && \
    wget -qO- https://github.com/jingweno/ccat/releases/download/v1.1.0/linux-amd64-1.1.0.tar.gz | tar -zxf- && \
    cp linux-amd64-1.1.0/ccat /usr/local/bin/ && \
    chmod +x /usr/local/bin/ccat && \
    rm -rf linux-amd64-1.1.0 && \
    echo 'alias cat="ccat"' >> /root/.zshrc && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . /root/btc-testbox
WORKDIR /root/btc-testbox

# expose two rpc ports for the nodes to allow outside container access
EXPOSE 19001 19011
CMD ["/bin/zsh"]