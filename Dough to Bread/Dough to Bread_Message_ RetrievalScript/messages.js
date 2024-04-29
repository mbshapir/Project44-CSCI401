var admin = require("firebase-admin");

var serviceAccount = require('.\/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://dough-to-bread-default-rtdb.firebaseio.com"
});

const XLSX = require('xlsx');
const fs = require('fs'); // For file system access

//const { admin } = require('./firebase'); 
const timestamp = Date.now(); // Get current timestamp
const excelFilePath = `./messages.xlsx`; // Include timestamp in filename


console.log('Starting here at the top.');

async function fetchAndWriteToExcel() {
    try {
      console.log('Starting here.');
      // 1. Fetch messages from Firebase
      const messagesRef = admin.database().ref('coachMessages'); // Adjusted path
  
      const messagesSnapshot = await messagesRef.once('value');
      const messagesData = []; // Array to store extracted messages
      console.log('Getting here.');
  
      // Iterate through each child node under 'coachMessages'
      messagesSnapshot.forEach((messageSnapshot) => {
        const messageId = messageSnapshot.key; // Get the message ID (assuming it's the key)
  
        // Access the actual message content within the child node
        const messageContent = messageSnapshot.val();
  
        // Extract specific data from message content (adjust as needed)
        const subject = messageContent.subject || ''; // Handle potential missing subject
        const timestamp = messageContent.timestamp || null; // Handle potential missing timestamp
        const messageText = messageContent.message.replace(/\r?\n|\r/g, ' '); // Remove line breaks from message
  
        // Create an object for each message with desired data
        messagesData.push({
          id: messageId,
          subject: subject,
          timestamp: timestamp,
          message: messageText
        });
      });
    

      const excelData = messagesData.map(message => {
        // Extract timestamp and format it using a desired date/time format
        const formattedTimestamp = new Date(message.timestamp).toLocaleString(); // Adjust format string if needed
      
        return [
          message.id,
          message.subject,
          formattedTimestamp, // Include formatted timestamp
          message.message // Include message text
        ];
      });
  
      // 3. Write data to Excel file (rest remains the same)
    console.log(excelFilePath)
    let workbook;
      if (!fs.existsSync(excelFilePath)) {
        // Create a new workbook (empty Excel file)
         //workbook = XLSX.utils.book_new();
        workbook = XLSX.utils.book_new();
        let worksheet = XLSX.utils.aoa_to_sheet([
          ['ID', 'Subject', 'Timestamp', 'Message'] // Header row
        ]);
        XLSX.utils.book_append_sheet(workbook, worksheet, 'Sheet1');
         console.log('new one created');
      } else {
        // File exists, proceed with reading or writing using readFile
         workbook = XLSX.readFile(excelFilePath, { createSheet: true });
         console.log('new one not created');
        
      }
    const worksheet = workbook.Sheets['Sheet1'];
    XLSX.utils.sheet_add_aoa(worksheet, excelData, { origin: -1 });
    XLSX.writeFile(workbook, excelFilePath);
  
      console.log('Messages successfully written to Excel file!');
    } catch (error) {
      console.error('Error fetching or writing messages:', error);
    }
  }
  fetchAndWriteToExcel();  // Call the function to execute the script

  
  
