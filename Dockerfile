# Use an official Python runtime as the base image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install required Python packages from the requirements file
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port that the Flask app will run on
#EXPOSE 5000

# Set the default command to run the Flask app (point to main.py)
#CMD ["python", "main.py"]
#CMD exec gunicorn --bind :$PORT --worker 1 --theards 8 --timeout 0 app:main
CMD ["gunicorn", "--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "main:app"]