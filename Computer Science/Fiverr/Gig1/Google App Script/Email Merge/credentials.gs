/**
 * Retrieves credentials required for the application.
 * @returns {Object} Credentials object.
 */
function getCredentials() {
  return {
    'sheetId': '1gW2izhHBxLARncO8Q5VfXA4D3miKNbf5kmT6neHkA24', // ID of the source spreadsheet
    'sheetName': 'Sheet1', // Name of the source sheet
    'sheetRange': 'A1:A', // Range of cells in the source sheet
    'sourceEmail': Session.getActiveUser().getEmail(), // Email of the active user (running the script)
    'templateDocId': '1I_DrBb0hIfuG6EifyUkrkcFF0fIvXFN7iCR8M8HqBlA', // ID of the template document
    'spreadsheetId': '1pm8wjv_6RLRrtekmf-AvcB-yw9iuPAvIzxnyJC_tbwI', // ID of the destination spreadsheet
    'spreadsheetName': 'Sheet1', // Name of the destination sheet
    'spreadsheetRange': "A1:H", // Range of cells in the destination sheet
    'attachmentId': '1OXfw0Ue0jtuCmXt4YLLygCbdoqa-t9Hp', // ID of the default attachment (default is 'noImage')
    'timeStamp': '2024-02-01 17:36', // Timestamp
    'breakTime': 3000, // Break time in milliseconds
    'webAppUrl': 'https://script.google.com/macros/s/AKfycbyRiLLosjUUAZZJIK1EiAfua7ssUFoKzE0BpSVvhdlxY4OaZduoVzugkx45t45sKq3n/exec', // URL of the unsubscribe web app
    'emailQuotaRemaining': MailApp.getRemainingDailyQuota() // Remaining email quota for the day
  };
}
