#!/usr/bin/env python3
"""Leveling Up Tutor — global progress, XP, and skill engine.

Progress is stored outside the plugin source tree so it is global across
projects:

  $GROK_PLUGIN_DATA/progress.json   (preferred, set by plugin hooks)
  ~/.grok/plugin-data/leveling-up-tutor/progress.json  (fallback)
"""

from __future__ import annotations

import argparse
import json
import math
import os
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

# --- Level curve (logarithmic, no cap) ---------------------------------------
# level = floor(SCALE * ln(1 + total_xp / BASE)) + 1
# Inverse: xp_for_level(L) = BASE * (exp((L-1)/SCALE) - 1)
#
# Rough calibration (main level):
#   L1  — start
#   L5  — basics stick
#   L10 — small programs with guidance
#   L20 — independent feature work (strong junior / early mid)
#   L35 — solid mid/senior path (design + review quality)
#   L50 — staff-like: systems, mentorship depth
#   L70 — can ship substantial OSS alone
#   L100 — world-class rare (top ~hundreds globally across tracks)
SCALE = 14.0
BASE = 120.0
SKILL_SCALE = 10.0
SKILL_BASE = 40.0

SCHEMA_VERSION = 1

# Canonical skill catalog (dynamic skills may still be added at runtime)
SKILL_CATALOG: dict[str, dict[str, str]] = {
    # Languages (extend freely)
    "go": {"track": "language", "label": "Go"},
    "python": {"track": "language", "label": "Python"},
    "typescript": {"track": "language", "label": "TypeScript"},
    "javascript": {"track": "language", "label": "JavaScript"},
    "rust": {"track": "language", "label": "Rust"},
    "java": {"track": "language", "label": "Java"},
    "c": {"track": "language", "label": "C"},
    "cpp": {"track": "language", "label": "C++"},
    "sql": {"track": "language", "label": "SQL"},
    "bash": {"track": "language", "label": "Bash/Shell"},
    # Core engineering
    "debugging": {"track": "engineering", "label": "Debugging"},
    "testing": {"track": "engineering", "label": "Testing / TDD"},
    "git": {"track": "engineering", "label": "Git / Collaboration"},
    "ci-cd": {"track": "engineering", "label": "CI/CD"},
    "security": {"track": "engineering", "label": "Security"},
    "performance": {"track": "engineering", "label": "Performance"},
    "tooling": {"track": "engineering", "label": "Tooling / DX"},
    # Design & architecture
    "system-design": {"track": "design", "label": "System Design"},
    "api-design": {"track": "design", "label": "API Design"},
    "data-modeling": {"track": "design", "label": "Data Modeling"},
    "architecture": {"track": "design", "label": "Architecture"},
    "distributed-systems": {"track": "design", "label": "Distributed Systems"},
    # Reading & communication
    "code-reading": {"track": "reading", "label": "Code Reading"},
    "pr-review": {"track": "reading", "label": "PR Review"},
    "docs-writing": {"track": "communication", "label": "Technical Writing"},
    "rfc-communication": {"track": "communication", "label": "RFCs / Design Docs"},
    # ML engineering
    "ml-engineering": {"track": "ml-eng", "label": "ML Engineering"},
    "mlops": {"track": "ml-eng", "label": "MLOps"},
    "data-engineering": {"track": "ml-eng", "label": "Data Engineering"},
    "feature-engineering": {"track": "ml-eng", "label": "Feature Engineering"},
    "model-serving": {"track": "ml-eng", "label": "Model Serving"},
    "evaluation-metrics": {"track": "ml-eng", "label": "Evaluation & Metrics"},
    # ML research
    "research-method": {"track": "ml-research", "label": "Research Method"},
    "paper-reading": {"track": "ml-research", "label": "Paper Reading"},
    "experiment-design": {"track": "ml-research", "label": "Experiment Design"},
    "math-foundations": {"track": "ml-research", "label": "Math Foundations"},
    "scientific-writing": {"track": "ml-research", "label": "Scientific Writing"},
    "ablation-analysis": {"track": "ml-research", "label": "Ablation / Analysis"},
}

