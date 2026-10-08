# Exergon Engineering Codex (public)

MkDocs Material site for **https://wiki.exergon.us/**, published from the **public**
`hypergolic-zero/engineering-wiki` repository with GitHub Actions.

## Publish

1. Create a **public** GitHub repo named `hypergolic-zero/engineering-wiki`.
2. Copy all files in this starter into the repository root, including the hidden `.github` directory.
3. Push the files to `main`.
4. In GitHub **Settings → Pages → Build and deployment**, select **GitHub Actions**.
5. In **Settings → Pages → Custom domain**, enter `wiki.exergon.us`, then save.
6. In Cloudflare DNS for `exergon.us`, create this record (initially DNS only):
   - Type: `CNAME`
   - Name: `wiki`
   - Target: `hypergolic-zero.github.io`
   - Proxy status: `DNS only` (gray cloud)
7. Confirm the Pages deployment succeeds, the DNS check passes, and HTTPS is enabled.

Do not add `engineering-wiki` to the CNAME target. When deploying via GitHub
Actions, no `CNAME` file is required; GitHub stores the custom domain in Pages settings.

## Local preview (Ubuntu)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve
```

Open http://127.0.0.1:8000/.

## Publish safety

- This repository, generated artifacts, and GitHub Pages site are **public**.
- Do not commit proprietary datasets, credentials, controlled technical data, or private drafts.
- Keep `engineering-notes` and `engineering-sandbox` private.
- Do not use front-end JavaScript, hidden links, or robots.txt to 'protect' a sensitive page.
- Build restricted notes separately behind properly configured Cloudflare Access
  (including protection against origin and preview URL bypasses).
