FROM python:3.8-alpine
WORKDIR /code
ENV FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0
ENV REDIS_HOST="redis" \
    REDIS_PORT=6379
RUN apk add --no-cache gcc musl-dev linux-headers wget curl
COPY requirements.txt requirements.txt
RUN pip --no-cache-dir install -r requirements.txt
COPY . .
ENTRYPOINT [ "flask" ]
CMD ["run"]
HEALTHCHECK --interval=30s --timeout=4s \
  CMD curl -f http://localhost:5000/ || exit 1
