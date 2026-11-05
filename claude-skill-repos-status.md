---
name: repos-status
description: Check every git repository under the current folder for work that is not safely on the remote default branch - uncommitted changes, stashes, unpushed commits, branches without an upstream, branches (local or remote) with commits not merged into the default branch, and extra worktrees. Use when asked whether there are unpushed changes, unmerged branches, leftover worktrees or stashes in the repos here.
allowed-tools: Bash(find:*) Bash(git:*)
---

Run this script from the current working directory (repos up to 3 levels deep, including the folder itself if it is a repo):

```bash
find . -maxdepth 3 -name .git -type d -prune -printf '%h\n' 2>/dev/null | sort | while IFS= read -r d; do
  g() { git -C "$d" "$@"; }
  def=$(g symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null); def=${def#origin/}
  [ -z "$def" ] && for c in main master; do g show-ref -q --verify "refs/heads/$c" && { def=$c; break; }; done
  [ -z "$def" ] && def=$(g symbolic-ref --short HEAD 2>/dev/null)
  out=$(
    dirty=$(g status --porcelain | wc -l); [ "$dirty" -gt 0 ] && echo "  uncommitted: $dirty changed files"
    stash=$(g stash list | wc -l); [ "$stash" -gt 0 ] && echo "  stashes: $stash"
    g for-each-ref --format='%(refname:short)|%(upstream:short)|%(upstream:track)' refs/heads | while IFS='|' read -r b up tr; do
      if [ -z "$up" ]; then echo "  unpushed: $b has no upstream"
      elif [[ "$tr" == *ahead* ]]; then echo "  unpushed: $b $tr vs $up"; fi
    done
    g for-each-ref --format='%(refname:short)' refs/heads refs/remotes | grep -vx -e "$def" -e "origin/$def" -e origin -e '.*/HEAD' | while IFS= read -r b; do
      n=$(g rev-list --count "$def..$b" 2>/dev/null); [ "${n:-0}" -gt 0 ] || continue
      u=$(g cherry "$def" "$b" 2>/dev/null | grep -c '^+')
      echo "  unmerged: $b has $n commit(s) not in $def ($u with no equivalent patch in $def)"
    done
    g worktree list --porcelain | awk '/^worktree /{print substr($0,10)}' | tail -n +2 | while IFS= read -r w; do
      wd=$(git -C "$w" status --porcelain 2>/dev/null | wc -l)
      echo "  worktree: $w [$(git -C "$w" rev-parse --abbrev-ref HEAD 2>/dev/null)] uncommitted: $wd"
    done
  )
  if [ -n "$out" ]; then echo "== $d [HEAD: $(g rev-parse --abbrev-ref HEAD 2>/dev/null), default: $def]"; echo "$out"; else echo "== $d: clean"; fi
done
```

Then report to the user:

- Lead with the answer: which repos have something not on the remote default branch, or that everything is clean (and how many repos were checked).
- For each repo with findings, list them grouped by kind: uncommitted changes, stashes, unpushed commits / branches without upstream, unmerged branches, worktrees (with their branch and uncommitted count).
- For unmerged branches, note when all their commits have an equivalent patch in the default branch (`0 with no equivalent patch`) - those were likely squash-merged or cherry-picked and are probably safe to delete.
- Mention that ahead/behind and remote branch info comes from the last `git fetch`, so it can be stale; offer to run `git fetch --all --prune` in the repos for a fresh check.
- Do not delete, push or change anything unless asked.
