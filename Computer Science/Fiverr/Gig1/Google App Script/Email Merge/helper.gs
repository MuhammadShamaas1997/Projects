/**
 * Generates a random hash using MD5 algorithm.
 * @returns {string} Random hash.
 */
function getRandomHash() {
  try {
    // Generate a random string
    var randomString = Math.random().toString(36).substring(2);

    // Compute MD5 hash of the random string
    var hash = Utilities.computeDigest(Utilities.DigestAlgorithm.MD5, randomString, Utilities.Charset.UTF_8);

    // Return the base64 encoded hash
    return Utilities.base64Encode(hash);
  } catch(error) {
    Logger.log('Error in getRandomHash: '+ error)
    throw error;
  }
}

/**
 * Converts a list of headers and corresponding values into a JSON object.
 * @param {Array} headers - Array of header names.
 * @param {Array} values - Array of corresponding values.
 * @returns {Object} JSON object with headers as keys and values as values.
 */
function listToJSON (headers,values) {
  try {
    var result = {};

    // Ensure that number of headers and values are equal
    if (headers.length !== values.length) {
      throw new Error('Headers and values arrays must have the same length.');
    }

    // Populate the result object with headers and values
    for (let i=0;i<headers.length;i++) {
      result[headers[i]] = values[i];
    }
    return result;
  } catch(error) {
    Logger.log('Error in listToJSON: '+ error)
    throw error;
  }
}

/**
 * Extracts the value of a hidden form field from the provided HTML body.
 * @param {string} body - HTML body content.
 * @param {string} fieldName - Name of the hidden field to extract.
 * @returns {string|null} Value of the hidden field, or null if not found.
 */
function extractHiddenFieldValue(body, fieldName) {
  try {
    // Construct regex to match the hidden form field
    var regex = new RegExp('<input[^>]+name="' + fieldName + '"[^>]+value="([^"]+)"[^>]*>', 'i');

    // Search for the regex pattern in the body
    var match = body.match(regex);

    // If a match is found, return the captured value
    return match ? match[1].trim() : null;
  } catch(error) {
    Logger.log('Error in extractHiddenFieldValue: '+ error)
    throw error;
  }
}

/**
 * Returns current date and time in the format: year-month-day hour:minute
 */
function getFormattedDate() {
  // Get current date and time
  let now = new Date();

  // Extract year, month, day, hour, and minute
  let year = now.getFullYear();
  let month = String(now.getMonth() + 1).padStart(2, '0'); // Months are zero-based
  let day = String(now.getDate()).padStart(2, '0');
  let hour = String(now.getHours()).padStart(2, '0');
  let minute = String(now.getMinutes()).padStart(2, '0');

  // Create the formatted datetime string
  let formattedDateTime = `${year}-${month}-${day} ${hour}:${minute}`;

  return formattedDateTime;
}