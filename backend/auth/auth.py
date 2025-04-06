from flask import Blueprint, request, jsonify
from auth.firebase import users_collection
from firebase_admin import auth

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/authenticate", methods=['POST'])
def authenticate_user():
    try:
        data = request.get_json()
        id_token = data.get('idToken')
        email = data.get('email')
        method = data.get('method')
        name = data.get('name')

        if data.get('method') == "signup":
            phone = data.get('phone')
        if users_collection.where("email", "==", email).stream():
            return jsonify({"error": "User already exists"}), 400

        decoded_token = auth.verify_id_token(id_token)
        uid = decoded_token['uid']

        user_ref = users_collection.document(uid)
        if(method == "signup"):
            user_ref.set({
                'phone': phone,
            })
        user_ref.set({
            'email': email,
            'method': method,
            'uid': uid,
            'name': name
        })

        return jsonify({"message": "User authenticated", "uid": uid}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 401