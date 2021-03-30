FROM pytorch/pytorch:latest

# install binary tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    tree \
    less \
    vim \
    curl \
    wget \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /usr/local/src/* \
    /tmp/*

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

# 各ファイルのコピー
COPY conf/jupyter_notebook_config.py ${NEW_USER_HOME}/.jupyter/
COPY src/entrypoint.sh ${NEW_USER_HOME}
RUN chown ${LOCAL_UID}:${LOCAL_GID} -R ${NEW_USER_HOME}

# ログインスクリプトをbashrcで実行
RUN echo '' >> ${NEW_USER_HOME}/.bashrc
RUN echo '# run entrypoint' >> ${NEW_USER_HOME}/.bashrc
RUN echo 'source entrypoint.sh' >> ${NEW_USER_HOME}/.bashrc


# 作成したユーザーに切り替える
USER ${NEW_UID}
WORKDIR ${NEW_USER_HOME}
RUN mkdir workspace
