FROM trestletech/plumber:latest

#RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list

#RUN apt-get update -y && \ 
#    apt-get install -y libxml2

RUN install2.r xml2

#RUN R -e "options(repos = list(CRAN = 'https://cran.microsoft.com/snapshot/2020-10-01')); install.packages('xml2')" 
#RUN R -e "options(repos = list(CRAN = 'https://cran.microsoft.com/snapshot/2020-10-01')); install.packages('plumber')" 

EXPOSE 8000

USER 1001

COPY / app/

CMD ["/app/launch_api.R"]