TRACK_ORDER = [
    "language",
    "engineering",
    "design",
    "reading",
    "communication",
    "ml-eng",
    "ml-research",
    "other",
]

TRACK_LABELS = {
    "language": "Languages",
    "engineering": "Engineering",
    "design": "Design & Architecture",
    "reading": "Reading & Review",
    "communication": "Communication",
    "ml-eng": "ML Engineering",
    "ml-research": "ML Research",
    "other": "Other",
}


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def plugin_root() -> Path:
    env = os.environ.get("GROK_PLUGIN_ROOT") or os.environ.get("CLAUDE_PLUGIN_ROOT")
    if env:
        return Path(env).expanduser().resolve()
    return Path(__file__).resolve().parent.parent


def data_dir() -> Path:
    env = os.environ.get("GROK_PLUGIN_DATA") or os.environ.get("CLAUDE_PLUGIN_DATA")
    if env:
        return Path(env).expanduser().resolve()
    # Prefer ~/.grok/plugin-data when ~/.grok is the live config tree
    home_grok = Path.home() / ".grok" / "plugin-data" / "leveling-up-tutor"
    return home_grok


def progress_path() -> Path:
    return data_dir() / "progress.json"


def history_path() -> Path:
    return data_dir() / "history.jsonl"


def level_from_xp(xp: float, scale: float = SCALE, base: float = BASE) -> int:
    xp = max(0.0, float(xp))
    return int(math.floor(scale * math.log1p(xp / base))) + 1


def xp_for_level(level: int, scale: float = SCALE, base: float = BASE) -> float:
    level = max(1, int(level))
    if level <= 1:
        return 0.0
    return base * (math.exp((level - 1) / scale) - 1.0)


def xp_to_next(xp: float, scale: float = SCALE, base: float = BASE) -> tuple[int, float, float]:
    level = level_from_xp(xp, scale, base)
    cur = xp_for_level(level, scale, base)
    nxt = xp_for_level(level + 1, scale, base)
    into = max(0.0, xp - cur)
    need = max(0.0, nxt - xp)
    span = max(1e-9, nxt - cur)
    return level, need, into / span


def default_progress() -> dict[str, Any]:
    return {
        "schema_version": SCHEMA_VERSION,
        "created_at": utc_now(),
        "updated_at": utc_now(),
        "total_xp": 0.0,
        "skills": {},
        "stats": {
            "sessions": 0,
            "assessments": 0,
            "code_lines_reviewed": 0,
            "code_lines_authored_by_learner": 0,
            "design_sessions": 0,
            "paper_sessions": 0,
            "quests_completed": 0,
        },
        "quests": {
            "active": [],
            "completed": [],
        },
        "journal": [],
        "milestones_hit": [],
        "last_session": None,
    }


def load_progress() -> dict[str, Any]:
    path = progress_path()
    if not path.exists():
        return default_progress()
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return default_progress()
    if not isinstance(data, dict):
        return default_progress()
    # Soft-migrate missing keys
    base = default_progress()
    for k, v in base.items():
        if k not in data:
            data[k] = v
    if "stats" in base:
        for sk, sv in base["stats"].items():
            data.setdefault("stats", {}).setdefault(sk, sv)
    data.setdefault("skills", {})
    return data


def atomic_write_json(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=".progress-", suffix=".json", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        os.replace(tmp, path)
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass
        raise


def append_history(event: dict[str, Any]) -> None:
    path = history_path()
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(event, ensure_ascii=False) + "\n")


def skill_meta(skill_id: str) -> dict[str, str]:
    sid = skill_id.strip().lower().replace(" ", "-").replace("_", "-")
    if sid in SKILL_CATALOG:
        return {"id": sid, **SKILL_CATALOG[sid]}
    label = sid.replace("-", " ").title()
    return {"id": sid, "track": "other", "label": label}


