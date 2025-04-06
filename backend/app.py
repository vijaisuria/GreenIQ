from flask import Flask
from config.config import Config
from auth.auth import auth_bp
from atc.texttospeech import texttospeech_bp
from atc.speechtotext import speechtotext_bp

app = Flask(__name__)
app.config.from_object(Config)

app.register_blueprint(auth_bp)
app.register_blueprint(texttospeech_bp)  # Text-to-Speech API
app.register_blueprint(speechtotext_bp)  # Speech-to-Text API

if __name__ == "__main__":
    app.secret_key = Config.SECRET_KEY
    app.run(debug=True)
