# public-ssh-container
 Users can connect and use your app in terminal through ssh.

## Setup your app
1) Add the dependencies your app needs in the Dockerfile (at line 4). If it needs additional setup, you should put that into the last RUN clause (line 30).
2) Put your apps files and folders in the "files" folder. It will be copied to /srv/sshapp/ at build. 
3) Start your app in run.sh. It will be run every time a user logs in, and users will be able to interact with this script.

## SSH-keys
You can put your own SSH host keys in the "ssh" folder, to overwrite generated ones. This is useful to avoid clients warning users about identity change after rebuild. If you don't provide keys, they will be automatically generated.

You can generate these keys with the following commands
```
ssh-keygen -f ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f ssh_host_ecdsa_key -N '' -t ecdsa
ssh-keygen -f ssh_host_ed25519_key -N '' -t ed25519
```

## Example
```
# Build the image
docker build -t "exampleuser/mysshapp:latest" .

# Run the image in a container named "mysshapp" on the port 555
docker run -itd --name mysshapp -p 555:22 exampleuser/mysshapp:latest

# Connect to the container (should print "Hello world!" and exit by default)
ssh play@localhost -p 555
```

## Security notice
I think this container is secure, and if used with the provided configuration, possible harm is minimal. However you should be aware that this hasn't been tested by professionals, and if your app can be escaped, a malicious user might be able to access the terminal, and docker doesn't provide sufficient isolation to protect the underlying host system.