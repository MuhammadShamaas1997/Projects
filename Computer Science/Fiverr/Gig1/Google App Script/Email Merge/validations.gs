/**
 * Validates if an item is defined, otherwise throws an error.
 * @param {*} item - Item to be validated.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateDefined(item,message) {
  if (!item) {
    throw new Error(message);
  }
}

/**
 * Validates an email address using a regular expression.
 * @param {string} email - Email address to be validated.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateEmail(email,message) {
  var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email || typeof email !== 'string' || !emailRegex.test(email)) {
    throw new Error(message);
  }
}

/**
 * Validates if the provided value is an array.
 * @param {*} array - Value to be validated as an array.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateArray(array,message) {
  if (!array || !Array.isArray(array)) {
    throw new Error(message);
  }
}

/**
 * Validates if the provided array is not empty and is an array.
 * @param {Array} array - Array to be validated.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateNonEmptyArray(array,message) {
  if (!array || !Array.isArray(array) || array.length===0) {
    throw new Error(message);
  }
}

/**
 * Validates if the provided value is a string.
 * @param {*} text - Value to be validated as a string.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateString(text,message) {
  if (!text || typeof text !== 'string') {
    throw new Error(message);
  }
}

/**
 * Validates if the provided value is a number and not NaN.
 * @param {*} number - Value to be validated as a number.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateNumber(number,message) {
  if (!number || typeof number !== 'number' || isNaN(number)) {
    throw new Error(message);
  }
}

/**
 * Validates if the provided value is an object.
 * @param {*} object - Value to be validated as an object.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateObject(object,message) {
  if (!object || typeof object !== 'object') {
    throw new Error(message);
  }
}

/**
 * Validates a spreadsheet ID based on a regex pattern and length.
 * @param {string} sheetId - Spreadsheet ID to be validated.
 * @param {string} message - Error message to be thrown if validation fails.
 */
function validateSheetId(sheetId,message) {
  var spreadsheetIdRegex = /^[a-zA-Z0-9-_]+$/;
  if (!sheetId || !spreadsheetIdRegex.test(sheetId)) {
    throw new Error(message);
  }
}

/**
 * Validates the completeness and correctness of credentials object.
 * @param {Object} credentials - Object containing credentials information.
 */
function validateCredentialsData(credentials) {
  validateObject(credentials,'Invalid credentials provided');
  if (!credentials || !credentials.sheetId || !credentials.sheetName || !credentials.sheetRange || !credentials.sourceEmail || !credentials.templateDocId || !credentials.spreadsheetId || !credentials.spreadsheetName || !credentials.spreadsheetRange || !credentials.attachmentId || !credentials.breakTime || !credentials.webAppUrl || !credentials.emailQuotaRemaining) {
    throw new Error('Incomplete credentials provided');
  }
  validateSheetId(credentials.sheetId,'Invalid sheetId provided in credentials '+credentials.sheetId);
  validateString(credentials.sheetName,'Invalid sheetName provided in credentials '+credentials.sheetName);
  validateString(credentials.sheetRange,'Invalid sheetRange provided in credentials '+credentials.sheetRange);
  validateEmail(credentials.sourceEmail,'Invalid source email provided in credentials '+credentials.sourceEmail);
  validateSheetId(credentials.templateDocId,'Invalid templateDocId provided in credentials '+credentials.templateDocId);
  validateSheetId(credentials.spreadsheetId,'Invalid spreadsheetId provided in credentials '+credentials.spreadsheetId);
  validateString(credentials.spreadsheetName,'Invalid spreadsheetName provided in credentials '+credentials.spreadsheetName);
  validateString(credentials.spreadsheetRange,'Invalid spreadsheetRange provided in credentials '+credentials.spreadsheetRange);
  validateSheetId(credentials.attachmentId,'Invalid attachmentId provided in credentials '+credentials.attachmentId);
  validateNumber(credentials.breakTime,'Invalid breakTime provided in credentials '+credentials.breakTime);
  validateString(credentials.webAppUrl,'Invalid webAppUrl in credentials '+credentials.webAppUrl)
  validateNumber(credentials.emailQuotaRemaining,'Invalid emailQuotaRemaining value in credentials '+credentials.emailQuotaRemaining);
  if (credentials.emailQuotaRemaining < 1) {
    throw new Error('Invalid emailQuotaRemaining value in credentials '+credentials.emailQuotaRemaining);
  }
  
}

/**
 * Validates email values retrieved from a spreadsheet.
 * @param {Array} emailValues - Array of email values.
 */
function validateEmailValues(emailValues) {
  validateNonEmptyArray(emailValues,'Invalid emailValues found in spreadsheet'+emailValues);
  for (var i = 1; i < emailValues.length; i++) {
    validateNonEmptyArray(emailValues[i],'Invalid spreadsheet row at index '+i+' :'+emailValues[i]);
    validateEmail(emailValues[i][0],'Invalid email found in spreadsheet '+emailValues[i][0]);
  }
}

/**
 * Validates sheet data retrieved from a spreadsheet.
 * @param {Array} sheetData - Array containing sheet data.
 */
function validateSheetData(sheetData) {
  validateArray(sheetData,'Invalid spreadsheetData read '+sheetData)
  if (sheetData.length < 2) {
    throw new Error('Unable to retrieve valid sheet data '+sheetData);
  }
  for (var i = 0; i < sheetData.length; i++) {
    validateNonEmptyArray(sheetData[i],'Invalid row data at index '+ i + ': '+ sheetData[i]);
  }
}

/**
 * Validates a row of sheet data.
 * @param {Object} sheetData - Object representing a row of sheet data.
 */
function validateSheetRow(sheetData) {
  validateObject(sheetData,'Invalid sheet row found '+sheetData)
  if (!sheetData.email || !sheetData.subscribed || !sheetData.first_name || !sheetData.last_name || !sheetData.sender_name || !sheetData.company_name || !sheetData.token || !sheetData.subject) {
    throw new Error('Missing required properties in sheetData');
  }
  validateEmail(sheetData.email,'Invalid email found in row: '+sheetData.email);
  validateString(sheetData.subscribed,'Invalid subscribed value found in row: '+sheetData.subscribed);
  validateString(sheetData.first_name,'Invalid first_name found in row: '+sheetData.first_name);
  validateString(sheetData.first_name,'Invalid last_name found in row: '+sheetData.last_name);
  validateString(sheetData.first_name,'Invalid sender_name found in row: '+sheetData.sender_name);
  validateString(sheetData.first_name,'Invalid company_name found in row: '+sheetData.company_name);
  validateString(sheetData.first_name,'Invalid token found in row: '+sheetData.token);
  validateString(sheetData.first_name,'Invalid subject found in row: '+sheetData.subject);
  validateString(sheetData.first_name,'Invalid unsubscribe_hash found in row: '+sheetData.unsubscribe_hash);

}
