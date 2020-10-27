FROM rocker/r-ver:3.6.1

# this is the trestletech/plumber layers, now on a versioned R base

RUN apt-get update -y -qq && apt-get install -y --no-install-recommends \
  libxml2-dev

RUN install2.r plumber

EXPOSE 8000

USER 1001

COPY / app/

ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(rev(commandArgs())[1]); pr$run(host='0.0.0.0', port=8000, swagger=TRUE)"]

CMD ["/app/plumber_script.R"]