FROM python:3.12
WORKDIR /app
ENV BLITZ_READ_ONLY=true
RUN apt update && apt install --yes pipx && pipx ensurepath
RUN pipx install git+https://github.com/Paperz-org/blitz.git@feature/host --python $(which python)
ENV PATH="${PATH}:/root/.local/bin"
RUN blitz create --demo
CMD ["blitz", "start"]