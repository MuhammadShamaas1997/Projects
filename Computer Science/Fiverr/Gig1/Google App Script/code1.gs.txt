function doGet() {
    var sheetId = '1APPy-K7qr5z-R3geDniUxec10jy54fQLkwjex4ZqqYY';
    var sheetName = 'Sheet1';  // Replace with the actual sheet name
    var sourceEmail = Session.getActiveUser().getEmail();
    // Open the Google Sheet
    var sheet = SpreadsheetApp.openById(sheetId).getSheetByName(sheetName);

    // Get the range of emails in column E
    var emailRange = sheet.getRange('A:A');

    // Get all values in the range
    var emailValues = emailRange.getValues();

    for (var i = 0; i < emailValues.length; i++) {
      var useremail = emailValues[i];
      if (sourceEmail == useremail){
        var template = HtmlService.createTemplateFromFile('index');
        return template.evaluate();
      } 
    }
    var template = HtmlService.createTemplateFromFile('Invalide_token');
    return template.evaluate();
}

function browseDriveFiles() {
  try {
    // Get the root folder of Google Drive
    var rootFolder = DriveApp.getRootFolder();

    // Get all files in the root folder
    var files = rootFolder.getFiles();

    var fileData = [];

    // Iterate through each file
    while (files.hasNext()) {
      var file = files.next();

      // Get file information
      var fileId = file.getId();
      var fileName = file.getName();

      // Add file information to the array
      fileData.push([fileId, fileName]);
    }

    // Return the file information to the client side
    return fileData;
  } catch (error) {
    Logger.log('Error in browseDriveFiles: ' + error);
    throw error;
  }
}

function storeTriggerParameters(templateDocId, spreadsheetId, attachmentId, breakTime) {
  Logger.log(templateDocId);
  var userProperties = PropertiesService.getUserProperties();
  userProperties.setProperty('templateDocId', templateDocId);
  userProperties.setProperty('spreadsheetId', spreadsheetId);
  userProperties.setProperty('attachmentId', attachmentId);
  userProperties.setProperty('breakTime', breakTime);
}


function scheduleEmailsTrigger(templateDocId, spreadsheetId, attachmentId, timestamp, breakTime) {
  try {
    // var templateDocId = '1iDK5QQjyvPyg4NTnYF007I5qCb1FBgPLWa8M-WXuOO0';
    // var spreadsheetId = '1paZ2Vy9bSCE4OPEYcZ93oRwzNNPmvtKRd_GjI0X8kM8';
    // var attachmentId = 'noImage';
    // var timestamp = '2024-02-01 17:36';
    // var breakTime = 30;

        // Combine the date and time strings to create a timestamp
        var timestampDate = new Date(timestamp);
        // Store trigger parameters in script properties
        storeTriggerParameters(templateDocId, spreadsheetId, attachmentId, breakTime);
        // Logger.log(timestampDate);
        // Create a trigger to run the 'createPersonalizedEmails' function at the specified timestamp
        ScriptApp.newTrigger('createPersonalizedEmails')
          .timeBased()
          .at(timestampDate)
          .create();
        // ScriptApp.newTrigger('checkForNewEmails')
        //   .timeBased()
        //   .everyMinutes(5) // You can adjust the interval as needed
        //   .create();
  } catch (error) {
    Logger.log('Error in scheduleEmailsTrigger: ' + error);
    throw error;
  }
}



