from flask import Flask
from flask_cors import CORS
from database.db_config import get_db_connection
from flask import jsonify
from database.db_config import init_db
from routes.auth import auth_bp
from routes.transactions import transactions_bp
import os

app = Flask(__name__)
CORS(app)

# Enregistrement des blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(transactions_bp)

@app.route('/')
def index():
    return {"message": "Bienvenue sur l'API de Gestion Financière Étudiante"}

@app.route('/test-db')
def test_db():
    conn = get_db_connection()

    if conn is None:
        return jsonify({
            "status": "error",
            "message": "DB connection failed 💀"
        })

    try:
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        result = cursor.fetchone()

        return jsonify({
            "status": "success",
            "result": result
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        })

    finally:
        conn.close()

@app.route('/create-test-user')
def create_test_user():
    conn = get_db_connection()

    if conn is None:
        return {"error": "DB not connected"}
    
    cursor = conn.cursor()

    try:
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO utilisateurs (nom, email, mot_de_passe, role)
            VALUES ('test', 'test@gmail.com', '123456', 'user')
        """)

        conn.commit()

        return {"message": "user created"}

    except Exception as e:
        return {"error": str(e)}

    finally:
        cursor.close()
        conn.close()


if __name__ == '__main__':
    # Initialisation de la base de données au démarrage
    # Note: Dans un environnement réel, assurez-vous que MySQL est lancé avant.
    try:
        init_db()
    except Exception as e:
        print(f"Erreur d'initialisation DB: {e}")
        
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