def ensure_skill(progress: dict[str, Any], skill_id: str) -> dict[str, Any]:
    meta = skill_meta(skill_id)
    sid = meta["id"]
    skills = progress.setdefault("skills", {})
    if sid not in skills:
        skills[sid] = {
            "xp": 0.0,
            "label": meta["label"],
            "track": meta["track"],
            "updated_at": utc_now(),
        }
    else:
        skills[sid].setdefault("label", meta["label"])
        skills[sid].setdefault("track", meta["track"])
    return skills[sid]


def milestone_for_level(level: int) -> str | None:
    table = {
        5: "Fundamentals stick — syntax and small programs feel natural",
        10: "Guided builder — can complete small projects with Socratic help",
        15: "Independent snippets — writes correct code without full scaffolding",
        20: "Feature owner — ships non-trivial features end-to-end",
        25: "Design-aware — considers APIs, edges, and failure modes before coding",
        30: "Reviewer mindset — reads code critically and suggests better shapes",
        35: "Mid/senior path — owns modules, tests, and iterative design",
        40: "System thinker — multi-component designs with trade-offs",
        45: "Cross-domain — comfortable spanning backend, data, and tooling",
        50: "Staff-depth — architecture, mentorship quality, long-horizon plans",
        60: "OSS contributor — high-quality PRs to non-trivial open source",
        70: "Solo OSS builder — can create and maintain substantial projects alone",
        80: "Field-shaping engineer — reliable judgment under ambiguity",
        90: "Research+eng bridge — ships ideas others only write papers about",
        100: "World-class rare — top-hundred territory across engineering/ML",
    }
    return table.get(level)


def apply_milestones(progress: dict[str, Any], old_level: int, new_level: int) -> list[str]:
    hit: list[str] = []
    if new_level <= old_level:
        return hit
    seen = set(progress.get("milestones_hit") or [])
    for lvl in range(old_level + 1, new_level + 1):
        msg = milestone_for_level(lvl)
        if msg and lvl not in seen:
            progress.setdefault("milestones_hit", []).append(lvl)
            hit.append(f"L{lvl}: {msg}")
    return hit


def award(
    amount: float,
    skills: list[tuple[str, float]] | None = None,
    reason: str = "",
    quality: float = 0.7,
    volume: int = 0,
    categories: list[str] | None = None,
    journal: str | None = None,
    source: str = "manual",
    session_id: str | None = None,
) -> dict[str, Any]:
    """Award main XP and optional per-skill XP.

    quality: 0.0–1.0 multiplier signal (already applied by caller or used for notes)
    """
    progress = load_progress()
    old_xp = float(progress.get("total_xp") or 0)
    old_level = level_from_xp(old_xp)

    amount = max(0.0, float(amount))
    amount = round(amount, 2)
    _ = quality  # reserved for history metadata; scorer applies quality to amount

    progress["total_xp"] = round(old_xp + amount, 2)
    new_level = level_from_xp(progress["total_xp"])
    milestones = apply_milestones(progress, old_level, new_level)

    skill_deltas: dict[str, float] = {}
    for sid, sxp in skills or []:
        if sxp <= 0:
            continue
        entry = ensure_skill(progress, sid)
        before = float(entry.get("xp") or 0)
        entry["xp"] = round(before + float(sxp), 2)
        entry["updated_at"] = utc_now()
        skill_deltas[skill_meta(sid)["id"]] = float(sxp)

    stats = progress.setdefault("stats", {})
    stats["assessments"] = int(stats.get("assessments") or 0) + 1
    if volume > 0:
        stats["code_lines_authored_by_learner"] = int(
            stats.get("code_lines_authored_by_learner") or 0
        ) + int(volume)

    cats = categories or []
    if "design" in cats:
        stats["design_sessions"] = int(stats.get("design_sessions") or 0) + 1
    if "paper" in cats or "research" in cats:
        stats["paper_sessions"] = int(stats.get("paper_sessions") or 0) + 1
    if "reading" in cats:
        stats["code_lines_reviewed"] = int(stats.get("code_lines_reviewed") or 0) + max(
            volume, 0
        )

    progress["updated_at"] = utc_now()
    progress["last_session"] = {
        "at": utc_now(),
        "xp_gained": amount,
        "reason": reason,
        "source": source,
        "session_id": session_id,
        "skills": skill_deltas,
    }

    if journal:
        progress.setdefault("journal", []).append(
            {"at": utc_now(), "text": journal[:2000], "xp": amount}
        )
        # Keep journal bounded
        progress["journal"] = progress["journal"][-100:]

    atomic_write_json(progress_path(), progress)
    event = {
        "at": utc_now(),
        "type": "award",
        "xp": amount,
        "total_xp": progress["total_xp"],
        "level": new_level,
        "old_level": old_level,
        "skills": skill_deltas,
        "reason": reason,
        "source": source,
        "session_id": session_id,
        "milestones": milestones,
    }
    append_history(event)
    return {
        "ok": True,
        "xp_gained": amount,
        "total_xp": progress["total_xp"],
        "level": new_level,
        "old_level": old_level,
        "leveled_up": new_level > old_level,
        "milestones": milestones,
        "skills": {
            sid: {
                "xp": progress["skills"][sid]["xp"],
                "level": level_from_xp(
                    progress["skills"][sid]["xp"], SKILL_SCALE, SKILL_BASE
                ),
                "label": progress["skills"][sid].get("label", sid),
            }
            for sid in skill_deltas
        },
        "path": str(progress_path()),
    }


