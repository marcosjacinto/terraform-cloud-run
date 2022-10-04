FROM python:3.9-slim-buster

RUN pip install poetry==1.2.1
WORKDIR /src

COPY poetry.lock .
COPY pyproject.toml .

RUN poetry config virtualenvs.create false 
RUN poetry install --no-interaction --no-ansi --no-root

COPY api/ ./api/

CMD ["python", "api/main.py"]