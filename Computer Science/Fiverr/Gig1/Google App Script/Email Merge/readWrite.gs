/**
 * Reads data from a Google Spreadsheet.
 * @param {string} sheetId - The ID of the Google Spreadsheet.
 * @param {string} sheetName - The name of the sheet within the spreadsheet.
 * @param {string} sheetRange - The range of cells to read (e.g., 'A1:B10').
 * @returns {Array[]} - A 2D array representing the values in the specified range.
 */
function readSpreadsheet(sheetId, sheetName, sheetRange) {
  try {
    // Ensure sheetId is valid
    validateSheetId(sheetId, 'Invalid sheetId: ' + sheetId);

    // Ensure sheetName is a string
    validateString(sheetName, 'Invalid sheetName: ' + sheetName);

    // Ensure sheetRange is a string
    validateString(sheetRange, 'Invalid sheetRange: ' + sheetRange);

    var sheet = SpreadsheetApp.openById(sheetId).getSheetByName(sheetName);

    // Ensure sheet exists
    validateDefined(sheet, 'Sheet with the name ' + sheetName + ' does not exist');

    // Get the last row in the sheet
    var lastRow = sheet.getLastRow();

    // Ensure lastRow is a number
    validateNumber(lastRow, 'Invalid lastRow: ' + lastRow);

    // Ensure lastRow is a positive number
    if (lastRow <= 0) {
      throw new Error('Invalid lastRow value');
    }

    // Construct range by combining sheetRange and lastRow
    var range = sheet.getRange(sheetRange + lastRow);

    // Get values from the range
    var values = range.getValues();

    // Ensure values is an array
    validateArray(values, 'Invalid values found in spreadsheet: ' + values);

    return values;
  } catch (error) {
    Logger.log('Error in readSpreadsheet: ' + error);
    throw error;
  }
}


/**
 * Reads text content from a Google Document.
 * @param {string} documentId - The ID of the Google Document.
 * @returns {string} - The text content of the document.
 */
function readDocument(documentId) {
  try {
    // Ensure documentId is a string
    validateSheetId(documentId, 'Invalid documentId provided: ' + documentId);

    // Open document
    var document = DocumentApp.openById(documentId);

    // Ensure document exists
    validateDefined(document, 'Document with the provided ID does not exist');

    // Read document body
    var body = document.getBody();

    // Ensure body exists
    validateDefined(body, 'Document body is empty');

    // Read body text
    var text = body.getText();

    // Ensure text is a string
    validateString(text, 'Invalid document text: ' + text);

    return text;
  } catch (error) {
    Logger.log('Error in readDocument: ' + error);
    throw error;
  }
}


/**
 * Retrieves the inline image blob from Google Drive by its ID.
 * @param {string} imageId - The ID of the image file in Google Drive.
 * @returns {Object} - An object containing the inline image blob.
 */
function getInlineImage(imageId) {
  try {
    // Ensure imageId is provided
    validateDefined(imageId, 'Missing imageId');

    // Ensure imageId is a string
    validateString(imageId, 'Invalid imageId: ' + imageId);

    // Open image file
    var file = DriveApp.getFileById(imageId);

    // Ensure file exists
    validateDefined(file, 'File with the provided ID does not exist')

    // Get file blob
    var blob = file.getBlob();

    // Ensure blob is not null
    validateDefined(blob, 'Failed to retrieve blob for the image');

    return {
      inlineImageBlob: blob
    };
  } catch (error) {
    Logger.log('Error in getInlineImage: ' + error);
    throw error;
  }
}


/**
 * Unsubscribes an email address based on the unsubscribe hash provided in the email.
 * @param {GmailMessage} message - The Gmail message containing the unsubscribe hash.
 * @returns {boolean} - Indicates whether the unsubscribe operation was successful.
 */
function unsubscribe(message) {
  try {
    // Ensure message is provided
    validateDefined(message, 'Missing message');

    // Extract information from the email
    var body = message.getBody();

    // Ensure body is a string
    validateString(body, 'Invalid email body: ' + body);

    // Process the form response in the email body
    var unsubscribeHash = extractHiddenFieldValue(body, 'unsubscribeHash');
    var sheetId = extractHiddenFieldValue(body, 'sheetId');

    // Ensure unsubscribeHash and sheetId are not empty strings
    if (!unsubscribeHash || !sheetId) {
      throw new Error('Invalid unsubscribe hash or sheet ID');
    }

    var sheet = SpreadsheetApp.openById(sheetId).getActiveSheet();
    const sheetData = sheet.getDataRange().getValues();

    // Get headers
    const headers = sheetData[0];
    const subscribedIndex = headers.indexOf('subscribed');

    // Ensure subscribedIndex is a number
    validateNumber(subscribedIndex, 'Invalid subscribedIndex: ' + subscribedIndex);

    // iterate through the data, starting at index 1
    for (let i = 1; i < sheetData.length; i++) {
      const row = listToJSON(sheetData[0], sheetData[i]);
      const rowEmail = row['email'];
      const rowHash = row['unsubscribe_hash'];

      // Ensure rowEmail is a string
      validateEmail(rowEmail, 'Invalid email: ' + rowEmail);

      // if the email and unsubscribe hash match with the values in the sheet
      // then update the subscribed value to 'no'
      if (unsubscribeHash === rowHash) {
        sheet.getRange(i + 1, subscribedIndex + 1).setValue('no');
        return true;
      }
    }
    return false;
  } catch (error) {
    Logger.log('Error in unsubscribe: ' + error);
    throw error;
  }
}


/**
 * Retrieves the array of processed email IDs from user properties.
 * @returns {string[]} - An array containing the processed email IDs.
 */
function getProcessedEmailIds() {
  try {
  // Ensure PropertiesService exists
  if (!PropertiesService || typeof PropertiesService.getUserProperties !== 'function') {
    throw new Error('PropertiesService is not available');
  }

  var propertyKey = 'processedEmailIds';

  // Get stored email ids
  var storedIds = PropertiesService.getUserProperties().getProperty(propertyKey);

  // Ensure storedIds is a string
  validateString(storedIds, 'Invalid stored email ids ' + storedIds);

  if (storedIds) {
    try {
      // Parse storedIds string to an array
      var parsedIds = JSON.parse(storedIds);

      // Ensure parsedIds is an array
      validateArray(parsedIds, 'Invalid parsed email ids: ' + parsedIds);

      return parsedIds;
    } catch (error) {
      throw new Error('Failed to parse stored email ids: ' + error);
    }
  } else {
    return [];
  }
  } catch(error) {
    Logger.log('Error in getProcessedEmailIds: '+error);
    throw error;
  }
}


/**
 * Sets the array of processed email IDs to user properties.
 * @param {string[]} ids - An array containing the processed email IDs.
 */
function setProcessedEmailIds(ids) {
  try {
  // Ensure ids is an array
  validateArray(ids, 'Invalid array: ' + ids);

  var propertyKey = 'processedEmailIds';

  // Ensure PropertiesService exists
  if (!PropertiesService || typeof PropertiesService.getUserProperties !== 'function') {
    throw new Error('PropertiesService is not available');
  }

  var stringifiedIds = JSON.stringify(ids);

  // Ensure stringifiedIds is a string
  validateString(stringifiedIds, 'Failed to stringify email ids: ' + stringifiedIds);

  // Set the processed email ids as a property
  PropertiesService.getUserProperties().setProperty(propertyKey, stringifiedIds);
  } catch(error) {
    Logger.log('Error in setProcessedEmailIds: '+error);
    throw error;
  }
}
