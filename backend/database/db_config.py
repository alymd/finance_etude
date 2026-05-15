import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv('DB_HOST', 'localhost'),
            database=os.getenv('DB_NAME', 'finance_etude'),
            user=os.getenv('DB_USER', 'root'),
            password=os.getenv('DB_PASSWORD', '')
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Erreur lors de la connexion à MySQL: {e}")
        return None

def init_db():
    connection = get_db_connection()
    if connection:
        cursor = connection.cursor()
        
        # Création de la table utilisateurs
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS utilisateurs (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nom VARCHAR(255) NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                mot_de_passe VARCHAR(255) NOT NULL,
                role VARCHAR(50) DEFAULT 'user'
            )
        """)
        
        # Création de la table revenus
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS revenus (
                id INT AUTO_INCREMENT PRIMARY KEY,
                utilisateur_id INT,
                montant DECIMAL(10, 2) NOT NULL,
                categorie VARCHAR(255) NOT NULL,
                description TEXT,
                date DATE NOT NULL,
                FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
            )
        """)
        
        # Création de la table depenses
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS depenses (
                id INT AUTO_INCREMENT PRIMARY KEY,
                utilisateur_id INT,
                montant DECIMAL(10, 2) NOT NULL,
                categorie VARCHAR(255) NOT NULL,
                description TEXT,
                date DATE NOT NULL,
                FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
            )
        """)
        
        # Création de la table budgets
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS budgets (
                id INT AUTO_INCREMENT PRIMARY KEY,
                utilisateur_id INT,
                montant DECIMAL(10, 2) NOT NULL,
                mois DATE NOT NULL,
                FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id) ON DELETE CASCADE
            )
        """)
        
        # Créer l'administrateur par défaut
        cursor.execute("SELECT * FROM utilisateurs WHERE email = 'admin@gmail.com'")
        if not cursor.fetchone():
            # Dans un vrai projet, on hacherait le mot de passe. 
            # Pour cet exercice, nous suivons les instructions de l'utilisateur.
            cursor.execute("""
                INSERT INTO utilisateurs (nom, email, mot_de_passe, role) 
                VALUES ('admin', 'admin@gmail.com', '123456', 'admin')
            """)
        
        connection.commit()
        cursor.close()
        connection.close()
        print("Base de données initialisée avec succès.")
    else:
        print("Échec de l'initialisation de la base de données.")
