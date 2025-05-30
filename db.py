import pyodbc
import pandas as pd

def get_connection():
    conn = pyodbc.connect(
        "Driver={SQL Server};"
        "Server=localhost;"
        "Database=DREAMJOB;"
        "UID=sa;"
        "PWD=472003;"
    )
    return conn

def fetch_users():
    query = "SELECT * FROM app_user"
    return pd.read_sql(query, get_connection())

def fetch_posts():
    query = "SELECT * FROM app_post WHERE expiration_date > GETDATE()"
    return pd.read_sql(query, get_connection())
