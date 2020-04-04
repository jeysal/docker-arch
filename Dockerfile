FROM archlinux:20200306
RUN pacman -Sy --noconfirm \
      bash clang coreutils \
      diffutils dos2unix fakeroot ffmpeg file findutils fzf \
      gawk gcc git go gradle graphviz grep grml-zsh-config groovy guetzli gzip gvim \
      htop httpie inetutils iproute2 iputils jdk-openjdk jq less \
      make man-db man-pages mercurial nmap nodejs npm openssh \
      p7zip patch pdfgrep perl pygmentize python-pip ripgrep rsync ruby rustup \
      scala screenfetch sed strace sudo tar time tmux unzip watchman which \
      yarn youtube-dl zip zsh zsh-completions

RUN useradd -m seckinger -g wheel
RUN chsh -s /bin/zsh seckinger
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN visudo -c
USER seckinger
WORKDIR /home/seckinger

RUN git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay

RUN yay -S --noconfirm neovim-nightly zsh-theme-powerlevel10k-git

RUN rm .zshrc
RUN mkdir conf && cd conf && git init && \
      git remote add origin https://github.com/jeysal/dotfiles && \
      git fetch && git checkout fd872b4ec5a74c00adfb4d2d989a94a80570a839 && \
      git submodule init && git submodule update && \
      ./install.sh && cd ..

ENTRYPOINT /bin/zsh
