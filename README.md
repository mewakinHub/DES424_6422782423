https://github.com/dockersamples/example-voting-app

# Remote w/ out using mobaxterm, but using VS Code on local machine instead!

**Install the Remote** - SSH Extension: Open VS Code, go to Extensions (or press Ctrl+Shift+X), and search for Remote - SSH. Install this extension.

public DNS: ec2-54-145-199-55.compute-1.amazonaws.com
private key PEM: ./labuser.pem

In VS Code, open the Command Palette by pressing F1 or Ctrl+Shift+P.
Type Remote-SSH: Add New SSH Host and select it.
Enter the SSH command with the path to your PEM file and EC2 public DNS, like this

```
chmod 400 labsuser.pem

ssh -i ./labsuser.pem ubuntu@ec2-75-101-188-136.compute-1.amazonaws.com
ssh -i C:/Users/mew/Documents/GitHub/DES424_6422782423/labsuser(1).pem ubuntu@ec2-75-101-188-136.compute-1.amazonaws.com

```
After entering this, VS Code will prompt you to select the SSH configuration file to save the connection. Choose the default SSH configuration file (usually located at ~/.ssh/config).

**Connect to the EC2 Instance**:
   - Go to the **Remote Explorer** sidebar in VS Code (the green `><` icon).
   - Select `Connect to Host` inside `Remote-SSH` section
   - Select your EC2 instance (e.g., `MyEC2Instance`) to connect.
   - VS Code will open a new window and connect to your EC2 instance.

### Step 3: Confirm Connection and Edit Files

- Once connected, you can use the **File > Open Folder** option in VS Code to navigate to directories on your EC2 instance, such as `/home/ubuntu/my_git_docker/`.
- You can now edit files directly and use the integrated terminal in VS Code to run commands on the EC2 instance.

### Alternative: Troubleshooting with MobaXterm

Since you already have a successful connection in MobaXterm, you can also edit files there if needed. However, the VS Code setup offers a more streamlined development experience.

---

# docker HW check point 3
**use ARG as passing argument when building the image**
docker build --no-cache --build-arg MY_NAME=Teetawat --build-arg MY_ID=6422782423 -t mygitweb:1.1 .

docker run --name myweb_g -d -p 8080:80 mygitweb:1.1

# docker HW check point 4
**use ENV as passing evn value when running the container**

*Create a Shell Script for Environment Replacement (dotask.sh)*
```
#!/bin/sh
sed -i 's/<MY_HOST>/'"$MY_HOST"'/g' /usr/share/nginx/html/mygitweb/check4.html
nginx -g 'daemon off;'
```

docker build --no-cache -t mygitweb:1.4 .
docker run -d --name myweb_g -p 8080:80 mygitweb:1.4
docker run -d --name myweb_g -e MY_HOST=MyDockerOnVM -p 8080:80 mygitweb:1.4

**PROBLEM:** the CMD ["sh", "/dotask.sh"] line isn’t running as expected, so we need to manually run it inside container

**Solution1:**
- ubuntu@ip-172-31-26-10:~/mygitweb$ docker exec -it myweb_g bin/bash
- root@34e42f4505f9:/# sed -i 's/<MY_HOST>/'"$MY_HOST"'/g' /usr/share/nginx/html/mygitweb/check4.html

**Solution2:** This is because it's CRLF(window), not LF(linux) ending file name, so we need to adjust it back to LF with `dos2unix dotask.sh`

## other command
docker stop <container_name>

docker rm <container_name>

docker logs myweb_g



# NOTE:

### Difference Between `ARG` and `ENV`

1. **Scope and Lifecycle**:
   - **`ARG`**: Build-time arguments. They are available **only during the image build process** and cannot be accessed after the container is running. You specify them using the `--build-arg` flag when you build the image. Once the image is built, `ARG` values are not available or modifiable inside the container.
   - **`ENV`**: Runtime environment variables. These are available **both during the build process and at runtime** (when the container is running). You can set `ENV` variables in the Dockerfile or override them with the `-e` flag when you run the container.
        - **`ENV`** is used for configuration settings that might need to be changed or referenced after the container starts, such as application configurations, database URLs, or host settings.

3. **Syntax in Dockerfile**:
   - You define `ARG` and `ENV` differently:
     ```Dockerfile
     ARG MY_ARG_NAME=default_value
     ENV MY_ENV_NAME=default_value
     ```
   - When referencing these values in the Dockerfile:
     - For `ARG`, you reference it directly by its name (e.g., `$MY_ARG_NAME`) but **only during the build phase**.
     - For `ENV`, you can reference it both in the build and at runtime (e.g., `$MY_ENV_NAME`), and it will persist in the running container.

### `sed` Command

- **`sed`** is a command-line utility for parsing and transforming text. In your Dockerfile and script, `sed` is used to find and replace placeholders (`<MY_HOST>`, `<MY_NAME>`, `<MY_ID>`) with the actual values of the environment variables.
- For example:
  ```bash
  sed -i 's/<MY_HOST>/'"$MY_HOST"'/g' /usr/share/nginx/html/mygitweb/check4.html
  ```
  This command finds all instances of `<MY_HOST>` in `check4.html` and replaces them with the value of `$MY_HOST`.

### Comparison Summary (Checkpoint 3 vs. Checkpoint 4)

| Feature           | Checkpoint 3 (Using `ARG`)                       | Checkpoint 4 (Using `ENV`)                          |
|-------------------|--------------------------------------------------|-----------------------------------------------------|
| **Purpose**       | Build-time variables                             | Runtime variables                                   |
| **Defined with**  | `ARG MY_NAME=default_name`                       | `ENV MY_HOST=localhost`                             |
| **Referenced as** | `$MY_NAME` during build                          | `$MY_HOST` during build and runtime                 |
| **Accessibility** | Only available during build phase                | Available during build and in the running container |
| **Example Usage** | Replaced in `index.html` with `sed` at build     | Replaced in `check4.html` with `sed` at runtime     |