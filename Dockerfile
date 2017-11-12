FROM python:3.6
ENV PYTHONUNBUFFERED 1

# Install virtualenv
RUN pip install -U virtualenv==15.1.0
