FROM pytorch/pytorch:latest

# entrypointを実行するのに必要かも
RUN apt-get update && apt-get -y install gosu

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
ARG NEW_UID=1000
ARG NEW_USER='developer'
RUN useradd -m -u ${NEW_UID} ${NEW_USER}

# 作業ディレクトリの作成
ARG NEW_USER_HOME=/home/${NEW_USER}

# configファイルのコピー
COPY conf/jupyter_notebook_config.py ${NEW_USER_HOME}
COPY src/entrypoint.sh ${NEW_USER_HOME}
RUN chmod +x ${NEW_USER_HOME}/entrypoint.sh

# 作成したユーザーに切り替える
USER ${NEW_UID}
WORKDIR ${NEW_USER_HOME}

ENTRYPOINT ["/home/developer/entrypoint.sh"]
