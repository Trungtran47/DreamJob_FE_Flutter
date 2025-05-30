from flask import Flask, jsonify, request
from db import fetch_users, fetch_posts
from flask import Response
from recommender import recommend_jobs_for_user

app = Flask(__name__)

@app.route('/recommend/<int:user_id>', methods=['GET'])
def recommend(user_id):
    users_df = fetch_users()
    posts_df = fetch_posts()

    user_row = users_df[users_df['user_id'] == user_id]
    if user_row.empty:
        return jsonify({'error': 'User not found'}), 404

    recommendations = recommend_jobs_for_user(user_row.iloc[0], posts_df)
    json_data = recommendations[['post_id', 'title', 'score']].to_json(orient='records')
    return Response(json_data, content_type='application/json')

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=5000, debug=True)

