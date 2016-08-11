FROM continuumio/anaconda3:4.1.1
MAINTAINER Bill McCord <bill@droste.hk>

# Docker caches the statements in order, so we want to put the most expensive
# statement (setting up the anaconda environment) first so that it is only
# rebuilt in cases where the environment is modified.
ADD environment.yml /droste/environment.yml

WORKDIR /droste

RUN conda env create environment.yml

COPY jupyter_notebook_config.py /droste/jupyter_notebook_config.py

# This volume is intended to hold the Jupyter notebooks.
VOLUME /droste/notebooks

# The default Jupyter port.
EXPOSE 8888

# When the container is run, start the jupyter notebook server.
ENTRYPOINT ["/bin/bash", "-c", "source activate droste && jupyter notebook --config jupyter_notebook_config.py"]
