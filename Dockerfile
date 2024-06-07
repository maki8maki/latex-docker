FROM ghcr.io/being24/latex-docker-base:latest

ARG TEXLIVE_VERSION=2024

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"
ENV LC_ALL=C

RUN mkdir /tmp/install-tl-unx && \
    curl -L https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${TEXLIVE_VERSION}/install-tl-unx.tar.gz \
    | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
    > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
    -profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin

RUN tlmgr update --self --all && \
    tlmgr install \
    collection-bibtexextra \
    collection-fontsrecommended \
    collection-langenglish \
    collection-langjapanese \
    collection-latexextra \
    collection-latexrecommended \
    collection-luatex \
    collection-mathscience \
    collection-plaingeneric \
    collection-xetex \
    latexmk \
    latexdiff \
    siunitx \
    newtx \
    svg \
    latexindent && \
    curl -L -O https://raw.githubusercontent.com/being24/plistings/master/plistings.sty && \
    mv plistings.sty /usr/local/texlive/${TEXLIVE_VERSION}/texmf-dist/tex/latex/listing && \
    chmod +r /usr/local/texlive/${TEXLIVE_VERSION}/texmf-dist/tex/latex/listing/plistings.sty && \
    mktexlsr && \
    curl -L -O https://raw.githubusercontent.com/being24/latex-docker/master/create_font_cache.sh && \
    chmod +x create_font_cache.sh && \
    ./create_font_cache.sh && \
    rm create_font_cache.sh && \
    useradd -m -u 1000 -s /bin/bash latex

USER latex

WORKDIR /workdir