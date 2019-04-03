#!/usr/bin/env node
const path = require('path')
const fs = require('fs')
const { getMyIp } = require('./src/ipify');
const { getRecordId, updateRecord } = require('./src/namedotcom');


(async () => {

  const configFile = process.env.CONFIG || path.resolve(__dirname, 'config.js');
  if (!fs.existsSync(configFile)) {
    throw new Error('No config found. Try the environment variable CONFIG or place config.js in the root of this project');
  }
  const config = require(configFile);

  const {
    // Required
    domain,
    host,
    username,
    token,
    // Optional
    type = 'A',
    ip = (await getMyIp()),
  } = config

  if (!domain || !host || !username || !token) {
    throw new Error('Not all required config was set (domain, host, username, token)');
  }

  // Update record
  const recordId = await getRecordId(username, token, domain, host, type);
  await updateRecord(username, token, domain, host, type, recordId, ip);

  console.log('Record successfully updated');

})().catch((err) => {
  console.error(err);
  process.exit(1);
});
