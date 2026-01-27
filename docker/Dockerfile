FROM python:3.11-slim

# Evitar bytecode + logs inmediatos
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencias
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Código
COPY app .

# Puerto expuesto
EXPOSE 8000

# Arranque
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
