vcl 4.0;

sub vcl_recv {
  if (req.method == "PURGE") {
    return (purge);
  }

  if((req.method == "GET" || req.method == "HEAD") && (req.url ~ "^/static.*$" || req.esi_level > 0)) {

    if(req.esi_level > 0) {
      set req.http.X-ESI = "true";
    }
    set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)_[^;=]+=[^;]*", "");
  }

  if (req.http.Cookie == "") {
    unset req.http.Cookie;
  }
}

sub vcl_backend_response {
  if( beresp.http.X-ESI ) {
    set beresp.do_esi = true;
    unset beresp.http.X-ESI;
  }
}

sub vcl_deliver {
  if (resp.http.Cache-Control ~ "public") {
    set resp.http.Cache-Control = regsuball(resp.http.Cache-Control, "public", "private");
  }
}
