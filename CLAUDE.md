# engineering-wiki

Source of the public Exergon Engineering Codex, a MkDocs Material site published at `wiki.exergon.us` with GitHub Pages. This repository, its history, and the site are all public.

## Hard rules

1. **Everything here is published.** A merge to `main` puts the content on the public internet, and the repository itself is already public, including every commit and pull request. Write nothing that is not meant for anyone to read.
2. **Public-safe content only.** No proprietary, confidential, or controlled technical information; nothing derived from an employer's or a client's work; no credentials. If the origin or sensitivity of something is unclear, stop and ask before writing it.
3. **No personal details.** Do not add a legal name, employer, location, email address, or anything else that identifies the owner beyond what the site already shows.
4. **Original or properly sourced.** Write original text. Cite the source of every equation, constant, figure, and reference value. Do not paste text or images from other sites. Ask before adding any image or other binary file.
5. **Stay in this repository.** Do not read, write, or run commands in any other directory, and never copy material into this repository from elsewhere on the machine.
6. **Never commit to `main`.** Direct pushes are rejected by the server. All work goes through a topic branch and a pull request.
7. **Never bypass checks.** No `git commit --no-verify`, no `git push --force`, no `git reset --hard`, no `git clean -fd`. If the build fails, fix the cause.
8. **Ask before** editing anything under `.github/` or `.claude/`, or changing `requirements.txt`.

## Commands

```bash
source .venv/bin/activate                # required in every new shell
python -m mkdocs build --strict          # the check CI requires
python -m mkdocs serve                   # local preview; leave this to the owner
```

A change is done only when `python -m mkdocs build --strict` passes with no `WARNING` lines.

## Layout

```text
mkdocs.yml               site configuration and the nav menu
docs/index.md            home page
docs/<section>/index.md  one folder per section: aerospace, propulsion, avionics,
                         embedded-systems, computational-physics, engineering-methods
```

## Writing conventions

- **Every new page needs an entry under `nav:` in `mkdocs.yml`.**
- Link between pages with relative paths to the `.md` file.
- Write for a technical reader who is new to the topic: define terms, state assumptions and limits, give units (SI) for every quantity.
- Separate what is established from what is the author's own analysis, and say which is which.
- Commands and code in fenced blocks with a language tag.
- Admonitions use `!!! note "Title"` with the body indented four spaces.

## Git and pull requests

```bash
git switch main && git pull --ff-only origin main
git switch -c docs/<short-topic>
# edit, then run the strict build
git add <specific files>             # never `git add -A` without reading `git status` first
git commit -m "docs: <imperative summary>"
git push -u origin HEAD

R=hypergolic-zero/engineering-wiki
gh pr create -R "$R" --base main --head "$(git branch --show-current)" --title "docs: <summary>" --body "<what, why, how validated>"
git rev-parse HEAD
gh run list -R "$R" --branch "$(git branch --show-current)" --event pull_request --limit 3 --json headSha,status,conclusion
```

- Types for branches and commits: `docs`, `fix`, `chore`, `ci`, `build`.
- One purpose per branch.
- Commit messages, pull request titles, and pull request descriptions are public too. Keep them factual and free of private context.
- **Stop after opening the PR and report its URL.** The owner reads the diff and merges. Do not run `gh pr merge` unless asked in that session.
- The required check is `Validate and build MkDocs`. Read its result from the `gh run list` command above: find the entry whose `headSha` equals the `git rev-parse HEAD` output, and repeat the command every twenty seconds until its `status` is `completed`. The `conclusion` must be `success`.
- A `403` from `gh` is a boundary, not a bug: report it and stop.
- Never change the remote URL.

## GitHub Actions

Workflows are refused unless every `uses:` line is a full 40-character commit SHA with a version comment. Do not replace a SHA with a tag.

## Reporting

End each task with: what changed, whether the strict build passed, the source of every factual claim added, and anything not verified.
