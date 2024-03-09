# Builder stage
FROM python:3.12 as builder
WORKDIR /build

# Install dependencies
RUN apt update && apt install --yes pipx && pipx ensurepath

# Install blitz using pipx to ensure it's installed globally within this image
RUN pipx install git+https://github.com/Paperz-org/blitz.git@feature/host --python $(which python)

# Set blitz read-only environment variable and add .local/bin to PATH
ENV BLITZ_READ_ONLY=true
ENV PATH="/root/.local/bin:${PATH}"

# Assuming the 'blitz create --demo' command is not necessary for the application's runtime
# If it is necessary, you would selectively copy the required files or directories instead

# Final stage
FROM python:3.12-slim
WORKDIR /app

# Copy the necessary files from the builder stage
COPY --from=builder /root/.local /root/.local

# Set environment variables as needed
ENV PATH="/root/.local/bin:${PATH}"
RUN blitz create --demo

ENV BLITZ_READ_ONLY=true
# Command to run the blitz app
CMD ["blitz", "start"]
