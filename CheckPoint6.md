Thank you for pointing out the specific details. I'll revise the `README.md` file for Checkpoint 6 with the exact configurations as indicated in your notes and the screenshots. Here’s the updated and more precise `README.md`.

---

# Checkpoints 6-8: Docker-based Application Setup and Monitoring

This README provides step-by-step instructions for Checkpoints 6 through 8, focusing on setting up Docker-based applications, monitoring resources, and deploying a multi-service voting app.

---

## Tutorial Checkpoint: 6

### A Node.js Application using Nginx, Docker, and Redis

This section guides you through containerizing a Node.js web application with a Redis database and using Nginx as a reverse proxy. This setup will use four Docker services.

#### Step 1: Create a Docker Compose File

1. Create a new file named `docker-compose.yml`.
2. Add the following content to define an application with four services: `redis`, `nginx`, `web1`, and `web2`.
3. The `docker-compose.yml` maps port 80 of the host to port 80 of the `nginx` container service.

   ```yaml
   version: '3'

   services:
     redis:
       image: redislabs/redismod
       container_name: redis
       ports:
         - "6379:6379"

     web1:
       restart: on-failure
       build: ./web
       container_name: web1
       hostname: web1
       environment:
         - REDIS_HOST=redis
       depends_on:
         - redis
       ports:
         - "81:5000"

     web2:
       restart: on-failure
       build: ./web
       container_name: web2
       hostname: web2
       environment:
         - REDIS_HOST=redis
       depends_on:
         - redis
       ports:
         - "82:5000"

     nginx:
       build: ./nginx
       container_name: nginx
       ports:
         - "80:80"
       depends_on:
         - web1
         - web2
   ```

   - **redis**: Uses `redislabs/redismod` as the image and maps port `6379`.
   - **web1 & web2**: Node.js applications with Redis dependency. Ports `81` and `82` on the host map to `5000` in each container.
   - **nginx**: Acts as a load balancer, mapping port `80` on the host to port `80` in the container.

#### Step 2: Create the Nginx Directory and Files

1. Inside the `nginx/` directory, create `nginx.conf` to configure load balancing between `web1` and `web2`:
   
   ```nginx
   events { }

   http {
       upstream web_servers {
           server web1:5000;
           server web2:5000;
       }

       server {
           listen 80;
           location / {
               proxy_pass http://web_servers;
           }
       }
   }
   ```
   
2. Create a `Dockerfile` in the `nginx/` directory:
   
   ```Dockerfile
   FROM nginx
   COPY nginx.conf /etc/nginx/nginx.conf
   ```

   This configuration sets Nginx as a reverse proxy, distributing traffic between `web1` and `web2`.

#### Step 3: Create the Web Directory and Files

1. Inside the `web/` directory, create the following files:
   
   - **package.json**:
     ```json
     {
       "name": "node-redis-app",
       "version": "1.0.0",
       "description": "A simple Node.js app with Redis",
       "main": "server.js",
       "dependencies": {
         "express": "^4.17.1",
         "redis": "^3.1.2"
       },
       "scripts": {
         "start": "node server.js"
       }
     }
     ```

   - **server.js**:
     ```javascript
     const express = require('express');
     const redis = require('redis');

     const app = express();
     const client = redis.createClient({ host: process.env.REDIS_HOST, port: 6379 });

     app.get('/', (req, res) => {
         client.get('visits', (err, visits) => {
             res.send('Number of visits is ' + visits);
             client.set('visits', parseInt(visits) + 1);
         });
     });

     app.listen(5000, () => {
         console.log('Listening on port 5000');
     });
     ```

   - **Dockerfile**:
     ```Dockerfile
     FROM node:14
     WORKDIR /app
     COPY package.json ./
     RUN npm install
     COPY . .
     CMD ["npm", "start"]
     ```

#### Step 4: Deploy the Application

Use Docker Compose to deploy the application:
```bash
docker-compose up -d
```

#### Step 5: Monitoring Redis Keys

Install `redis-tools`:
```bash
sudo apt-get install redis-tools
```

Use `redis-cli` to monitor Redis keys:
```bash
redis-cli -h localhost -p 6379
get visits
```

#### Step 6: Testing the Application

Navigate to `http://localhost:80` in a browser or test with:
```bash
curl localhost:80
```

#### Checkpoint 6 Submission

- Capture a screenshot of `docker ps` showing all running containers.
- Capture a screenshot of the visit count in the application on your browser or terminal.

---

## Tutorial Checkpoint: 7

### Portainer – Docker Management

Portainer provides a UI to manage Docker containers, images, volumes, and networks.

#### Install Portainer

1. Create a Docker volume for Portainer:
   ```bash
   docker volume create portainer_data
   ```
2. Run the Portainer container:
   ```bash
   docker run -d -p 9000:9000 --name=portainer --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
   ```

#### Access Portainer

- Go to `http://localhost:9000`.
- Create an admin account on the first login.

#### Portainer Web Steps

1. **Select Docker Daemon**: Choose **local** to connect to the Docker daemon.
2. **Explore the Dashboard**: View Docker resources like images, containers, volumes, and networks.
3. **View Container Details**: Under **Containers**, click any container to see details.

#### Monitoring with Grafana and Prometheus

1. Deploy Prometheus and Grafana using Docker Compose.
2. Configure Prometheus to monitor Docker metrics.
3. Use Grafana to visualize these metrics by adding Prometheus as a data source.

#### Checkpoint 7 Submission

- Take a screenshot of the `cadvisor-export` dashboard in Grafana showing Docker metrics.

---

## Tutorial Checkpoint: 8

### Deploying a Voting App with Docker Compose

This section involves deploying a multi-service voting application from GitHub. It includes a front-end voting app, Redis, a worker, PostgreSQL, and a results app.

#### Application Components

- **Voting-app**: Flask-based app for casting votes.
- **Redis**: In-memory store for votes.
- **Worker**: Processes votes from Redis and stores them in PostgreSQL.
- **PostgreSQL**: Database for persistent storage.
- **Result-app**: Node.js app that displays voting results.

#### Deployment Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/dockersamples/example-voting-app
   ```
2. Navigate to the project directory and deploy using Docker Compose:
   ```bash
   docker-compose up -d
   ```

#### Checkpoint 8 Submission

- Capture screenshots showing:
  - Running containers (`docker ps`).
  - The voting application interface.
  - The results application interface.

---

By following these instructions, you should complete Checkpoints 6 to 8 with precise configurations. Let me know if further adjustments are needed!