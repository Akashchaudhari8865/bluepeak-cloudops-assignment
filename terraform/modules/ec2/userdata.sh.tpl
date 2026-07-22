#!/bin/bash
set -euo pipefail

APP_NAME="${app_name}"
WEB_ROOT="/usr/share/nginx/html"

# Install and start the web server on Amazon Linux 2023.
dnf install -y nginx
systemctl enable --now nginx

cat > "$${WEB_ROOT}/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${app_name}</title>
  <style>
    :root {
      color-scheme: light;
      font-family: system-ui, sans-serif;
    }

    body {
      align-items: center;
      background: #f4f7fb;
      color: #182230;
      display: flex;
      justify-content: center;
      margin: 0;
      min-height: 100vh;
    }

    main {
      background: #ffffff;
      border: 1px solid #dbe3ee;
      border-radius: 8px;
      box-shadow: 0 12px 30px rgba(24, 34, 48, 0.08);
      padding: 2rem;
      text-align: center;
      width: min(24rem, calc(100% - 3rem));
    }

    h1 {
      font-size: 1.5rem;
      margin: 0 0 1.5rem;
    }

    .controls {
      align-items: center;
      display: flex;
      gap: 1rem;
      justify-content: center;
    }

    button {
      background: #1769aa;
      border: 0;
      border-radius: 6px;
      color: #ffffff;
      cursor: pointer;
      font-size: 1.5rem;
      height: 3rem;
      width: 3rem;
    }

    button:hover {
      background: #125586;
    }

    #counting {
      font-size: 2rem;
      min-width: 3rem;
    }
  </style>
</head>
<body>
  <main>
    <h1>${app_name}</h1>
    <div class="controls">
      <button type="button" aria-label="Decrease count" onclick="decrement()">-</button>
      <h2 id="counting">0</h2>
      <button type="button" aria-label="Increase count" onclick="increment()">+</button>
    </div>
  </main>
  <script>
    let count = 0;
    const counter = document.getElementById('counting');

    function render() {
      counter.textContent = count;
    }

    function increment() {
      count += 1;
      render();
    }

    function decrement() {
      count -= 1;
      render();
    }
  </script>
</body>
</html>
EOF

chown -R nginx:nginx "$${WEB_ROOT}"
chmod -R 755 "$${WEB_ROOT}"
