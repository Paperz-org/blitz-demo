# Builder stage
FROM python:3.12 as builder
WORKDIR /build

# Install pipx and setup the pipx app path
RUN apt update && apt install --yes pipx && pipx ensurepath
RUN pipx install git+https://github.com/Paperz-org/blitz.git@feature/replace-localhost --python $(which python)

ENV BLITZ_READ_ONLY=true
ENV PATH="/root/.local/bin:${PATH}"

# Final stage
FROM python:3.12-slim
WORKDIR /app

COPY --from=builder /root/.local /root/.local

ENV PATH="/root/.local/bin:${PATH}"
RUN blitz create --demo

ENV BLITZ_READ_ONLY=true
CMD ["blitz", "start"]