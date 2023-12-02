FROM ubuntu:latest
LABEL authors="jlh"

ENTRYPOINT ["top", "-b"]