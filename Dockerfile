FROM ubuntu:22.04

# Evitar prompts interactivos
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    unzip \
    xvfb \
    x11vnc \
    novnc \
    supervisor \
    openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Crear directorios
RUN mkdir -p /root/.android /android

# Descargar Android SDK command-line tools
WORKDIR /android
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip && \
    unzip commandlinetools-linux-9477386_latest.zip && \
    mkdir -p cmdline-tools && \
    mv cmdline-tools latest && \
    mv latest cmdline-tools/ && \
    rm commandlinetools-linux-9477386_latest.zip

# Variables de entorno
ENV ANDROID_HOME=/android
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Aceptar licencias y descargar platform-tools
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "emulator" "system-images;android-30;google_apis;x86_64"

# Crear AVD (Android Virtual Device)
RUN echo "no" | avdmanager create avd -n test -k "system-images;android-30;google_apis;x86_64" --force

# Configurar supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copiar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Exponer puertos
EXPOSE 5900 6080

CMD ["/start.sh"]
