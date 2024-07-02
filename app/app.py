from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'postgresql://user:password@localhost/visitors')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class Visitor(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    ip = db.Column(db.String(80), unique=True, nullable=False)

@app.route('/')
def home():
    visitor_ip = request.remote_addr
    if not Visitor.query.filter_by(ip=visitor_ip).first():
        new_visitor = Visitor(ip=visitor_ip)
        db.session.add(new_visitor)
        db.session.commit()
    visitors = Visitor.query.all()
    return f"Unique visitors: {len(visitors)}"

@app.route('/version')
def version():
    return jsonify(version="1.0.0")

if __name__ == '__main__':
    db.create_all()
    app.run(host='0.0.0.0', port=5000)
