FROM debian
MAINTAINER Kristoffer Andersen <ka@openmono.com>
LABEL version="latest"

RUN apt-get update && apt-get -y install python git doxygen python-pip
RUN echo "breathe==4.1.0\n\
docutils==0.13.1\n\
commonmark==0.5.4\n\
recommonmark==0.4.0\n\
sphinx==1.5.3\n\
sphinx-rtd-theme<0.3" > requirements.txt
RUN pip install -r requirements.txt
ENV FRM_URL https://github.com/getopenmono/mono_framework.git
ENV DOCS_URL https://github.com/getopenmono/monodocs.git
ENV DEPLOY_TARGET /Desktop
ENV DOCS_DIR /docs
ENV DOXYRUN true
CMD \
    if [ -d $DOCS_DIR ]; then cd $DOCS_DIR; else git clone $FRM_URL && \
    git clone $DOCS_URL && cd monodocs; fi && \
    if [ $DOXYRUN == "true" ]; then bash doxyrun.sh ../mono_framework/src; else echo "Skipping doxygen step"; fi && \
    python makeapi.py && sphinx-build -Ta . _build && \
    if [ -d $DEPLOY_TARGET ]; then cp -r _build $DEPLOY_TARGET; else echo "No deploy copy"; fi
