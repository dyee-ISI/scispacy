FROM python:3.6.4-stretch

# install base packages
RUN apt-get clean \
 && apt-get update --fix-missing \
 && apt-get install -y \
    git \
    curl \
    gcc \
    g++ \
    build-essential \
    wget \
    awscli

WORKDIR /work

# install python packages
COPY requirements.in .

# add the code as the final step so that when we modify the code
# we don't bust the cached layers holding the dependencies and
# system packages.
COPY scispacy/ scispacy/
COPY scripts/ scripts/
COPY tests/ tests/
COPY .flake8 .flake8

RUN pip install -r requirements.in
RUN pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.2.5/en_core_sci_sm-0.2.5.tar.gz
RUN python -m spacy download en_core_web_sm
RUN python -m spacy download en_core_web_md

CMD [ "/bin/bash" ]
