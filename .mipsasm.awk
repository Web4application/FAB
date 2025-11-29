server {
    server_name example.com;

    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    # Additional SSL settings...

    # Frontend application
    location / {
        proxy_pass <http://localhost:3000>;
        # Additional proxy settings...
    }

    # Backend API
    location /api/ {
        proxy_pass <http://localhost:8081/api/>;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}
