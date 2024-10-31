FROM python:3.12-slim

# Update package index and install curl
RUN apt-get update && apt-get install -y curl

# Install Python Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# Set PATH to include Poetry bin directory
ENV PATH="/root/.local/bin:$PATH"

# Copy project files
COPY ./pyproject.toml ./poetry.lock ./

# Install poetry dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi

# Clean up apt cache
RUN apt-get update && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify Uvicorn installation
RUN poetry run uvicorn --version

COPY . .

CMD ["poetry", "run", "uvicorn", "lecture_2.hw.shop_api.main:app", "--host", "0.0.0.0", "--port", "8080"]
