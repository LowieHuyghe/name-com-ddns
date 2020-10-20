# Name.com Dynamic DNS

Dynamic DNS Script for Name.com


## Usage

### With Docker

```yaml
version: "3"
services:
  ddns-name-com:
    image: lowieh/ddns-name-com:latest
    volumes:
    - ./data:/data
    environment:
      - USERNAME=myusername
      - TOKEN=mytoken1234567890
      - DOMAINNAME=mydomain.name
      - HOST=www
      - TYPE=A  # Optional, default: A
```

### With CMD

```bash
git clone git@github.com:LowieHuyghe/name-com-ddns.git

USERNAME=myusername \
TOKEN=mytoken1234567890 \
DOMAINNAME=mydomain.name \
HOST=www \
TYPE=A \  # Optional, default: A
./name-com-ddns/run.sh
```
