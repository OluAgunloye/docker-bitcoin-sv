This is a minimal bitcoin-sv container for running a node with JSON-RPC, REST,
and ZMQ capabilities.

# Example Usage

Create a configuration file.

```
txindex=1
server=1
rest=1
rpcbind=0.0.0.0:8332
rpcallowip=0.0.0.0/0

zmqpubhashblock=tcp://0.0.0.0:28332
zmqpubhashtx=tcp://0.0.0.0:28332
zmqpubrawblock=tcp://0.0.0.0:28332
zmqpubrawtx=tcp://0.0.0.0:28332

rpcuser=user
rpcpassword=password
```

Run the container.

```
docker run -d --restart=unless-stopped \
  -p 8332:8332 -p 28332:28332 \
  -v /path/to/bsv.conf:/bsv.conf \
  -v /path/to/blockchain:/data \
  breavyn/bitcoin-sv
```
