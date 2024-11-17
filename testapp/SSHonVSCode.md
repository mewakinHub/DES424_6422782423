# Remote w/ out using mobaxterm, but using VS Code on local machine instead!

**Install the Remote** - SSH Extension: Open VS Code, go to Extensions (or press Ctrl+Shift+X), and search for Remote - SSH. Install this extension.

public DNS: ec2-54-145-199-55.compute-1.amazonaws.com
private key PEM: ./labuser.pem

In VS Code, open the Command Palette by pressing F1 or Ctrl+Shift+P.
Type Remote-SSH: Add New SSH Host and select it.
Enter the SSH command with the path to your PEM file and EC2 public DNS, like this

```
chmod 400 labsuser.pem

ssh -i ./labsuser.pem ubuntu@ec2-54-145-199-55.compute-1.amazonaws.com
ssh -i C:/Users/mew/Documents/GitHub/DES424_6422782423/labsuser.pem ubuntu@ec2-54-145-199-55.compute-1.amazonaws.com

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