#!/usr/bin/env bash

sudo apt update
sudo apt install nodejs npm -y
npm install -g express
cat <<EOF > $HOME/helloworld.js
const express = require('express')
const app = express()
const port = 8080

app.get('/', (req, res) => {
  res.send('Hello World!\n')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
EOF

nohup node $HOME/helloworld.js &