      -w 10 \
      -k gevent \
      --worker-connections 1000 \
      --timeout 120 \
      -b  0.0.0.0:6666 \
      --limit-request-line 0 \
      --limit-request-field_size 0 \
      --statsd-host localhost:8125 \
      "superset.app:create_app()"