def compute_session_xp(
    *,
    learner_code_lines: int = 0,
    quality: float = 0.6,
    depth: float = 0.5,
    design: float = 0.0,
    reading: float = 0.0,
    debugging: float = 0.0,
    testing: float = 0.0,
    ml_eng: float = 0.0,
    research: float = 0.0,
    independence: float = 0.5,
    explanation: float = 0.4,
) -> tuple[float, list[tuple[str, float]], list[str], str]:
    """Heuristic XP from scored dimensions (0–1 each, except lines).

    Returns (main_xp, skill_pairs, categories, reason).
    """
    q = max(0.0, min(1.0, quality))
    d = max(0.0, min(1.0, depth))
    ind = max(0.0, min(1.0, independence))
    exp = max(0.0, min(1.0, explanation))

    # Volume has diminishing returns (log)
    vol = math.log1p(max(0, learner_code_lines)) * 4.0
    base = 8.0 + vol
    base *= 0.5 + 0.5 * q
    base *= 0.6 + 0.4 * d
    base *= 0.7 + 0.3 * ind
    base *= 0.8 + 0.2 * exp

    # Domain bonuses
    base += 12.0 * max(0.0, min(1.0, design))
    base += 10.0 * max(0.0, min(1.0, reading))
    base += 10.0 * max(0.0, min(1.0, debugging))
    base += 10.0 * max(0.0, min(1.0, testing))
    base += 14.0 * max(0.0, min(1.0, ml_eng))
    base += 16.0 * max(0.0, min(1.0, research))

    # Cap per assessment to keep curve meaningful
    main_xp = round(min(220.0, base), 2)

    skills: list[tuple[str, float]] = []
    cats: list[str] = []
    if learner_code_lines > 0:
        skills.append(("debugging", main_xp * 0.15 * q))
    if design > 0.2:
        skills.append(("system-design", main_xp * 0.35 * design))
        skills.append(("architecture", main_xp * 0.2 * design))
        cats.append("design")
    if reading > 0.2:
        skills.append(("code-reading", main_xp * 0.4 * reading))
        skills.append(("pr-review", main_xp * 0.2 * reading))
        cats.append("reading")
    if debugging > 0.2:
        skills.append(("debugging", main_xp * 0.4 * debugging))
    if testing > 0.2:
        skills.append(("testing", main_xp * 0.45 * testing))
    if ml_eng > 0.2:
        skills.append(("ml-engineering", main_xp * 0.4 * ml_eng))
        skills.append(("evaluation-metrics", main_xp * 0.2 * ml_eng))
        cats.append("ml")
    if research > 0.2:
        skills.append(("research-method", main_xp * 0.35 * research))
        skills.append(("paper-reading", main_xp * 0.25 * research))
        skills.append(("experiment-design", main_xp * 0.25 * research))
        cats.append("research")
    if explanation > 0.5:
        skills.append(("docs-writing", main_xp * 0.15 * explanation))

    # Collapse duplicate skill keys
    merged: dict[str, float] = {}
    for sid, sxp in skills:
        merged[sid] = merged.get(sid, 0.0) + sxp
    skill_pairs = [(k, round(v, 2)) for k, v in merged.items() if v > 0.01]

    reason = (
        f"session assessment: lines={learner_code_lines}, quality={q:.2f}, "
        f"depth={d:.2f}, design={design:.2f}, reading={reading:.2f}, "
        f"debug={debugging:.2f}, test={testing:.2f}, ml={ml_eng:.2f}, "
        f"research={research:.2f}"
    )
    return main_xp, skill_pairs, cats, reason


