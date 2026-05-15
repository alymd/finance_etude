"""
Routes pour la gestion des dépenses
"""
from flask import Blueprint, request, jsonify
from database.db import execute_query

depenses_bp = Blueprint('depenses', __name__)

CATEGORIES_VALIDES = [
    'nourriture', 'transport', 'internet', 'loisirs', 'education', 'sante', 'logement', 'autres'
]


def valider_depense(data):
    """Valide les données d'une dépense."""
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


@depenses_bp.route('/depenses', methods=['GET'])
def lister_depenses():
    """Liste toutes les dépenses d'un utilisateur."""
    utilisateur_id = request.args.get('utilisateur_id')
    
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    mois = request.args.get('mois')  # Format: YYYY-MM
    
    if mois:
        query = '''
            SELECT id, montant, categorie, description, date, date_creation
            FROM depenses
            WHERE utilisateur_id = %s AND DATE_FORMAT(date, '%%Y-%%m') = %s
            ORDER BY date DESC
        '''
        depenses = execute_query(query, (utilisateur_id, mois), fetch=True)
    else:
        query = '''
            SELECT id, montant, categorie, description, date, date_creation
            FROM depenses
            WHERE utilisateur_id = %s
            ORDER BY date DESC
            LIMIT 100
        '''
        depenses = execute_query(query, (utilisateur_id,), fetch=True)
    
    if depenses is None:
        return jsonify({'erreur': 'Erreur base de données'}), 500
    
    for d in depenses:
        if d.get('date'):
            d['date'] = str(d['date'])
        if d.get('date_creation'):
            d['date_creation'] = str(d['date_creation'])
        d['montant'] = float(d['montant'])
    
    return jsonify({'depenses': depenses}), 200


@depenses_bp.route('/depenses', methods=['POST'])
def ajouter_depense():
    """Ajouter une nouvelle dépense."""
    data = request.get_json()
    
    if not data:
        return jsonify({'erreur': 'Données manquantes'}), 400
    
    utilisateur_id = data.get('utilisateur_id')
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    erreurs = valider_depense(data)
    if erreurs:
        return jsonify({'erreur': ' | '.join(erreurs)}), 400
    
    depense_id = execute_query(
        '''INSERT INTO depenses (utilisateur_id, montant, categorie, description, date)
           VALUES (%s, %s, %s, %s, %s)''',
        (
            utilisateur_id,
            float(data['montant']),
            data['categorie'].strip(),
            data.get('description', '').strip(),
            data['date']
        )
    )
    
    if depense_id:
        return jsonify({
            'message': 'Dépense ajoutée avec succès !',
            'id': depense_id
        }), 201
    
    return jsonify({'erreur': 'Erreur lors de l\'ajout de la dépense.'}), 500


@depenses_bp.route('/depenses/<int:depense_id>', methods=['PUT'])
def modifier_depense(depense_id):
    """Modifier une dépense existante."""
    data = request.get_json()
    
    if not data:
        return jsonify({'erreur': 'Données manquantes'}), 400
    
    utilisateur_id = data.get('utilisateur_id')
    
    existant = execute_query(
        'SELECT id FROM depenses WHERE id = %s AND utilisateur_id = %s',
        (depense_id, utilisateur_id), fetch=True
    )
    if not existant:
        return jsonify({'erreur': 'Dépense introuvable.'}), 404
    
    erreurs = valider_depense(data)
    if erreurs:
        return jsonify({'erreur': ' | '.join(erreurs)}), 400
    
    execute_query(
        '''UPDATE depenses SET montant = %s, categorie = %s, description = %s, date = %s
           WHERE id = %s AND utilisateur_id = %s''',
        (
            float(data['montant']),
            data['categorie'].strip(),
            data.get('description', '').strip(),
            data['date'],
            depense_id,
            utilisateur_id
        )
    )
    
    return jsonify({'message': 'Dépense modifiée avec succès !'}), 200


@depenses_bp.route('/depenses/<int:depense_id>', methods=['DELETE'])
def supprimer_depense(depense_id):
    """Supprimer une dépense."""
    utilisateur_id = request.args.get('utilisateur_id')
    
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    existant = execute_query(
        'SELECT id FROM depenses WHERE id = %s AND utilisateur_id = %s',
        (depense_id, utilisateur_id), fetch=True
    )
    if not existant:
        return jsonify({'erreur': 'Dépense introuvable.'}), 404
    
    execute_query(
        'DELETE FROM depenses WHERE id = %s AND utilisateur_id = %s',
        (depense_id, utilisateur_id)
    )
    
    return jsonify({'message': 'Dépense supprimée avec succès !'}), 200


@depenses_bp.route('/depenses/stats', methods=['GET'])
def stats_depenses():
    """Statistiques des dépenses par catégorie."""
    utilisateur_id = request.args.get('utilisateur_id')
    mois = request.args.get('mois')
    
    if not utilisateur_id:
        return jsonify({'erreur': 'utilisateur_id manquant'}), 400
    
    if mois:
        query = '''
            SELECT categorie, SUM(montant) as total, COUNT(*) as nombre
            FROM depenses
            WHERE utilisateur_id = %s AND DATE_FORMAT(date, '%%Y-%%m') = %s
            GROUP BY categorie
            ORDER BY total DESC
        '''
        stats = execute_query(query, (utilisateur_id, mois), fetch=True)
    else:
        query = '''
            SELECT categorie, SUM(montant) as total, COUNT(*) as nombre
            FROM depenses
            WHERE utilisateur_id = %s
            GROUP BY categorie
            ORDER BY total DESC
        '''
        stats = execute_query(query, (utilisateur_id,), fetch=True)
    
    if stats is None:
        return jsonify({'erreur': 'Erreur base de données'}), 500
    
    for s in stats:
        s['total'] = float(s['total'])
    
    return jsonify({'stats': stats}), 200
