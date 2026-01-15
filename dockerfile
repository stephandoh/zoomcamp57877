# Use official Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy all your code into the container
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir pandas sqlalchemy psycopg2-binary click requests tqdm pyarrow

# Default command when container starts
ENTRYPOINT ["python"]