def format_progress(progress: dict[str, Any] | None = None, *, pretty: bool = True) -> str:
    p = progress if progress is not None else load_progress()
    total = float(p.get("total_xp") or 0)
    level, need, frac = xp_to_next(total)
    bar_w = 20
    filled = int(round(frac * bar_w))
    bar = "█" * filled + "░" * (bar_w - filled)

    lines: list[str] = []
    lines.append("╭──────────────────────────────────────────────╮")
    lines.append("│  LEVELING UP TUTOR — Progress                │")
    lines.append("╰──────────────────────────────────────────────╯")
    lines.append(f"  Level  {level}   (uncapped · logarithmic)")
    lines.append(f"  XP     {total:.1f}   next in {need:.1f}  [{bar}] {frac*100:.0f}%")
    lines.append("")

    # Milestone near
    nxt_ms = None
    for ms in (5, 10, 15, 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 100):
        if ms > level:
            nxt_ms = ms
            break
    if nxt_ms:
        msg = milestone_for_level(nxt_ms) or ""
        lines.append(f"  Next milestone L{nxt_ms}: {msg}")
        lines.append("")

    skills = p.get("skills") or {}
    if skills:
        # Group by track
        by_track: dict[str, list[tuple[str, dict[str, Any]]]] = {}
        for sid, entry in skills.items():
            track = entry.get("track") or skill_meta(sid)["track"]
            by_track.setdefault(track, []).append((sid, entry))

        lines.append("  Skills")
        for track in TRACK_ORDER:
            items = by_track.pop(track, [])
            if not items:
                continue
            items.sort(
                key=lambda x: float(x[1].get("xp") or 0),
                reverse=True,
            )
            lines.append(f"  · {TRACK_LABELS.get(track, track)}")
            for sid, entry in items:
                sxp = float(entry.get("xp") or 0)
                slvl = level_from_xp(sxp, SKILL_SCALE, SKILL_BASE)
                label = entry.get("label") or skill_meta(sid)["label"]
                lines.append(f"      {label:24} Lv{slvl:<3}  {sxp:.1f} XP")
        # Remaining tracks
        for track, items in sorted(by_track.items()):
            items.sort(key=lambda x: float(x[1].get("xp") or 0), reverse=True)
            lines.append(f"  · {TRACK_LABELS.get(track, track)}")
            for sid, entry in items:
                sxp = float(entry.get("xp") or 0)
                slvl = level_from_xp(sxp, SKILL_SCALE, SKILL_BASE)
                label = entry.get("label") or skill_meta(sid)["label"]
                lines.append(f"      {label:24} Lv{slvl:<3}  {sxp:.1f} XP")
    else:
        lines.append("  Skills: (none yet — complete a tutoring session)")

    stats = p.get("stats") or {}
    lines.append("")
    lines.append(
        "  Stats  "
        f"sessions={stats.get('sessions', 0)}  "
        f"assessments={stats.get('assessments', 0)}  "
        f"learner_lines={stats.get('code_lines_authored_by_learner', 0)}"
    )

    active = (p.get("quests") or {}).get("active") or []
    if active:
        lines.append("")
        lines.append("  Active quests")
        for q in active[:5]:
            if isinstance(q, dict):
                lines.append(f"      • {q.get('title', q)}")
            else:
                lines.append(f"      • {q}")

    last = p.get("last_session")
    if last:
        lines.append("")
        lines.append(
            f"  Last   +{last.get('xp_gained', 0)} XP — {last.get('reason', '')[:80]}"
        )

    lines.append("")
    lines.append(f"  Data   {progress_path()}")
    return "\n".join(lines) if pretty else json.dumps(p, ensure_ascii=False, indent=2)


