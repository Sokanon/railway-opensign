FROM opensign/opensignserver:main

ENV NODE_ENV=production

# Install mongosh for the startup script to check MongoDB readiness
RUN apt-get update && apt-get install -y --no-install-recommends netcat-openbsd && rm -rf /var/lib/apt/lists/*

# Copy the startup wrapper that waits for MongoDB before starting the server
COPY server/start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

EXPOSE 8080

CMD ["/usr/src/app/start.sh"]
