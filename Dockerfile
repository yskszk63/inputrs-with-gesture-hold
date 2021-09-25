# syntax=docker/dockerfile:1
FROM ubuntu:focal
ARG LIBINPUT_REPO="https://gitlab.freedesktop.org/libinput/libinput.git"
ARG LIBINPUT_BRANCH="1.19.0"
ARG INPUTRS_REV="9f019d130e727bd6e18889189bb3a31cd5bd16cd"

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends curl ca-certificates git gcc g++ pkg-config meson check libudev-dev libevdev-dev doxygen graphviz python3-sphinx python3-recommonmark python3-sphinx-rtd-theme python3-pytest-xdist libwacom-dev libcairo2-dev libgtk-3-dev libglib2.0-dev libmtdev-dev && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable --profile minimal && \
    . ~/.cargo/env && \
    mkdir /newroot && \
    cd && \
    git clone "$LIBINPUT_REPO" -b "$LIBINPUT_BRANCH" --depth 1 && \
    cd libinput && \
    meson --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu builddir/ && \
    ninja -C builddir/ && \
    ninja -C builddir/ install && \
    DESTDIR=/newroot ninja -C builddir/ install && \
    cd && \
    cargo new t && \
    cd t && \
    echo 'libc = "0.2.102"' >> Cargo.toml && \
    printf 'input = {git="https://github.com/Smithay/input.rs", rev="%s"}\n' "$INPUTRS_REV" >> Cargo.toml && \
    echo 'dXNlIHN0ZDo6ZnM6OntGaWxlLCBPcGVuT3B0aW9uc307CnVzZSBzdGQ6Om9zOjp1bml4Ojp7ZnM6Ok9wZW5PcHRpb25zRXh0LCBpbzo6e1Jhd0ZkLCBGcm9tUmF3RmQsIEludG9SYXdGZH19Owp1c2Ugc3RkOjpwYXRoOjpQYXRoOwoKdXNlIGlucHV0Ojp7TGliaW5wdXQsIExpYmlucHV0SW50ZXJmYWNlfTsKdXNlIGxpYmM6OntPX1JET05MWSwgT19SRFdSLCBPX1dST05MWX07CgpzdHJ1Y3QgSW50ZXJmYWNlOwoKaW1wbCBMaWJpbnB1dEludGVyZmFjZSBmb3IgSW50ZXJmYWNlIHsKICAgIGZuIG9wZW5fcmVzdHJpY3RlZCgmbXV0IHNlbGYsIHBhdGg6ICZQYXRoLCBmbGFnczogaTMyKSAtPiBSZXN1bHQ8UmF3RmQsIGkzMj4gewogICAgICAgIE9wZW5PcHRpb25zOjpuZXcoKQogICAgICAgICAgICAuY3VzdG9tX2ZsYWdzKGZsYWdzKQogICAgICAgICAgICAucmVhZCgoZmxhZ3MgJiBPX1JET05MWSAhPSAwKSB8IChmbGFncyAmIE9fUkRXUiAhPSAwKSkKICAgICAgICAgICAgLndyaXRlKChmbGFncyAmIE9fV1JPTkxZICE9IDApIHwgKGZsYWdzICYgT19SRFdSICE9IDApKQogICAgICAgICAgICAub3BlbihwYXRoKQogICAgICAgICAgICAubWFwKHxmaWxlfCBmaWxlLmludG9fcmF3X2ZkKCkpCiAgICAgICAgICAgIC5tYXBfZXJyKHxlcnJ8IGVyci5yYXdfb3NfZXJyb3IoKS51bndyYXAoKSkKICAgIH0KICAgIGZuIGNsb3NlX3Jlc3RyaWN0ZWQoJm11dCBzZWxmLCBmZDogUmF3RmQpIHsKICAgICAgICB1bnNhZmUgewogICAgICAgICAgICBGaWxlOjpmcm9tX3Jhd19mZChmZCk7CiAgICAgICAgfQogICAgfQp9CgpmbiBtYWluKCkgewogICAgbGV0IG11dCBpbnB1dCA9IExpYmlucHV0OjpuZXdfd2l0aF91ZGV2KEludGVyZmFjZSk7CiAgICBpbnB1dC51ZGV2X2Fzc2lnbl9zZWF0KCJzZWF0MCIpLnVud3JhcCgpOwogICAgbG9vcCB7CiAgICAgICAgaW5wdXQuZGlzcGF0Y2goKS51bndyYXAoKTsKICAgICAgICBmb3IgZXZlbnQgaW4gJm11dCBpbnB1dCB7CiAgICAgICAgICAgIHByaW50bG4hKCJHb3QgZXZlbnQ6IHs6P30iLCBldmVudCk7CiAgICAgICAgfQogICAgfQp9Cg=='|base64 -d > src/main.rs && \
    cargo update --verbose && \
    cargo build --release && \
    cp target/release/t /newroot/app

FROM ubuntu:focal

COPY --from=0 /newroot/ /
RUN apt update && \
    apt install -y --no-install-recommends libevdev2 libwacom2 libmtdev1 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
