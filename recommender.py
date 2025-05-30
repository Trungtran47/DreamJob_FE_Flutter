from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd

def recommend_jobs_for_user(user_row, posts_df, top_n=10):
    user_profile = (
        f"{user_row['desired_job']} {user_row['user_experience']} {user_row['user_location']}"
    )

    posts_df['combined'] = (
        posts_df['title'].fillna('') + ' ' +
        posts_df['job_description'].fillna('') + ' ' +
        posts_df['location'].fillna('') + ' ' +
        posts_df['experience'].fillna('')
    )

    vectorizer = TfidfVectorizer(stop_words='english')
    tfidf_matrix = vectorizer.fit_transform(posts_df['combined'])
    user_vector = vectorizer.transform([user_profile])

    similarity_scores = cosine_similarity(user_vector, tfidf_matrix).flatten()
    posts_df['score'] = similarity_scores

    return posts_df.sort_values(by='score', ascending=False).head(top_n)
