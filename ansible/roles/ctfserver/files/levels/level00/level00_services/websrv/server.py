from werkzeug.serving import run_simple
from iframes.make_app import make_app
import os,sys

if __name__ == '__main__':
  app = make_app()
  run_simple('localhost', 8080, app, use_reloader=True)
