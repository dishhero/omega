#!/bin/bash

pyenv --version >/dev/null 2>&1 || {
    echo >&2 -e "\npyenv is required but it's not installed."
    echo >&2 -e "You can install it by running the following command:\n"
    echo >&2 "curl https://pyenv.run | bash"
    echo >&2 -e "\nFor more information, see documentation: https://github.com/pyenv/pyenv"
    exit 1;
}
if [ ! -r "$(pyenv root)/versions/$REQ_PYTHON" ]; then
    echo >&2 -e "\nRequired Python/Virtual Enviroment are not installed."
    echo >&2 -e "You can install it by running the following command:\n"
    echo >&2 "pyenv install $REQ_PYTHON && pyenv virtualenv --system-site-packages $REQ_PYTHON $REQ_VENV"
    exit 1;
fi
if [ ! -r "$(pyenv root)/versions/$REQ_PYTHON/envs/$REQ_VENV" ]; then
    echo >&2 -e "\nInstalling required Virtual Enviroment ($REQ_VENV)"
    pyenv virtualenv --system-site-packages $REQ_PYTHON $REQ_VENV
else
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)" 
    eval "$(pyenv activate $REQ_VENV)"

    echo "--> Installing requirements/local.txt in $REQ_VENV"
    pip install -r $(pwd)/requirements/local.txt --quiet
    echo "--> Now, activate enviroment 'pyenv activate $REQ_VENV'"
fi
