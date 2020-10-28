FROM rocker/r-ver:3.6.1

RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list

RUN apt-get update -y && \
	apt-get install -y libxml2-dev -o APT::Immediate-Configure=0

RUN install2.r plumber
RUN install2.r xml2

EXPOSE 8000

USER 1001

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(rev(commandArgs())[1]); pr$run(host='0.0.0.0', port=8000, swagger=TRUE)"]

COPY / app/

CMD ["/app/launch_api.R"]
