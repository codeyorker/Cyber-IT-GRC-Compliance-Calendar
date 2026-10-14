# GRC Compliance Calendar: simple deploy kit

## One-time server setup (Ubuntu VM)
1. Install Docker + compose plugin: `curl -fsSL https://get.docker.com | sh`
2. `git clone <your-repo> /opt/grc && cd /opt/grc`
3. `cp .env.example .env` and fill the values
4. `chmod +x deploy.sh backup.sh && ./deploy.sh`
5. Create the first admin: `docker compose exec web python manage.py createsuperuser`
6. Add backup cron: `0 1 * * * /opt/grc/backup.sh`

## Every update
- Manual: `cd /opt/grc && ./deploy.sh`
- Automatic: push to `main`; GitHub Actions runs deploy.sh on the server.
  Add repo secrets: SERVER_HOST, SERVER_USER, SSH_KEY (private key of a deploy user).
  If the server is inside the company network, GitHub cannot reach it:
  use a self-hosted runner, or just run ./deploy.sh manually.
  Next
