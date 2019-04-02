# Name.com Dynamic DNS

Dynamic DNS Script for Name.com


## Installation

```bash
npm install -g git+https://git@github.com/LowieHuyghe/name-com-dynamic-dns.git

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

```bash
CONFIG=config.js TOKEN=mytoken1234567890 name-com-dynamic-dns
```
