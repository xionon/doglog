vcl 4.0;

sub vcl_recv {
  if((req.method == "GET" || req.method == "HEAD") && req.url ~ "^/static.*$") {
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)_[^;=]+=[^;]*", "");
  }

  if (req.http.Cookie == "") {
    unset req.http.Cookie;
  }
}

sub vcl_backend_response {
  if (beresp.http.Cache-Control ~ "public") {
    unset beresp.http.Set-Cookie;
  }
}

sub vcl_deliver {
  if (resp.http.Cache-Control ~ "public") {
    set resp.http.Cache-Control = regsuball(resp.http.Cache-Control, "public", "private");
  }
}
