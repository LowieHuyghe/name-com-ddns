#!/usr/bin/env node
const path = require('path')
const { getMyIp } = require('./src/ipify');
const { getRecordId, updateRecord } = require('./src/namedotcom');


(async () => {

  const configFile = process.env.CONFIG
  if (!configFile) {
    throw new Error('Required environment variable CONFIG was not set')
  }
  const config = require(path.resolve(configFile));

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
    throw new Error('Not all required config was set (domain, host, username, token)')
  }

  // Update record
  const recordId = await getRecordId(username, token, domain, host, type);
  await updateRecord(username, token, domain, host, type, recordId, ip);

  console.log('Record successfully updated');

})().catch((err) => {
  console.error(err);
  process.exit(1);
});