function createPersonalizedEmails(templateDocId, spreadsheetId, attachmentId, breakTime) {
  try {
        var userProperties = PropertiesService.getUserProperties();
        var templateDocId = userProperties.getProperty('templateDocId');
        var spreadsheetId = userProperties.getProperty('spreadsheetId');
        var attachmentId = userProperties.getProperty('attachmentId');
        var breakTime = userProperties.getProperty('breakTime');
     
    // var templateDocId = '1VimME5RPCwjNRRnEMzzoCu7RzzVwUhMfGMkTKiPIhpg';
    // var spreadsheetId = '1GP04qGxjowg_QSc1OCZH_-s2ZgztAo3vu8-m259QGUI';
    // var attachmentId = 'noImage';
    // var breakTime = 10;
    breakTime = breakTime * 1000;
    var sheet = SpreadsheetApp.openById(spreadsheetId).getActiveSheet();
    var emailQuotaRemaining = MailApp.getRemainingDailyQuota();
    // Get the data range (assuming names are in the first column and emails in the second column)
    var dataRange = sheet.getRange("A2:H" + sheet.getLastRow());

    // Get the data values
    var data = dataRange.getValues();
    // Open the template document
    var templateDoc = DocumentApp.openById(templateDocId);
    var templateBody = templateDoc.getBody();
    var templateText = templateBody.getText();
    // var headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
    // var subscribedIndex = headers.indexOf('subscribed');
    // var unsubscribeHashIndex = headers.indexOf('unsubscribe_hash');

    // if (subscribedIndex === -1 || unsubscribeHashIndex === -1) {
    // // Add "subscribed" and "unsubscribe_hash" columns after "company_name"
    // headers.splice(6, 0, 'subscribed', 'unsubscribe_hash');

    // // Set the header row with the added columns
    // sheet.getRange(1, 1, 1, headers.length).setValues([headers]);
    // Logger.log('checking subscribe');
    // for (var i = 1; i <= data.length && i <= 100; i++) {
    //   // Generate a random value for 'unsubscribe_hash'
    //   var email = data[i][4];
    //   if (email) {
    //     var unsubscribe_hash = getRandomHash(); // Define this function to generate a random hash
    //     data[i - 1][6] = 'yes'; // Assuming 'subscribed' is in column G
    //     data[i - 1][7] = unsubscribe_hash;
    //   }
    //   }
    //   // Set the values in the added columns for the data rows
    //   sheet.getRange(2, 1, data.length, data[0].length).setValues(data);
    // }



    var webAppUrl = 'https://script.google.com/macros/s/AKfycbyRiLLosjUUAZZJIK1EiAfua7ssUFoKzE0BpSVvhdlxY4OaZduoVzugkx45t45sKq3n/exec';
    var sourceEmail = Session.getActiveUser().getEmail();
    // Iterate through each row in the sheet
    for (var i = 0; i < data.length && i <= emailQuotaRemaining; i++) {
      // Get the name and email from the current row
      var first_name = data[i][0];
      var last_name = data[i][1];
      var sender_name = data[i][2];
      var subject = data[i][3];
      var email = data[i][4];
      var company_name = data[i][5];
      var subscribed = data[i][6];
      var token =  data[i][7]; 
      // Increment the count
      // Logger.log(last_name);
      // Logger.log(email);
      // Logger.log(email);
      // Logger.log(subscribed);
      // Logger.log(token);
      // Replace the placeholder in the template with the actual name
      if (email && validateEmail(email)) {
          // Replace the placeholder in the template with the actual name
          var personalizedEmail = templateText.replace(/{first_name}/g, first_name).replace(/{last_name}/g, last_name).replace(/{sender_name}/g, sender_name).replace(/{sender_companyname}/g, company_name);
          // // Create a new Google Doc for each personalized email
          // var newDoc = DocumentApp.create("Email From IREG ");
          // var newBody = newDoc.getBody();
          // newBody.setText(personalizedEmail);


          // var totalLength = personalizedEmail.length;
          // var seventyFivePercentLength = Math.ceil(totalLength * 0.726);

          // var firstVariableContent = personalizedEmail.substring(0, seventyFivePercentLength);
          // var secondVariableContent = personalizedEmail.substring(seventyFivePercentLength);
        
          // Send email with the content from the new Doc to the corresponding email address
          if (attachmentId == 'noImage'){
            var body = '<pre style="font-size: 14px; line-height: 1.5; font-family: Arial, sans-serif;">' + personalizedEmail + '</pre>'+ '<p>If you want to Unsubscribe to our email press Unsubscribe</p>' +
                    '<a href="' + webAppUrl + '?source_email=' + sourceEmail + '&unsubscribe_hash=' + token + '&sheetId=' + spreadsheetId + '">Unsubscribe</a>';
            MailApp.sendEmail({
            to: email,
            subject: subject,
            name: sender_name,  // Replace with your name or leave it as is
            htmlBody: body
            });
          } else {
            var body = '<table style="width: 100%;">' +
                      '<tr>' +
                        // '<td>' +
                        //   '<pre style="font-size: 14px; line-height: 1.5; font-family: Arial, sans-serif;">' + firstVariableContent + '</pre>' +
                        // '</td>' +
                        '<td>' +
                          '<img src="cid:logo" alt="Company Logo" style="display: block; margin-bottom: 10px auto;">' +
                        '</td>' +
                      '</tr>' +
                      '<tr>' +
                        '<td colspan="2">' +
                          '<pre style="font-size: 14px; line-height: 1.5; font-family: Arial, sans-serif;">' + personalizedEmail + '</pre>' +
                        '</td>' +
                        // '<td colspan="2">' +
                        //   '<pre style="font-size: 14px; line-height: 1.5; font-family: Arial, sans-serif;">' + secondVariableContent + '</pre>' +
                        // '</td>' +
                      '</tr>' +
                    '</table>' + '<p>If you want to Unsubscribe to our email press Unsubscribe</p>' +
                    '<a href="' + webAppUrl + '?source_email=' + sourceEmail + '&unsubscribe_hash=' + token + '&sheetId=' + spreadsheetId + '">Unsubscribe</a>';
            MailApp.sendEmail({
            to: email,
            subject: subject,
            name: sender_name,  // Replace with your name or leave it as is
            htmlBody: body,
            inlineImages: {
              logo: getInlineImage(attachmentId).inlineImageBlob
            } 
          });
          }
          Utilities.sleep(breakTime);
      } else {
        Logger.log('Email is missing for ' + first_name);
      }
    }
  } catch (error) {
    Logger.log('Error in createPersonalizedEmails: ' + error);
    throw error;
  }
}

