import wave
from flask import Blueprint, request, jsonify
from google.oauth2 import service_account
from google.cloud import speech

speechtotext_bp = Blueprint("speechtotext", __name__)

# Google Cloud authentication
client_file = 'config/speech_to_text.json'  # Ensure this file exists
credentials = service_account.Credentials.from_service_account_file(client_file)
client = speech.SpeechClient(credentials=credentials)

#INPUT :
#audio : audio file to be converted to text
#format : .wav (FORM-DATA)
#OUTPUT :
#text
@speechtotext_bp.route('/speech-to-text', methods=['POST'])
def speech_to_text():
    try:
        # Ensure a file is provided
        if 'audio' not in request.files:
            return jsonify({"error": "Audio file is required"}), 400

        audio_file = request.files['audio']
        audio_content = audio_file.read()

        # Configure request for Google Speech API
        audio = speech.RecognitionAudio(content=audio_content)
        config = speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,  # Adjust if needed
            language_code="en-US"  # Change for other languages
        )

        # Perform speech recognition
        response = client.recognize(config=config, audio=audio)

        # Extract transcribed text
        text_transcription = " ".join([result.alternatives[0].transcript for result in response.results])

        return jsonify({"transcription": text_transcription})

    except Exception as e:
        return jsonify({"error": str(e)}), 500


