"""
Routes pour la gestion des revenus
"""
from flask import Blueprint, request, jsonify
from database.db import execute_query
from datetime import date

revenus_bp = Blueprint('revenus', __name__)

CATEGORIES_VALIDES = [
    'bourse', 'famille', 'travail', 'freelance', 'vente', 'autres'
]


def valider_revenu(data):
    """Valide les données d'un revenu."""
    erreurs = []
    
    try:
        montant = float(data.get('montant', 0))
        if montant <= 0:
            erreurs.append('Le montant doit être positif.')
    except (ValueError, TypeError):
        erreurs.append('Montant invalide.')
    
    categorie = data.get('categorie', '').strip()
    if not categorie:
        erreurs.append('La catégorie est obligatoire.')
    
    date_str = data.get('date', '').strip()
    if not date_str:
        erreurs.append('La date est obligatoire.')
    
    return erreurs


@revenus_bp.route('/revenus', methods=['GET'])
def lister_revenus():
    """Liste tous les revenus d'un utilisateur."""
    utilisateur_id = request.args.get('utilisateur_id')
    
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    # Filtres optionnels
    mois = request.args.get('mois')  # Format: YYYY-MM
    
    if mois:
        query = '''
            SELECT id, montant, categorie, description, date, date_creation
            FROM revenus
            WHERE utilisateur_id = %s AND DATE_FORMAT(date, '%%Y-%%m') = %s
            ORDER BY date DESC
        '''
        revenus = execute_query(query, (utilisateur_id, mois), fetch=True)
    else:
        query = '''
            SELECT id, montant, categorie, description, date, date_creation
            FROM revenus
            WHERE utilisateur_id = %s
            ORDER BY date DESC
            LIMIT 100
        '''
        revenus = execute_query(query, (utilisateur_id,), fetch=True)
    
    if revenus is None:
        return jsonify({'erreur': 'Erreur base de données'}), 500
    
    # Convertir les dates en string
    for r in revenus:
        if r.get('date'):
            r['date'] = str(r['date'])
        if r.get('date_creation'):
            r['date_creation'] = str(r['date_creation'])
        r['montant'] = float(r['montant'])
    
    return jsonify({'revenus': revenus}), 200


@revenus_bp.route('/revenus', methods=['POST'])
def ajouter_revenu():
    """Ajouter un nouveau revenu."""
    data = request.get_json()
    
    if not data:
        return jsonify({'erreur': 'Données manquantes'}), 400
    
    utilisateur_id = data.get('utilisateur_id')
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    erreurs = valider_revenu(data)
    if erreurs:
        return jsonify({'erreur': ' | '.join(erreurs)}), 400
    
    revenu_id = execute_query(
        '''INSERT INTO revenus (utilisateur_id, montant, categorie, description, date)
           VALUES (%s, %s, %s, %s, %s)''',
        (
            utilisateur_id,
            float(data['montant']),
            data['categorie'].strip(),
            data.get('description', '').strip(),
            data['date']
        )
    )
    
    if revenu_id:
        return jsonify({
            'message': 'Revenu ajouté avec succès !',
            'id': revenu_id
        }), 201
    
    return jsonify({'erreur': 'Erreur lors de l\'ajout du revenu.'}), 500


@revenus_bp.route('/revenus/<int:revenu_id>', methods=['PUT'])
def modifier_revenu(revenu_id):
    """Modifier un revenu existant."""
    data = request.get_json()
    
    if not data:
        return jsonify({'erreur': 'Données manquantes'}), 400
    
    utilisateur_id = data.get('utilisateur_id')
    
    # Vérifier que le revenu appartient à l'utilisateur
    existant = execute_query(
        'SELECT id FROM revenus WHERE id = %s AND utilisateur_id = %s',
        (revenu_id, utilisateur_id), fetch=True
    )
    if not existant:
        return jsonify({'erreur': 'Revenu introuvable.'}), 404
    
    erreurs = valider_revenu(data)
    if erreurs:
        return jsonify({'erreur': ' | '.join(erreurs)}), 400
    
    result = execute_query(
        '''UPDATE revenus SET montant = %s, categorie = %s, description = %s, date = %s
           WHERE id = %s AND utilisateur_id = %s''',
        (
            float(data['montant']),
            data['categorie'].strip(),
            data.get('description', '').strip(),
            data['date'],
            revenu_id,
            utilisateur_id
        )
    )
    
    return jsonify({'message': 'Revenu modifié avec succès !'}), 200


@revenus_bp.route('/revenus/<int:revenu_id>', methods=['DELETE'])
def supprimer_revenu(revenu_id):
    """Supprimer un revenu."""
    utilisateur_id = request.args.get('utilisateur_id')
    
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    existant = execute_query(
        'SELECT id FROM revenus WHERE id = %s AND utilisateur_id = %s',
        (revenu_id, utilisateur_id), fetch=True
    )
    if not existant:
        return jsonify({'erreur': 'Revenu introuvable.'}), 404
    
    execute_query(
        'DELETE FROM revenus WHERE id = %s AND utilisateur_id = %s',
        (revenu_id, utilisateur_id)
    )
    
    return jsonify({'message': 'Revenu supprimé avec succès !'}), 200
