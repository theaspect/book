# docker build -f Dockerfile -t sandbox -t theaspect/sandbox .
# docker push theaspect/sandbox
# docker run -it sandbox
# fb849f09398221adceddc5c930af6d691cf91df6e5450a4b8857ba539235ba78
FROM nixos/nix:2.9.1-amd64

RUN nix-channel --update

RUN nix-env -iA nixpkgs.cling
RUN nix-env -iA nixpkgs.jdk
RUN nix-env -iA nixpkgs.kotlin
RUN nix-env -iA nixpkgs.python3
RUN nix-env -iA nixpkgs.ruby
RUN nix-env -iA nixpkgs.nodejs

# Manually install ki
# https://github.com/Kotlin/kotlin-interactive-shell/issues/110
RUN nix-env -iA nixpkgs.gawk
RUN nix-env -iA nixpkgs.unzip
RUN nix-env -iA nixpkgs.curl

RUN curl --location -o ki-archive.zip https://github.com/Kotlin/kotlin-interactive-shell/releases/download/v0.4.5/ki-archive.zip
RUN unzip ki-archive.zip -d /root/.nix-profile/
RUN rm ki-archive.zip
RUN mv /root/.nix-profile/ki/bin/* /root/.nix-profile/bin/
RUN mv /root/.nix-profile/ki/lib/* /root/.nix-profile/lib/
RUN rm -rf /root/.nix-profile/ki/