def context_blob(progress: dict[str, Any] | None = None) -> str:
    """Compact context for SessionStart / agent bootstrap."""
    p = progress if progress is not None else load_progress()
    total = float(p.get("total_xp") or 0)
    level, need, frac = xp_to_next(total)
    skills = p.get("skills") or {}
    top = sorted(
        skills.items(),
        key=lambda x: float(x[1].get("xp") or 0),
        reverse=True,
    )[:8]
    skill_bits = []
    for sid, entry in top:
        sxp = float(entry.get("xp") or 0)
        slvl = level_from_xp(sxp, SKILL_SCALE, SKILL_BASE)
        label = entry.get("label") or skill_meta(sid)["label"]
        skill_bits.append(f"{label} Lv{slvl}")
    skill_txt = ", ".join(skill_bits) if skill_bits else "none yet"
    weak = sorted(
        skills.items(),
        key=lambda x: float(x[1].get("xp") or 0),
    )[:3]
    focus = []
    for sid, entry in weak:
        if float(entry.get("xp") or 0) < xp_for_level(3, SKILL_SCALE, SKILL_BASE):
            focus.append(entry.get("label") or sid)
    # If few skills, suggest core tracks
    if not focus:
        focus = ["code-reading", "testing", "system-design"]

    active = (p.get("quests") or {}).get("active") or []
    quest_txt = ""
    if active:
        titles = []
        for q in active[:3]:
            titles.append(q.get("title", str(q)) if isinstance(q, dict) else str(q))
        quest_txt = " Active quests: " + "; ".join(titles) + "."

    return (
        f"<leveling-up-tutor-progress>\n"
        f"Learner global progress (do NOT write code for them; teach, review, Socratic guide).\n"
        f"Main Level: {level} | Total XP: {total:.1f} | To next: {need:.1f} ({frac*100:.0f}%)\n"
        f"Top skills: {skill_txt}\n"
        f"Suggested focus: {', '.join(focus)}.{quest_txt}\n"
        f"After meaningful learning, award XP via: "
        f"python3 \"$GROK_PLUGIN_ROOT/scripts/progress.py\" award --amount N "
        f"--skill go:12 --skill debugging:8 --reason '...'\n"
        f"Show card: python3 \"$GROK_PLUGIN_ROOT/scripts/progress.py\" show\n"
        f"Progress file: {progress_path()}\n"
        f"</leveling-up-tutor-progress>"
    )


def bump_session(session_id: str | None = None) -> dict[str, Any]:
    p = load_progress()
    p.setdefault("stats", {})
    p["stats"]["sessions"] = int(p["stats"].get("sessions") or 0) + 1
    p["updated_at"] = utc_now()
    if session_id:
        p["last_session_id"] = session_id
    atomic_write_json(progress_path(), p)
    return {"ok": True, "sessions": p["stats"]["sessions"]}


