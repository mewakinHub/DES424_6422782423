add inbound reule in security group of EC2
![alt text](image-2.png)

Great! Now that you've completed Checkpoint 6, let's move on to **Checkpoint 7**.

### Checkpoint 7: Setting Up Portainer for Docker Management

Portainer is a web-based management tool for Docker that allows you to manage containers, images, volumes, and networks through an easy-to-use interface. In this checkpoint, we'll install and configure Portainer on your Docker setup.

#### Step 1: Install Portainer

1. **Create a Docker Volume for Portainer Data**:
   Portainer stores its data in a Docker volume, so we need to create one first.

   ```bash
   docker volume create portainer_data
   ```

2. **Run the Portainer Container**:
   Use the following command to run Portainer. It will be accessible on port `9000`.

   ```bash
   docker run -d -p 9000:9000 --name=portainer --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
   ```

   - `-p 9000:9000`: Maps port 9000 on your host to port 9000 in the container.
   - `--restart=unless-stopped`: Ensures Portainer restarts automatically if the Docker daemon restarts.
   - `-v /var/run/docker.sock:/var/run/docker.sock`: Allows Portainer to communicate directly with the Docker daemon on the host.
   - `-v portainer_data:/data`: Mounts the Portainer data volume for persistent storage. -> volume mount to redis

#### Step 2: Access the Portainer Web Interface

1. Open a web browser and go to `http://<your-ec2-public-ip>:9000` (replace `<your-ec2-public-ip>` with your EC2 instance’s public IP address).
   
2. **Set Up the Admin Account**:
   - When you access Portainer for the first time, you'll be prompted to create an admin account. Set a username and password for the admin account and click **Create User**.

3. **Select Docker as the Environment**:
   - After creating the admin account, Portainer will ask you to select an environment to manage.
   - Select **Docker** and then **Connect** to manage your Docker environment.

#### Step 3: Explore Portainer's Features

Once connected, you can use Portainer to manage your Docker resources:

1. **Dashboard**:
   - View a summary of your Docker environment, including containers, images, volumes, and networks.

2. **Containers**:
   - View and manage all running containers, including starting, stopping, and restarting them.
   - You can also view container logs, inspect resource usage, and more.

3. **Images**:
   - See all Docker images available on your instance and remove any unnecessary images to save space.

4. **Networks**:
   - Manage Docker networks, create new networks, or inspect existing ones.

5. **Volumes**:
   - View and manage Docker volumes, inspect data storage, and clean up unused volumes if needed.

#### Checkpoint 7 Submission Requirements

For this checkpoint, typically you would need to provide screenshots as proof of completion:

1. **Portainer Dashboard**: Take a screenshot of the Portainer dashboard showing the connected Docker environment.
2. **Container Management**: A screenshot showing the list of running containers in Portainer.

Once you have these screenshots, you should be ready to move on to **Checkpoint 8**. Let me know if you’d like to proceed or if you need help with any part of the Portainer setup.

put this in create new stack, web editor
```
version: '3'

services:
  redis:
    image: redislabs/redismod
    container_name: testapp-redis
    ports:
      - "6379:6379"

  web1:
    build: ./web
    container_name: testapp-web1
    environment:
      - REDIS_HOST=redis
    ports:
      - "81:5000"
    depends_on:
      - redis

  web2:
    build: ./web
    container_name: testapp-web2
    environment:
      - REDIS_HOST=redis
    ports:
      - "82:5000"
    depends_on:
      - redis

  nginx:
    build: ./nginx
    container_name: testapp-nginx
    ports:
      - "80:80"
    depends_on:
      - web1
      - web2

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest  # Updated image URL as per instructions
    container_name: testapp-cadvisor
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
```