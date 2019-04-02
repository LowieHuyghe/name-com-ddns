const https = require('https');

/**
 * Request some data
 * @param {string} url Url to call
 * @param {object} options Options for the request
 * @param {string} requestData Request data
 */
async function request (url, options, requestData) {
  return new Promise((resolve, reject) => {
    const headers = {
      ...options.headers,
    };
    if (requestData) {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
      headers['Content-Length'] = Buffer.byteLength(requestData);
    }

    const request = https.request(url, { ...options, headers }, (response) => {
      let responseData = '';
      response.on('data', (chunk) => {
        responseData += chunk;
      });
      response.on('end', () => {
        const jsonData = JSON.parse(responseData);
        if (response.statusCode !== 200) {
          reject(new Error(`${response.statusCode} ${jsonData.message}`));
        } else {
          resolve(jsonData);
        }
      });
    });
    request.on('error', (err) => {
      reject(err);
    });

    if (requestData) {
      request.write(requestData);
    }

    request.end();
  });
}

module.exports = request;