def add_quest(title: str, detail: str = "", skills: list[str] | None = None) -> dict[str, Any]:
    p = load_progress()
    quest = {
        "id": f"q-{int(datetime.now(timezone.utc).timestamp())}",
        "title": title,
        "detail": detail,
        "skills": skills or [],
        "created_at": utc_now(),
    }
    p.setdefault("quests", {}).setdefault("active", []).append(quest)
    p["updated_at"] = utc_now()
    atomic_write_json(progress_path(), p)
    return {"ok": True, "quest": quest}


def complete_quest(quest_id: str, xp: float = 40.0) -> dict[str, Any]:
    p = load_progress()
    active = p.setdefault("quests", {}).setdefault("active", [])
    completed = p.setdefault("quests", {}).setdefault("completed", [])
    found = None
    rest = []
    for q in active:
        if isinstance(q, dict) and q.get("id") == quest_id:
            found = q
        else:
            rest.append(q)
    if not found:
        return {"ok": False, "error": f"quest not found: {quest_id}"}
    found["completed_at"] = utc_now()
    completed.append(found)
    p["quests"]["active"] = rest
    p.setdefault("stats", {})
    p["stats"]["quests_completed"] = int(p["stats"].get("quests_completed") or 0) + 1
    atomic_write_json(progress_path(), p)
    skill_pairs = [(s, xp * 0.25) for s in (found.get("skills") or [])]
    result = award(
        amount=xp,
        skills=skill_pairs,
        reason=f"quest completed: {found.get('title')}",
        source="quest",
    )
    result["quest"] = found
    return result


def parse_skill_arg(raw: str) -> tuple[str, float]:
    # formats: go:12  or go=12
    if ":" in raw:
        sid, amt = raw.split(":", 1)
    elif "=" in raw:
        sid, amt = raw.split("=", 1)
    else:
        raise argparse.ArgumentTypeError(f"expected skill:xp, got {raw!r}")
    return sid.strip(), float(amt)


def cmd_show(args: argparse.Namespace) -> int:
    if args.context:
        print(context_blob())
        return 0
    if args.json:
        print(json.dumps(load_progress(), ensure_ascii=False, indent=2))
        return 0
    print(format_progress(pretty=True))
    return 0


def cmd_award(args: argparse.Namespace) -> int:
    skills = list(args.skill or [])
    if args.compute:
        main, skill_pairs, cats, reason = compute_session_xp(
            learner_code_lines=args.lines,
            quality=args.quality,
            depth=args.depth,
            design=args.design,
            reading=args.reading,
            debugging=args.debugging,
            testing=args.testing,
            ml_eng=args.ml_eng,
            research=args.research,
            independence=args.independence,
            explanation=args.explanation,
        )
        if args.amount is not None:
            main = args.amount
        if skills:
            skill_pairs = skills
        if args.reason:
            reason = args.reason
        result = award(
            amount=main,
            skills=skill_pairs,
            reason=reason,
            quality=0.7,
            volume=args.lines,
            categories=cats,
            journal=args.journal,
            source=args.source,
            session_id=args.session_id,
        )
    else:
        if args.amount is None:
            print("error: --amount is required unless --compute", file=sys.stderr)
            return 2
        result = award(
            amount=args.amount,
            skills=skills,
            reason=args.reason or "manual award",
            quality=args.quality,
            volume=args.lines,
            categories=args.category or [],
            journal=args.journal,
            source=args.source,
            session_id=args.session_id,
        )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    if result.get("leveled_up"):
        print(
            f"\n★ Level up! {result['old_level']} → {result['level']}",
            file=sys.stderr,
        )
        for m in result.get("milestones") or []:
            print(f"  🏆 {m}", file=sys.stderr)
    return 0


def cmd_init(args: argparse.Namespace) -> int:
    path = progress_path()
    if path.exists() and not args.force:
        print(json.dumps({"ok": True, "exists": True, "path": str(path)}))
        return 0
    p = default_progress()
    atomic_write_json(path, p)
    print(json.dumps({"ok": True, "created": True, "path": str(path)}))
    return 0


