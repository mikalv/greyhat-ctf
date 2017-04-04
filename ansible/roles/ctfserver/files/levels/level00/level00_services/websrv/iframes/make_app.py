
class Level00Website(object):

  def __init__(self, config):
    print "[+] Level 00 Website up and running"

  def dispatch_request(self, request):
    return Response('Hello World!')

  def wsgi_app(self, environ, start_response):
    request = Request(environ)
    response = self.dispatch_request(request)
    return response(environ, start_response)

  def __call__(self, environ, start_response):
    return self.wsgi_app(environ, start_response)

def make_app(with_static=True):
  app = Level00Website({
      'sessions_directory': '/var/ctfgame1/sessions/levels'
    })
  if with_static:
    app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
      '/static':  os.path.join(os.path.dirname(__file__), 'static')
    })
  return app
