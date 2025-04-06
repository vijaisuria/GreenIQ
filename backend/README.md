# Running the Backend

## Prerequisites

1. Ensure you have Python installed on your system.
2. Install the required dependencies by running:
   ```bash
   pip install -r requirements.txt
   ```

## Configuration

1. Obtain the following JSON configuration files:

   - `firebase_admin.json` from the Firebase Console.
   - `speech_to_text.json` from Google Cloud Platform (GCP).
   - `text_to_speech.json` from Google Cloud Platform (GCP).

2. Place these files in the `config` directory within the project root:
   ```
   /config/firebase_admin.json
   /config/speech_to_text.json
   /config/text_to_speech.json
   ```

## Running the Application

1. Start the backend server by running:

   ```bash
   python app.py
   ```

2. The server will be available at `http://localhost:5000`.
