FROM archlinux/archlinux:base-devel-20250119.0.299468

RUN echo 'nameserver 9.9.9.9' >> /etc/resolv.conf

RUN pacman -Sy --noconfirm \
      bash clang colordiff coreutils \
      diffpdf diffutils dos2unix dotnet-sdk fakeroot ffmpeg file findutils fzf \
      gawk gcc git go gradle graphviz grep grml-zsh-config groovy guetzli gzip gvim \
      htop httpie hyperfine inetutils inotify-tools iproute2 iputils jdk-openjdk jq less \
      knot magic-wormhole make man-db man-pages mercurial moreutils \
      neovim net-tools nmap nodejs npm openssh \
      p7zip patch pdfgrep perl perl-rename pygmentize python-pip ripgrep rsync ruby rustup \
      screenfetch sed strace sudo tar tcpdump time tmux unzip which \
      yarn yt-dlp zip zsh zsh-completions

RUN useradd -m seckinger -g wheel
RUN chsh -s /bin/zsh seckinger
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN visudo -c
USER seckinger
WORKDIR /home/seckinger

RUN rm .zshrc
RUN mkdir conf && cd conf && git init && \
      git remote add origin https://github.com/jeysal/dotfiles && \
      git fetch && git checkout cde75be3b4f3029938772aaa2fc52f46a9250f66 && \
      git submodule init && git submodule update && \
      ./install.sh && cd ..

RUN git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru

RUN paru -Sy --noconfirm fnm-bin zsh-theme-powerlevel10k-bin-git

RUN fnm install

ENTRYPOINT /bin/zsh
