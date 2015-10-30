vcl 4.0;
include "main.vcl";

backend default {
    .host = "127.0.0.1";
    .port = "3000";
}
