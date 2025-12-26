# Usa una imagen oficial de Python como imagen base.
# La etiqueta "slim" significa que es una versión más ligera.
FROM python:3.11-slim

# Evita que Python escriba archivos .pyc y que bufferice la salida.
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /app

# Copia el archivo de requerimientos primero para aprovechar el cache de Docker.
# Si requirements.txt no cambia, Docker no volverá a instalar las dependencias.
COPY requirements.txt .

# Instala las dependencias del proyecto.
RUN pip install -r requirements.txt

# Copia el resto del código de la aplicación al directorio de trabajo.
COPY . .

# Expone el puerto 8000 para que podamos conectarnos al servidor de Django
# desde fuera del contenedor.
EXPOSE 8000

# El comando por defecto para correr la aplicación.
# Usamos 0.0.0.0 para que el servidor sea accesible desde la red de Docker.
# Para producción, esto se reemplazaría con un servidor WSGI como Gunicorn.
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
