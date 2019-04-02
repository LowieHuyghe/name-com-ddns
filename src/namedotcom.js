const request = require('./request');

/**
 * Get record-id
 * @param {string} username Username
 * @param {string} token Token
 * @param {string} domain Domain
 * @param {string} host Host
 * @param {string} type Record-type
 * @returns {number}
 */
async function getRecordId (username, token, domain, host, type) {
  const result = await request(`https://api.name.com/v4/domains/${domain}/records`, { auth: `${username}:${token}`, method: 'GET' });
  const record = result.records.find(record => record.host === host && record.type === type);
  if (!record) {
    throw new Error(`Could not find A-record "${host}.${domain}"`);
  }
  if (!record.id) {
    throw new Error('Record did not contain an id');
  }

  return record.id;
}

/**
 * Update a record
 * @param {string} username Username
 * @param {string} token Token
 * @param {string} domain Domain
 * @param {string} host Host
 * @param {string} type Record-type
 * @param {number} recordId Record-id
 * @param {string} answer Record-answer
 */
async function updateRecord (username, token, domain, host, type, recordId, answer) {
  const data = JSON.stringify({
    host,
    type,
    answer,
    ttl: 300,
  });
  const result = await request(`https://api.name.com/v4/domains/${domain}/records/${recordId}`, { auth: `${username}:${token}`, method: 'PUT' }, data);
  if (result.answer !== answer) {
    throw new Error('Could not update record');
  }
}

module.exports = {
  getRecordId,
  updateRecord,
};
