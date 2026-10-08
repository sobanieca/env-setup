---
name: check-usage
description: Show current Claude subscription usage limits (5-hour and 7-day utilization, reset times, status) from the tmux-claude-status cache. Use when asked about remaining usage, rate limits, or how much of the 5h/weekly window is left.
allowed-tools: Bash(cat:*) Bash(date:*) Read(~/.claude/tmux-rate-limit-cache.json)
---

Contents of `~/.claude/tmux-rate-limit-cache.json` (written by `claude-usage --refresh`, which runs from the Stop hook after every Claude reply):

!`cat ~/.claude/tmux-rate-limit-cache.json`

Current time (unix): !`date +%s`

Report the file contents to the user, followed by a short readable summary:

- `util_5h` / `util_7d` are fractions; show them as percentages.
- `reset_5h` / `reset_7d` and `fetched_at` are unix timestamps; show resets as local time plus time remaining, and how long ago the data was fetched.
- `status_5h`, `status_7d`, `overall`: call out anything other than `allowed`.

If the file is missing, say so and suggest running `~/.local/bin/claude-usage --refresh`.
