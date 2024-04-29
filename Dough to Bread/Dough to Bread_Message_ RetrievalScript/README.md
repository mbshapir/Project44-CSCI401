Running the Script:

Prerequisites:

Node.js and npm (or yarn): You'll need Node.js and a package manager (npm or yarn) installed on your system. You can download them from https://nodejs.org/en.
Instructions:

Download and Extract Files: Make sure you have received the following files:

firebase.js
messages.js
serviceAccountKey.json Extract them to a convenient location on your computer.

Open Terminal/Command Prompt: Open a terminal window (on macOS/Linux) or command prompt (on Windows). Navigate to the directory where you extracted the downloaded files.

Install Dependencies (One-Time Step):

In the terminal, run the following command to install the required Node.js packages from the package.json file (assuming it's present in the downloaded files):

npm install

Note: This step only needs to be done once. Subsequent runs won't require reinstalling dependencies.

Open Terminal/Command Prompt: Open a terminal window (on macOS/Linux) or command prompt (on Windows). Navigate to the directory where you extracted the downloaded files.

Run the Script:
In the terminal, type the following command and press Enter:
node messages.js

The script will connect to Firebase using the provided serviceAccountKey.json file, retrieve new messages, and create or update the messages.xlsx file in the same directory.