function getInlineImage(attachmentId) {
  try {
    // var fileId = '1d15oWeKuuUNUnPenGcX0zO-Rg7MdfeN5'; // Replace with the actual Google Drive file ID of your image
    var file = DriveApp.getFileById(attachmentId);
    var blob = file.getBlob();
    return {
      inlineImageBlob: blob
    };
  } catch (error) {
    Logger.log('Error in getInlineImage: ' + error);
    throw error;
  }
}
function validateEmail(email) {
  var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function getRandomHash() {
  var randomString = Math.random().toString(36).substring(2);
  var hash = Utilities.computeDigest(Utilities.DigestAlgorithm.MD5, randomString, Utilities.Charset.UTF_8);
  return Utilities.base64Encode(hash);
}

function checkForNewEmails() {
  var subjectToMatch = 'Unsubscribe Confirmation';

// Get threads with the specified subject
var threads = GmailApp.search('subject:' + subjectToMatch);

// Get the IDs of processed emails from PropertiesService
var processedEmailIds = getProcessedEmailIds();

for (var i = 0; i < threads.length; i++) {
  var messages = threads[i].getMessages();

  for (var j = 0; j < messages.length; j++) {
    var message = messages[j];
    var messageId = message.getId();

    // Check if the email has already been processed
    if (!processedEmailIds.includes(messageId)) {
      // Extract information from the email
      var subject = message.getSubject();
      var sender = message.getFrom();
      var body = message.getBody();
      // var receivedTime = message.getDate();
      // var receivedTimeString = receivedTime.toLocaleString();
      // Process the form response in the email body
      var unsubscribeHash = extractHiddenFieldValue(body, 'unsubscribeHash');
      var sheetId = extractHiddenFieldValue(body, 'sheetId');
      Logger.log('unsubscribe Hash:' + unsubscribeHash);
      Logger.log('Sheet ID:' + sheetId)
      var sheet = SpreadsheetApp.openById(sheetId).getActiveSheet();

      // get the data in the sheet
      const data = sheet.getDataRange().getValues();

      // get headers
      const headers = data[0];
      const emailIndex = headers.indexOf('Email');
      const unsubscribeHashIndex = headers.indexOf('unsubscribe_hash');
      const subscribedIndex = headers.indexOf('subscribed');

      // iterate through the data, starting at index 1
      for (let i = 1; i < data.length; i++) {
        const row = data[i];
        const rowEmail = row[emailIndex];
        const rowHash = row[unsubscribeHashIndex];

        // if the email and unsubscribe hash match with the values in the sheet
        // then update the subscribed value to 'no'
        if (sender === rowEmail && unsubscribeHash === rowHash) {
          sheet.getRange(i + 1, subscribedIndex + 1).setValue('no');
          return true;
        }
      }

      // Mark the email as processed by adding its ID to the processedEmailIds array
      processedEmailIds.push(messageId);

      // Optionally, mark the email as read or move it to another folder to avoid processing it again
      // message.markRead();
      // message.moveToArchive();
    }
  }
}


  // Update the processed email IDs in PropertiesService
  setProcessedEmailIds(processedEmailIds);
}

function getProcessedEmailIds() {
  var propertyKey = 'processedEmailIds';
  var storedIds = PropertiesService.getUserProperties().getProperty(propertyKey);

  if (storedIds) {
    return JSON.parse(storedIds);
  } else {
    return [];
  }
}

function setProcessedEmailIds(ids) {
  var propertyKey = 'processedEmailIds';
  var stringifiedIds = JSON.stringify(ids);
  PropertiesService.getUserProperties().setProperty(propertyKey, stringifiedIds);
}

function extractHiddenFieldValue(body, fieldName) {
  var regex = new RegExp('<input[^>]+name="' + fieldName + '"[^>]+value="([^"]+)"[^>]*>', 'i');
  var match = body.match(regex);

  // If a match is found, return the captured value
  return match ? match[1].trim() : null;
}


