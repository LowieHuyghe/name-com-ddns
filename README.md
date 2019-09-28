# Name.com Dynamic DNS

Dynamic DNS Script for Name.com


## Installation

Setup the config-file:
```bash
cat << EOF > PATH/TO/MY/CONFIG.js
module.exports = {
  domain: 'example.com',
  host: 'www',
  username: 'MyUsername',
  token: process.env.TOKEN,

  // type: 'A',  // Default: 'A'
  // ip: '10.0.0.8',  // Default: Ip returned from https://api.ipify.org?format=json
};
EOF
```

## Usage

### With Docker

The config-file should be located in the data-directory.
```yaml
version: "3"
services:
  ddns-name-com:
    image: lowieh/ddns-name-com:latest
    volumes:
    - ./data:/data
    environment:
      - TOKEN=mytoken1234567890
```

### With CMD

```bash
npm install -g git+https://git@github.com/LowieHuyghe/ddns-name-com.git@1.0.0

CONFIG=config.js TOKEN=mytoken1234567890 ddns-name-com
```
