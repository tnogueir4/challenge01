from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World 001!"

@app.route("/version")
def vers():
    return "App v1.0"

@app.route("/server")
def serv():
    return "container 01"

if __name__ == '__main__':
  app.run(debug=True)