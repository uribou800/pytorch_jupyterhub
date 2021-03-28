FROM pytorch/pytorch:latest

# entrypointを実行するのに必要かも
RUN apt-get update && apt-get -y install gosu
# vi tree less も入れたい

# Install required libraries
RUN conda config --add channels pytorch \
 && conda config --append channels conda-forge \
 && conda update --all --yes --quiet \
 && conda install --yes --quiet \
    ipywidgets \
    jupyterlab \
    matplotlib \
    nodejs \
    opencv \
    pandas \
    scikit-learn \
    seaborn \
    sympy \
 && conda update nodejs \
 && conda clean --all -f -y

# Install jupyter extensions
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension \
 && jupyter labextension install @jupyter-widgets/jupyterlab-manager

# ユーザの追加
ARG LOCAL_UID
ARG LOCAL_GID
ARG NEW_UID=${LOCAL_UID}
ARG NEW_USER='devel'
RUN useradd -m -u ${NEW_UID} ${NEW_USER}
RUN usermod -g ${LOCAL_GID} ${NEW_USER}

# 作業ディレクトリの作成
ARG NEW_USER_HOME=/home/${NEW_USER}
# RUN mkdir ${NEW_USER_HOME}/workspace
# RUN chown ${NEW_USER} -R ${NEW_USER_HOME}

# configファイルのコピー
COPY conf/jupyter_notebook_config.py ${NEW_USER_HOME}
RUN chown ${LOCAL_UID}:${LOCAL_GID} -R ${NEW_USER_HOME}

# 作成したユーザーに切り替える
USER ${NEW_UID}
WORKDIR ${NEW_USER_HOME}
RUN mkdir workspace
