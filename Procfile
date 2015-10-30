web: rails s --port $PORT
varnishd: varnishd -F -p vcl_dir=$(pwd)/config -f config/varnish.dev.vcl -a 0.0.0.0:8000
