/**
 * Sends a personalized email to subscriber.
 * @param {Object} credentials - The credentails used to make email template.
 * @param {Object} sheetData - The subscriber data used to fill email template.
 */
function sendEmail(credentials, sheetData) {
  try {
    validateCredentialsData(credentials);
    validateSheetRow(sheetData);

    // Check if user is subscribed
    if (sheetData.subscribed=='yes') {
  
      // Get the email template document
      var templateText = readDocument(credentials.templateDocId);
      validateString(templateText,'Invalid email template');

      // Replace the placeholder in the template with the actual name
      var personalizedEmail = templateText
        .replace(/{first_name}/g, sheetData.first_name)
        .replace(/{last_name}/g, sheetData.last_name)
        .replace(/{sender_name}/g, sheetData.sender_name)
        .replace(/{sender_companyname}/g, sheetData.company_name);

      // Make unsubscribe link
      var unsubscribeLink = credentials.webAppUrl + '?source_email=' + credentials.sourceEmail + '&unsubscribe_hash=' + sheetData.token + '&sheetId=' + credentials.spreadsheetId;

      // Make email body
      var body =
        ((credentials.attachmentId == 'noImage') ? '' : (
          '<table style="width: 100%;">' +
            '<tr>' +
              '<td>' +
                '<img src="cid:logo" alt="Company Logo" style="display: block; margin-bottom: 10px auto;">' +
              '</td>' +
            '</tr>' +
            '<tr>' +
              '<td colspan="2">' )) +
                '<pre style="font-size: 14px; line-height: 1.5; font-family: Arial, sans-serif;">' + personalizedEmail + '</pre>' +
                ((credentials.attachmentId == 'noImage') ? '' : (
              '</td>' +
            '</tr>' +
          '</table>'
      )) +
      '<p>If you want to Unsubscribe to our email press Unsubscribe</p>' +
      '<a href="' + unsubscribeLink + '">Unsubscribe</a>';

      // Set email options
      var emailOptions = {
        to: sheetData.email,
        subject: sheetData.subject,
        name: sheetData.sender_name,
        htmlBody: body
      };

      // Check for attachment
      if (credentials.attachmentId != 'noImage') {
        emailOptions['inlineImages'] = {
          logo: getInlineImage(credentials.attachmentId).inlineImageBlob
        };
      }

      // Send personalized email
      MailApp.sendEmail(emailOptions);
      Utilities.sleep(credentials.breakTime);
    }
  } catch (error) {
    Logger.log('Error in sendEmail: ' + error);
    throw error;
  }
}
