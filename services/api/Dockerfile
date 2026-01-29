FROM python:3.11-slim

# Evitar bytecode + logs inmediatos
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencias
COPY /services/api/app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Código
COPY /services/api/app .

# Puerto interno (solo para Docker / Nginx)
EXPOSE 8000

# Arranque
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
