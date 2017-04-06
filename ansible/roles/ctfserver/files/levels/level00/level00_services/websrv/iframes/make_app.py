from werkzeug.wsgi import SharedDataMiddleware
from werkzeug.routing import Map, Rule
from werkzeug.wrappers import Request, Response
from werkzeug.exceptions import HTTPException, NotFound
import os, sys

SESSION_DISCOVERY_DIR='/var/ctfgame1/tmp/sessions/'
SESSION_WRITE_DIR='/var/ctfgame1/sessions/levels/'

def getActiveSessions():
  listen = []
  for fn in os.listdir(SESSION_DISCOVERY_DIR):
    if os.path.isfile(os.path.join(SESSION_DISCOVERY_DIR,fn)):
      listen.append(fn)
  return listen

def renderIFrameHell():
  def getIframe(sessionId):
    return """ <iframe src="%s"></iframe><br>\n """ % (sessionId,)

  iframesList = []
  for sessionId in getActiveSessions():
    if os.path.exists(os.path.join(SESSION_WRITE_DIR, sessionId)):
      if os.path.exists(os.path.join(SESSION_WRITE_DIR, sessionId, 'workspace', 'inject.html')):
        iframesList.append(getIframe(sessionId))

  htmlData = """
    <html>
      <head>
        <title>IFrames!</title>
      </head>
      <body>
        %s
      </body>
    </html>
    """ % ("\n".join( iframesList ) ,)
  return htmlData


class Level00Website(object):

  def __init__(self, config):
    print("[+] Level 00 Website up and running")
    self.url_map = Map([
      Rule('/', endpoint='index'),
      Rule('/<sessionId>', endpoint='new_iframe'),
    ])

  def on_new_iframe(self, request, sessionId):
    iframePath = os.path.join(SESSION_WRITE_DIR, sessionId, 'workspace', 'inject.html')
    textString = ''
    if os.path.isfile(iframePath):
      f = open(os.path.join(iframePath, ''))
      textString = f.read()
      f.close()
    else:
      textString = 'none'
    return Response('%s' % (request,), mimetype='text/html')

  def on_index(self, request):
    return Response(renderIFrameHell(), mimetype='text/html')

  def dispatch_request(self, request):
    adapter = self.url_map.bind_to_environ(request.environ)
    try:
      endpoint, values = adapter.match()
      return getattr(self, 'on_' + endpoint)(request, **values)
    except HTTPException, e:
      return e

  def wsgi_app(self, environ, start_response):
    request = Request(environ)
    response = self.dispatch_request(request)
    return response(environ, start_response)

  def __call__(self, environ, start_response):
    return self.wsgi_app(environ, start_response)

def make_app(with_static=True):
  app = Level00Website({
      'sessions_directory': '/var/ctfgame1/sessions/levels',
      'active_sessions_dir': '/var/ctfgame1/tmp/sessions'
    })
  if with_static:
    app.wsgi_app = SharedDataMiddleware(app.wsgi_app, {
      '/static':  os.path.join(os.path.dirname(__file__), 'static')
    })
  return app
