var page = require('webpage').create();
var process = require('process');
var host = "127.0.0.1";
var sessionid = process.env.SESSION_ID;
var url = "http://"+host+"/"+sessionid+":38381/index.html?check-msg";
var timeout = 2000;

phantom.addCookie({
    'name': 'passwd',
    'value': 'fYIAv1NfRvEwJMcVPyJX',
    'domain': host,
    'path': '/'
});

page.onNavigationRequested = function(url, type, willNavigate, main) {
    console.log("[URL] URL="+url);
};

page.settings.resourceTimeout = timeout;
page.onResourceTimeout = function(e) {
    setTimeout(function(){
        console.log("[INFO] Timeout")
        phantom.exit();
    }, 1);
};

page.open(url, function(status) {
    console.log("[INFO] rendered page");
    setTimeout(function(){
        phantom.exit();
    }, 1);
});
