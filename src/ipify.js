const request = require('./request');

/**
 * Get my ip
 * @returns {string}
 */
async function getMyIp () {
  const result = await request(`https://api.ipify.org?format=json`, { method: 'GET' });
  if (!result.ip) {
    throw new Error('Could not fetch own ip');
  }
  return result.ip
}

module.exports = {
  getMyIp,
};
