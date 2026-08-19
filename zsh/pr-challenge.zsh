# Source this file from ~/.zshrc, then run:
#   pr-challenge https://github.com/OWNER/REPO/pull/123
# On macOS, `pr-challenge` with no argument reads a copied PR URL from pbpaste.

pr-challenge() {
  emulate -L zsh
  setopt pipefail

  local input="${1:-}"
  if [[ -z "$input" ]] && (($ + commands[pbpaste])); then
    input="$(pbpaste)"
  fi

  if [[ ! "$input" =~ '^https://github\.com/([^/]+)/([^/]+)/pull/([0-9]+)(/.*)?$' ]]; then
    print -u2 "usage: pr-challenge https://github.com/OWNER/REPO/pull/NUMBER"
    return 2
  fi

  local owner="${match[1]}"
  local repo="${match[2]}"
  local number="${match[3]}"
  local slug="$owner/$repo"
  local challenge_root="${PR_CHALLENGE_ROOT:-${HOME}/src/pr-challenges}"
  local repo_dir="$challenge_root/$owner/$repo"
  local branch="challenge/pr-$number"

  local dependency
  for dependency in git gh; do
    if ((!$ + commands[$dependency])); then
      print -u2 "pr-challenge: '$dependency' is required"
      return 127
    fi
  done

  # Destructive cleanup is allowed only inside the dedicated challenge root.
  case "$repo_dir" in
    "$challenge_root"/*) ;;
    *)
      print -u2 "pr-challenge: unsafe repository path: $repo_dir"
      return 1
      ;;
  esac

  if [[ ! -d "$repo_dir/.git" ]]; then
    if [[ -e "$repo_dir" ]]; then
      print -u2 "pr-challenge: path exists but is not a Git repository: $repo_dir"
      return 1
    fi
    mkdir -p "${repo_dir:h}" || return
    gh repo clone "$slug" "$repo_dir" || return
  fi

  cd "$repo_dir" || return

  local actual_slug
  actual_slug="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)" || return
  if [[ "${actual_slug:l}" != "${slug:l}" ]]; then
    print -u2 "pr-challenge: repository mismatch: expected $slug, found $actual_slug"
    return 1
  fi

  local meta merged merge_sha head_sha base_sha commit_count title
  meta="$(gh api "repos/$slug/pulls/$number" \
    --jq '[.merged, .merge_commit_sha, .head.sha, .base.sha, .commits, .title] | map(if . == null then "" else tostring end) | join("\u001f")')" || return
  IFS=$'\x1f' read -r merged merge_sha head_sha base_sha commit_count title <<<"$meta"

  # Throw away every previous attempt, including ignored build products.
  git reset --hard >/dev/null || return
  git clean -ffdx >/dev/null || return

  git fetch --no-tags --force origin \
    "+refs/pull/$number/head:refs/pr-challenge/$number/head" || return

  local pr_head="refs/pr-challenge/$number/head"
  local start_sha solution_sha merge_method parent_count original_fingerprint merged_fingerprint

  if [[ "$merged" == "true" ]]; then
    if ! git cat-file -e "$merge_sha^{commit}" 2>/dev/null; then
      git fetch --no-tags origin "$merge_sha" || return
    fi

    parent_count=$(($(git rev-list --parents -n 1 "$merge_sha" | wc -w) - 1))
    if ((parent_count >= 2)); then
      start_sha="$merge_sha^1"
      merge_method="merge commit"
    elif ((parent_count == 1 && commit_count <= 1)); then
      # Squash and rebase have the same parent when the PR contains one commit.
      start_sha="$merge_sha^"
      merge_method="squash/rebase"
    elif ((parent_count == 1)); then
      # Rebase preserves each commit's author date and subject. Squash produces
      # one new commit, so the preceding commits will not match the PR series.
      original_fingerprint="$(git log --first-parent -n "$commit_count" --reverse \
        --format='%at%x1f%s' "$pr_head")"
      merged_fingerprint="$(git log --first-parent -n "$commit_count" --reverse \
        --format='%at%x1f%s' "$merge_sha")"

      if [[ "$original_fingerprint" == "$merged_fingerprint" ]]; then
        start_sha="$merge_sha~$commit_count"
        merge_method="rebase"
      else
        start_sha="$merge_sha^"
        merge_method="squash"
      fi
    else
      print -u2 "pr-challenge: merged commit has no parent"
      return 1
    fi
    solution_sha="$merge_sha"
  else
    if ! git cat-file -e "$base_sha^{commit}" 2>/dev/null; then
      git fetch --no-tags origin "$base_sha" || return
    fi
    start_sha="$(git merge-base "$base_sha" "$pr_head")" || return
    solution_sha="$pr_head"
    merge_method="not merged"
  fi

  git update-ref "refs/pr-challenge/$number/solution" "$solution_sha" || return
  git switch --detach "$start_sha" >/dev/null || return
  git branch -f "$branch" "$start_sha" >/dev/null || return
  git switch "$branch" >/dev/null || return
  git clean -ffdx >/dev/null || return

  if [[ -f .gitmodules ]]; then
    git submodule sync --recursive || return
    git submodule update --init --recursive --force || return
    git submodule foreach --recursive 'git reset --hard && git clean -ffdx' || return
  fi

  print
  print "PR #$number: $title"
  print "Start:    ${start_sha[1,12]} ($merge_method)"
  print "Solution: ${solution_sha[1,12]}"
  print "Branch:   $branch"
  print "Path:     $repo_dir"
  print
  print "答え合わせ: git diff HEAD refs/pr-challenge/$number/solution"
}
