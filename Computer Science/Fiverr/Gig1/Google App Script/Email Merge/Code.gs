/**
 * Entry point for the web app.
 */
function doGet() {
  try {
    // Get credentials
    var credentials = getCredentials();
    validateCredentialsData(credentials);

    // Spreadsheet Access Validation
    var emailValues = readSpreadsheet(credentials.sheetId, credentials.sheetName, credentials.sheetRange);
    validateEmailValues(emailValues);

    // Iterate over emailValues
    for (var i = 0; i < emailValues.length; i++) {

      // Use findIndex() method to search for the email in the array
      var index = emailValues.findIndex(function(row) {
        return row[0] === credentials.sourceEmail;
      });

      //If email is found in list, schedule triggers
      if (index !== -1) {
          
        // Trigger Scheduling
        ScriptApp.newTrigger('scheduleEmailsTrigger')
          .timeBased()
          .everyMinutes(1)
          .create();
        //scheduleEmailsTrigger()
        
      } else {
        throw new Error('Email not found in the list.');
      }
    }
  } catch (error) {
    // Error Handling
    console.error('Error in doGet: ' + error);
    throw error;
  }
}

/**
 * Schedules triggers for sending personalized emails.
 */
function scheduleEmailsTrigger() {
  try {
    if(getCredentials().timeStamp===getFormattedDate()) {
      // Send personalized emails
      createPersonalizedEmails();
    }
    // Check for new unsubscription emails
    checkForNewEmails();
  } catch (error) {
    Logger.log('Error in scheduleEmailsTrigger: ' + error);
    throw error;
  }
}

/**
 * Creates personalized emails and sends them to subscribers.
 */
function createPersonalizedEmails() {
  try {
    // Get credentials
    var credentials = getCredentials();

    // Get the sheet data of destination
    var sheetData = readSpreadsheet(credentials.spreadsheetId, credentials.spreadsheetName, credentials.spreadsheetRange)
    validateSheetData(sheetData);

    // Iterate over the rows in the sheet. Skip first row
    for (var i = 1; i < sheetData.length && (i <= credentials.emailQuotaRemaining); i++) {

      try {
        
        // Attempt to make personalized email and send it to subscriber
        sendEmail(credentials, listToJSON(sheetData[0], sheetData[i]));
      } catch (error) {
        
        //Log the error and continue with the next iteration
        Logger.log('Error in sendEmail: '+error);
        
        // Skip the current iteration and proceed with the next one
        continue;
      }
    }
  } catch (error) {
    Logger.log('Error in createPersonalizedEmails: ' + error);
    throw error;
  }
}

/**
 * Checks for new unsubscription confirmation emails.
 */
function checkForNewEmails() {
  try {
    // Get threads with the specified subject
    var threads = GmailApp.search('subject:' + 'Unsubscribe Confirmation');
    validateArray(threads,'GmailApp.search did not return an array of threads');

    // Get the IDs of processed emails from PropertiesService
    var processedEmailIds = getProcessedEmailIds();
    validateArray(processedEmailIds,'getProcessedEmailIds did not return an array');

    // Iterate over threads for email unsubscription
    for (var i = 0; i < threads.length; i++) {
      var messages = threads[i].getMessages();
      validateArray(messages,'Thread did not return an array of messages');

      // Iterate over messages in thread
      for (var j = 0; j < messages.length; j++) {

        // Check if the email has already been processed
        if (!processedEmailIds.includes(messages[j].getId())) {

          // Remove subscription
          unsubscribe(messages[j]);

          // Mark the email as processed by adding its ID to the processedEmailIds array
          processedEmailIds.push(messages[j].getId());
        }
      }
    }

    // Update the processed email IDs in PropertiesService
    setProcessedEmailIds(processedEmailIds);
  } catch (error) {
    Logger.log('Error in checkForNewEmails: ' + error);
    throw error;
  }
}
