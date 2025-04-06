from flask import Blueprint, request, jsonify, send_file
from google.oauth2 import service_account
from google.cloud import texttospeech

texttospeech_bp = Blueprint("texttospeech", __name__)

client_file = 'config/text_to_speech.json'  # Ensure this file exists
credentials = service_account.Credentials.from_service_account_file(client_file)
client = texttospeech.TextToSpeechClient(credentials=credentials)

#INPUT :
#text : text to be converted to speech
#format : json
#OUTPUT :
#mp3 file
@texttospeech_bp.route('/text-to-speech', methods=['POST'])
def synthesize_speech():
    try:
        if request.is_json:
            data = request.get_json()
        else:
            return jsonify({"error": "Request must be in JSON format"}), 415

        text = data.get("text", "")

        if not text:
            return jsonify({"error": "Text is required"}), 400

        synthesis_input = texttospeech.SynthesisInput(text=text)


        # Here you can modify voice's gender,accent.
        voice = texttospeech.VoiceSelectionParams(
            language_code="en-US",
            name="en-US-Wavenet-D",
            ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL
        )

        audio_config = texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3)

        response = client.synthesize_speech(
            input=synthesis_input, voice=voice, audio_config=audio_config
        )

        output_file = "output.mp3"
        with open(output_file, "wb") as out:
            out.write(response.audio_content)

        return send_file(output_file, mimetype="audio/mpeg")

    except Exception as e:
        return jsonify({"error": str(e)}), 500


