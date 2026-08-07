FROM python:3.13-alpine

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

RUN apk update \
    && apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*

COPY requirements.txt .
RUN python -m pip install --upgrade --no-cache-dir pip \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && python -m pip install --no-cache-dir "msgpack>=1.2.1" "setuptools>=78.1.1" \
    && python -m pip check \
    && python -m pip uninstall -y setuptools \
    && python -m pip uninstall -y pip \
    && rm -rf /root/.cache/pip

COPY app ./app

RUN addgroup -S appuser \
    && adduser -S -G appuser appuser
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD python -c "import sys, urllib.request; sys.exit(0 if urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=3).status == 200 else 1)"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "4", "app.app:app"]
