FROM archlinux:base-20230702.0.161694
RUN pacman -Sy --noconfirm \
      bash clang colordiff coreutils \
      diffpdf diffutils dos2unix dotnet-sdk fakeroot ffmpeg file findutils fzf \
      gawk gcc git go gradle graphviz grep grml-zsh-config groovy guetzli gzip gvim \
      htop httpie hyperfine inetutils inotify-tools iproute2 iputils jdk-openjdk jq less \
      knot magic-wormhole make man-db man-pages mercurial moreutils \
      neovim net-tools nmap nodejs npm openssh \
      p7zip patch pdfgrep perl perl-rename pygmentize python-pip ripgrep rsync ruby rustup \
      screenfetch sed strace sudo tar tcpdump time tmux unzip which \
      yarn youtube-dl zip zsh zsh-completions

RUN useradd -m seckinger -g wheel
RUN chsh -s /bin/zsh seckinger
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN visudo -c
USER seckinger
WORKDIR /home/seckinger

RUN git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay

RUN yay -Sy --noconfirm zsh-theme-powerlevel10k-git

RUN rm .zshrc
RUN mkdir conf && cd conf && git init && \
      git remote add origin https://github.com/jeysal/dotfiles && \
      git fetch && git checkout 39ecd61d1d192721f5cd27e84b951145eab8a9b6 && \
      git submodule init && git submodule update && \
      ./install.sh && cd ..

ENTRYPOINT /bin/zsh