def cmd_session_start(args: argparse.Namespace) -> int:
    bump_session(args.session_id)
    # Multi-platform context injection (Claude / Cursor / SDK / plain)
    ctx = context_blob()
    # Escape for JSON
    payload = {
        "additionalContext": ctx,
        "additional_context": ctx,
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": ctx,
        },
        "systemMessage": f"Leveling Up Tutor active — learner Level {level_from_xp(load_progress().get('total_xp', 0))}",
    }
    print(json.dumps(payload, ensure_ascii=False))
    return 0


def cmd_quest_add(args: argparse.Namespace) -> int:
    skills = args.skill or []
    result = add_quest(args.title, args.detail or "", skills)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


def cmd_quest_complete(args: argparse.Namespace) -> int:
    result = complete_quest(args.id, xp=args.xp)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result.get("ok") else 1


def cmd_path(_: argparse.Namespace) -> int:
    print(
        json.dumps(
            {
                "plugin_root": str(plugin_root()),
                "data_dir": str(data_dir()),
                "progress": str(progress_path()),
                "history": str(history_path()),
            },
            indent=2,
        )
    )
    return 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="Leveling Up Tutor progress engine")
    sub = p.add_subparsers(dest="cmd", required=True)

    show = sub.add_parser("show", help="Display progress card")
    show.add_argument("--json", action="store_true")
    show.add_argument("--context", action="store_true", help="Agent bootstrap blob")
    show.set_defaults(func=cmd_show)

    award_p = sub.add_parser("award", help="Award XP")
    award_p.add_argument("--amount", type=float, default=None)
    award_p.add_argument(
        "--skill",
        action="append",
        type=parse_skill_arg,
        help="skill:xp (repeatable)",
    )
    award_p.add_argument("--reason", default="")
    award_p.add_argument("--journal", default=None)
    award_p.add_argument("--source", default="manual")
    award_p.add_argument("--session-id", default=None)
    award_p.add_argument("--category", action="append", default=[])
    award_p.add_argument("--lines", type=int, default=0)
    award_p.add_argument("--quality", type=float, default=0.7)
    award_p.add_argument("--compute", action="store_true", help="Use heuristic scorer")
    award_p.add_argument("--depth", type=float, default=0.5)
    award_p.add_argument("--design", type=float, default=0.0)
    award_p.add_argument("--reading", type=float, default=0.0)
    award_p.add_argument("--debugging", type=float, default=0.0)
    award_p.add_argument("--testing", type=float, default=0.0)
    award_p.add_argument("--ml-eng", type=float, default=0.0)
    award_p.add_argument("--research", type=float, default=0.0)
    award_p.add_argument("--independence", type=float, default=0.5)
    award_p.add_argument("--explanation", type=float, default=0.4)
    award_p.set_defaults(func=cmd_award)

    init_p = sub.add_parser("init", help="Create empty progress file")
    init_p.add_argument("--force", action="store_true")
    init_p.set_defaults(func=cmd_init)

    ss = sub.add_parser("session-start", help="Hook helper: bump session + emit context")
    ss.add_argument("--session-id", default=None)
    ss.set_defaults(func=cmd_session_start)

    qa = sub.add_parser("quest-add", help="Add active quest")
    qa.add_argument("--title", required=True)
    qa.add_argument("--detail", default="")
    qa.add_argument("--skill", action="append", default=[])
    qa.set_defaults(func=cmd_quest_add)

    qc = sub.add_parser("quest-complete", help="Complete a quest by id")
    qc.add_argument("--id", required=True)
    qc.add_argument("--xp", type=float, default=40.0)
    qc.set_defaults(func=cmd_quest_complete)

    path_p = sub.add_parser("path", help="Print data/plugin paths")
    path_p.set_defaults(func=cmd_path)

    return p


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    return int(args.func(args))


if __name__ == "__main__":
    sys.exit(main())
