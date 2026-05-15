from flask import Blueprint, request, jsonify
from database.db_config import get_db_connection
from datetime import datetime

transactions_bp = Blueprint('transactions', __name__)

# --- REVENUS ---
@transactions_bp.route('/revenus', methods=['GET'])
def get_revenus():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({"message": "user_id requis"}), 400
    
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM revenus WHERE utilisateur_id = %s ORDER BY date DESC", (user_id,))
        revenus = cursor.fetchall()
        cursor.close()
        connection.close()
        return jsonify(revenus), 200
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/revenus', methods=['POST'])
def add_revenu():
    data = request.get_json()
    user_id = data.get('utilisateur_id')
    montant = data.get('montant')
    categorie = data.get('categorie')
    description = data.get('description')
    date = data.get('date')

    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO revenus (utilisateur_id, montant, categorie, description, date)
            VALUES (%s, %s, %s, %s, %s)
        """, (user_id, montant, categorie, description, date))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Revenu ajouté"}), 201
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/revenus/<int:id>', methods=['PUT'])
def update_revenu(id):
    data = request.get_json()
    montant = data.get('montant')
    categorie = data.get('categorie')
    description = data.get('description')
    date = data.get('date')

    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("""
            UPDATE revenus SET montant=%s, categorie=%s, description=%s, date=%s
            WHERE id=%s
        """, (montant, categorie, description, date, id))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Revenu mis à jour"}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/revenus/<int:id>', methods=['DELETE'])
def delete_revenu(id):
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("DELETE FROM revenus WHERE id=%s", (id,))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Revenu supprimé"}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

# --- DEPENSES ---
@transactions_bp.route('/depenses', methods=['GET'])
def get_depenses():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({"message": "user_id requis"}), 400
    
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM depenses WHERE utilisateur_id = %s ORDER BY date DESC", (user_id,))
        depenses = cursor.fetchall()
        cursor.close()
        connection.close()
        return jsonify(depenses), 200
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/depenses', methods=['POST'])
def add_depense():
    data = request.get_json()
    user_id = data.get('utilisateur_id')
    montant = data.get('montant')
    categorie = data.get('categorie')
    description = data.get('description')
    date = data.get('date')

    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO depenses (utilisateur_id, montant, categorie, description, date)
            VALUES (%s, %s, %s, %s, %s)
        """, (user_id, montant, categorie, description, date))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Dépense ajoutée"}), 201
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/depenses/<int:id>', methods=['PUT'])
def update_depense(id):
    data = request.get_json()
    montant = data.get('montant')
    categorie = data.get('categorie')
    description = data.get('description')
    date = data.get('date')

    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("""
            UPDATE depenses SET montant=%s, categorie=%s, description=%s, date=%s
            WHERE id=%s
        """, (montant, categorie, description, date, id))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Dépense mise à jour"}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/depenses/<int:id>', methods=['DELETE'])
def delete_depense(id):
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        cursor.execute("DELETE FROM depenses WHERE id=%s", (id,))
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Dépense supprimée"}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

# --- BUDGET ---
@transactions_bp.route('/budget', methods=['GET'])
def get_budget():
    user_id = request.args.get('user_id')
    mois = request.args.get('mois') # Format YYYY-MM-01
    if not user_id or not mois:
        return jsonify({"message": "user_id et mois requis"}), 400
    
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM budgets WHERE utilisateur_id = %s AND mois = %s", (user_id, mois))
        budget = cursor.fetchone()
        cursor.close()
        connection.close()
        return jsonify(budget if budget else {"montant": 0}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

@transactions_bp.route('/budget', methods=['POST'])
def set_budget():
    data = request.get_json()
    user_id = data.get('utilisateur_id')
    montant = data.get('montant')
    mois = data.get('mois')

    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT id FROM budgets WHERE utilisateur_id = %s AND mois = %s", (user_id, mois))
        existing = cursor.fetchone()
        
        if existing:
            cursor.execute("UPDATE budgets SET montant = %s WHERE id = %s", (montant, existing['id']))
        else:
            cursor.execute("INSERT INTO budgets (utilisateur_id, montant, mois) VALUES (%s, %s, %s)", (user_id, montant, mois))
            
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"message": "Budget mis à jour"}), 200
    return jsonify({"message": "Erreur de connexion"}), 500

# --- DASHBOARD ---
@transactions_bp.route('/dashboard', methods=['GET'])
def get_dashboard():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({"message": "user_id requis"}), 400
    
    now = datetime.now()
    first_day_of_month = now.replace(day=1).strftime('%Y-%m-%d')
    
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor(dictionary=True)
        
        # Total Revenus
        cursor.execute("SELECT SUM(montant) as total FROM revenus WHERE utilisateur_id = %s", (user_id,))
        total_revenus = cursor.fetchone()['total'] or 0
        
        # Total Dépenses
        cursor.execute("SELECT SUM(montant) as total FROM depenses WHERE utilisateur_id = %s", (user_id,))
        total_depenses = cursor.fetchone()['total'] or 0
        
        # Budget du mois
        cursor.execute("SELECT montant FROM budgets WHERE utilisateur_id = %s AND mois = %s", (user_id, first_day_of_month))
        res_budget = cursor.fetchone()
        budget_mensuel = res_budget['montant'] if res_budget else 0
        
        # Dernières transactions (mélange revenus et dépenses)
        cursor.execute("""
            (SELECT 'revenu' as type, montant, categorie, date, description FROM revenus WHERE utilisateur_id = %s)
            UNION ALL
            (SELECT 'depense' as type, montant, categorie, date, description FROM depenses WHERE utilisateur_id = %s)
            ORDER BY date DESC LIMIT 5
        """, (user_id, user_id))
        last_transactions = cursor.fetchall()
        
        # Dépenses par catégorie pour le graphique
        cursor.execute("""
            SELECT categorie, SUM(montant) as total FROM depenses 
            WHERE utilisateur_id = %s GROUP BY categorie
        """, (user_id,))
        stats_categories = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        return jsonify({
            "solde": float(total_revenus) - float(total_depenses),
            "total_revenus": float(total_revenus),
            "total_depenses": float(total_depenses),
            "budget_mensuel": float(budget_mensuel),
            "dernieres_transactions": last_transactions,
            "stats_categories": stats_categories
        }), 200
    return jsonify({"message": "Erreur de connexion"}), 500
