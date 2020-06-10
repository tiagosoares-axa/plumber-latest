FROM trestletech/plumber:latest

#ENV http_proxy "http://git-proxy:8080"
#ENV https_proxy "http://wthproxy:8080"

RUN R -e "options(repos = list(CRAN = 'https://cran.microsoft.com/snapshot/2019-01-06')); install.packages('magrittr')" 
RUN R -e "options(repos = list(CRAN = 'https://cran.microsoft.com/snapshot/2019-01-06')); install.packages('HDtweedie')" 
RUN R -e "options(repos = list(CRAN = 'https://cran.microsoft.com/snapshot/2020-01-06')); install.packages('glmnet')" 

EXPOSE 8000

USER 1001

COPY / app/

CMD ["/app/plumber_script.R"]