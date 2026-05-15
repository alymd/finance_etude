from flask import Blueprint, request, jsonify
from database.db_config import get_db_connection

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    nom = data.get('nom')
    email = data.get('email')
    mot_de_passe = data.get('mot_de_passe')

    if not nom or not email or not mot_de_passe:
        return jsonify({"message": "Tous les champs sont obligatoires"}), 400

    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM utilisateurs WHERE email = %s", (email,))
            if cursor.fetchone():
                return jsonify({"message": "Cet email est déjà utilisé"}), 400

            cursor.execute("""
                INSERT INTO utilisateurs (nom, email, mot_de_passe) 
                VALUES (%s, %s, %s)
            """, (nom, email, mot_de_passe))
            connection.commit()
            return jsonify({"message": "Utilisateur créé avec succès"}), 201
        except Exception as e:
            return jsonify({"message": f"Erreur: {str(e)}"}), 500
        finally:
            cursor.close()
            connection.close()
    return jsonify({"message": "Erreur de connexion à la base de données"}), 500

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    mot_de_passe = data.get('mot_de_passe')

    if not email or not mot_de_passe:
        return jsonify({"message": "Email et mot de passe requis"}), 400

    connection = get_db_connection()
    if connection:
        try:
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM utilisateurs WHERE email = %s AND mot_de_passe = %s", (email, mot_de_passe))
            user = cursor.fetchone()
            if user:
                # Retirer le mot de passe de la réponse
                user.pop('mot_de_passe')
                return jsonify({"message": "Connexion réussie", "user": user}), 200
            else:
                return jsonify({"message": "Identifiants invalides"}), 401
        except Exception as e:
            return jsonify({"message": f"Erreur: {str(e)}"}), 500
        finally:
            cursor.close()
            connection.close()
    return jsonify({"message": "Erreur de connexion à la base de données"}), 500
