#!/usr/bin/env python3
"""Convert helix themes (helix/themes/*.toml) into nvim colorschemes (nvim/colors/*.lua).

Usage: python3 nvim/scripts/helix2nvim.py   (re-run after editing a helix theme)
Resolution mirrors helix: `inherits` merges parent theme + palette, and a scope
like `keyword.control.conditional` falls back to `keyword.control`, then `keyword`.
"""
import pathlib, tomllib

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "helix" / "themes"
BUILTIN = pathlib.Path("/opt/homebrew/opt/helix/libexec/runtime/themes")
OUT = ROOT / "nvim" / "colors"

# nvim group -> helix scope candidates (first exact hit wins, then fallback of the first).
# A dict picks attributes from different scopes: {"fg": [...], "bg": [...]}.
UI = {
    "Normal": {"fg": ["ui.text"], "bg": ["ui.background"]},
    "NormalNC": {"fg": ["ui.text"], "bg": ["ui.background"]},
    "NormalFloat": {"fg": ["ui.popup", "ui.text"], "bg": ["ui.popup", "ui.background"]},
    "FloatBorder": {"fg": ["ui.window", "ui.text"], "bg": ["ui.popup", "ui.background"]},
    "FloatTitle": {"fg": ["ui.text.focus", "ui.text"], "bg": ["ui.popup", "ui.background"]},
    "Cursor": ["ui.cursor.primary", "ui.cursor"],
    "CursorLine": {"bg": ["ui.cursorline.primary"]},
    "CursorColumn": {"bg": ["ui.cursorcolumn.primary", "ui.cursorline.primary"]},
    "ColorColumn": {"bg": ["ui.virtual.ruler"]},
    "Visual": {"bg": ["ui.selection.primary", "ui.selection"]},
    "LineNr": ["ui.linenr"],
    "CursorLineNr": ["ui.linenr.selected"],
    "SignColumn": {"bg": ["ui.gutter"]},
    "CursorLineSign": {"bg": ["ui.gutter.selected", "ui.cursorline.primary"]},
    "StatusLine": ["ui.statusline"],
    "StatusLineNC": ["ui.statusline.inactive", "ui.statusline"],
    "WinSeparator": {"fg": ["ui.window"]},
    "TabLine": ["ui.bufferline", "ui.statusline.inactive"],
    "TabLineSel": ["ui.bufferline.active", "ui.statusline"],
    "TabLineFill": {"bg": ["ui.bufferline.background", "ui.bufferline", "ui.statusline"]},
    "Pmenu": ["ui.menu", "ui.popup"],
    "PmenuSel": ["ui.menu.selected"],
    "PmenuSbar": {"bg": ["ui.menu.scroll", "ui.menu"]},
    "PmenuThumb": {"bg": ["ui.menu.selected"]},
    "Search": ["ui.search.match", "ui.selection"],
    "CurSearch": ["ui.selection.primary", "ui.selection"],
    "IncSearch": ["ui.selection.primary", "ui.selection"],
    "MatchParen": ["ui.cursor.match"],
    "Whitespace": {"fg": ["ui.virtual.whitespace"]},
    "NonText": {"fg": ["ui.virtual.whitespace", "ui.virtual"]},
    "SpecialKey": {"fg": ["ui.virtual.whitespace", "ui.virtual"]},
    "Conceal": {"fg": ["ui.virtual"]},
    "Folded": {"fg": ["comment"], "bg": ["ui.cursorline.secondary", "ui.cursorline.primary"]},
    "Directory": {"fg": ["ui.text.directory", "ui.text.focus", "function"]},
    "Title": {"fg": ["markup.heading"]},
    "ErrorMsg": {"fg": ["error"]},
    "WarningMsg": {"fg": ["warning"]},
    "MoreMsg": {"fg": ["info"]},
    "Question": {"fg": ["info"]},
    "QuickFixLine": {"bg": ["ui.cursorline.primary"]},
    "WildMenu": ["ui.menu.selected"],
    "LspInlayHint": ["ui.virtual.inlay-hint"],
    "LspReferenceText": {"bg": ["ui.highlight", "ui.cursorline.primary"]},
    "LspReferenceRead": {"bg": ["ui.highlight", "ui.cursorline.primary"]},
    "LspReferenceWrite": {"bg": ["ui.highlight", "ui.cursorline.primary"]},
    "DiagnosticError": {"fg": ["error"]},
    "DiagnosticWarn": {"fg": ["warning"]},
    "DiagnosticInfo": {"fg": ["info"]},
    "DiagnosticHint": {"fg": ["hint"]},
    "DiagnosticOk": {"fg": ["diff.plus"]},
    "DiagnosticUnnecessary": ["diagnostic.unnecessary"],
    "DiagnosticDeprecated": ["diagnostic.deprecated"],
    "Added": {"fg": ["diff.plus"]},
    "Changed": {"fg": ["diff.delta"]},
    "Removed": {"fg": ["diff.minus"]},
    "SnacksIndent": {"fg": ["ui.virtual.indent-guide"]},
    "HxModeNormal": ["ui.statusline.normal"],
    "HxModeInsert": ["ui.statusline.insert"],
    "HxModeSelect": ["ui.statusline.select"],
}

SYNTAX = {
    "@variable": ["variable"],
    "@variable.builtin": ["variable.builtin"],
    "@variable.parameter": ["variable.parameter"],
    "@variable.member": ["variable.other.member"],
    "@property": ["variable.other.member"],
    "@constant": ["constant"],
    "@constant.builtin": ["constant.builtin"],
    "@constant.macro": ["constant"],
    "@module": ["namespace", "module"],
    "@label": ["label"],
    "@string": ["string"],
    "@string.regexp": ["string.regexp"],
    "@string.escape": ["constant.character.escape"],
    "@string.special": ["string.special"],
    "@string.special.symbol": ["string.special.symbol"],
    "@string.special.path": ["string.special.path"],
    "@string.special.url": ["string.special.url", "markup.link.url"],
    "@character": ["constant.character"],
    "@character.special": ["constant.character.escape"],
    "@boolean": ["constant.builtin.boolean"],
    "@number": ["constant.numeric.integer"],
    "@number.float": ["constant.numeric.float"],
    "@type": ["type"],
    "@type.builtin": ["type.builtin"],
    "@type.definition": ["type"],
    "@attribute": ["attribute"],
    "@function": ["function"],
    "@function.builtin": ["function.builtin"],
    "@function.macro": ["function.macro"],
    "@function.method": ["function.method"],
    "@constructor": ["constructor"],
    "@operator": ["operator"],
    "@keyword": ["keyword"],
    "@keyword.coroutine": ["keyword.control"],
    "@keyword.function": ["keyword.function"],
    "@keyword.operator": ["keyword.operator"],
    "@keyword.import": ["keyword.control.import"],
    "@keyword.type": ["keyword.storage.type"],
    "@keyword.modifier": ["keyword.storage.modifier"],
    "@keyword.repeat": ["keyword.control.repeat"],
    "@keyword.return": ["keyword.control.return"],
    "@keyword.exception": ["keyword.control.exception"],
    "@keyword.conditional": ["keyword.control.conditional"],
    "@keyword.directive": ["keyword.directive"],
    "@punctuation.delimiter": ["punctuation.delimiter"],
    "@punctuation.bracket": ["punctuation.bracket"],
    "@punctuation.special": ["punctuation.special"],
    "@comment": ["comment"],
    "@comment.documentation": ["comment.block.documentation", "comment.documentation"],
    "@comment.error": ["error"],
    "@comment.warning": ["warning"],
    "@comment.todo": ["hint"],
    "@comment.note": ["info"],
    "@markup.strong": ["markup.bold"],
    "@markup.italic": ["markup.italic"],
    "@markup.strikethrough": ["markup.strikethrough"],
    "@markup.heading": ["markup.heading"],
    **{f"@markup.heading.{i}": [f"markup.heading.{i}"] for i in range(1, 7)},
    "@markup.quote": ["markup.quote"],
    "@markup.link": ["markup.link.text"],
    "@markup.link.label": ["markup.link.label"],
    "@markup.link.url": ["markup.link.url"],
    "@markup.raw": ["markup.raw"],
    "@markup.raw.block": ["markup.raw.block"],
    "@markup.list": ["markup.list"],
    "@markup.list.checked": ["markup.list.checked"],
    "@markup.list.unchecked": ["markup.list.unchecked"],
    "@diff.plus": ["diff.plus"],
    "@diff.minus": ["diff.minus"],
    "@diff.delta": ["diff.delta"],
    "@tag": ["tag"],
    "@tag.builtin": ["tag.builtin"],
    "@tag.attribute": ["tag.attribute", "attribute"],
    "@tag.delimiter": ["tag.delimiter", "punctuation.bracket"],
    # legacy :syntax groups (used by non-treesitter filetypes)
    "Comment": ["comment"],
    "String": ["string"],
    "Character": ["constant.character"],
    "Number": ["constant.numeric"],
    "Float": ["constant.numeric.float"],
    "Boolean": ["constant.builtin.boolean"],
    "Constant": ["constant"],
    "Identifier": ["variable"],
    "Function": ["function"],
    "Statement": ["keyword"],
    "Conditional": ["keyword.control.conditional"],
    "Repeat": ["keyword.control.repeat"],
    "Label": ["label"],
    "Operator": ["operator"],
    "Keyword": ["keyword"],
    "Exception": ["keyword.control.exception"],
    "PreProc": ["keyword.directive"],
    "Include": ["keyword.control.import"],
    "Define": ["keyword.directive"],
    "Macro": ["function.macro"],
    "Type": ["type"],
    "StorageClass": ["keyword.storage"],
    "Structure": ["type"],
    "Typedef": ["type"],
    "Special": ["special", "constant.character.escape"],
    "SpecialChar": ["constant.character.escape"],
    "Tag": ["tag"],
    "Delimiter": ["punctuation.delimiter"],
    "SpecialComment": ["comment"],
    "Underlined": ["markup.link.url"],
    "Error": ["error"],
    "Todo": ["hint", "info"],
}

ANSI = {  # helix named colors -> nvim color names
    "black": "Black", "red": "DarkRed", "green": "DarkGreen", "yellow": "DarkYellow",
    "blue": "DarkBlue", "magenta": "DarkMagenta", "cyan": "DarkCyan", "gray": "Gray",
    "light-red": "Red", "light-green": "Green", "light-yellow": "Yellow", "light-blue": "Blue",
    "light-magenta": "Magenta", "light-cyan": "Cyan", "light-gray": "LightGray", "white": "White",
}
UNDERLINE = {"line": "underline", "curl": "undercurl", "dashed": "underdashed",
             "dotted": "underdotted", "double_line": "underdouble"}
MODIFIERS = {"bold": "bold", "italic": "italic", "underlined": "underline",
             "crossed_out": "strikethrough", "reversed": "reverse"}


def load(name):
    for d in (SRC, BUILTIN):
        p = d / f"{name}.toml"
        if p.exists():
            t = tomllib.loads(p.read_text())
            break
    else:
        raise SystemExit(f"theme not found: {name}")
    parent = t.pop("inherits", None)
    if not parent:
        return t
    base = load(parent)
    palette = {**base.pop("palette", {}), **t.pop("palette", {})}
    return {**base, **t, "palette": palette}


def color(v, palette):
    if not v or v in ("default", "reset"):
        return None
    if v.startswith("#"):
        return v
    if v in palette:
        return color(palette[v], {})
    return ANSI.get(v)


def style(theme, scope):
    v = theme.get(scope)
    if v is None:
        return None
    pal = theme.get("palette", {})
    if isinstance(v, str):
        return {"fg": color(v, pal)}
    out = {"fg": color(v.get("fg"), pal), "bg": color(v.get("bg"), pal)}
    for m in v.get("modifiers", []):
        if m in MODIFIERS:
            out[MODIFIERS[m]] = True
    ul = v.get("underline")
    if isinstance(ul, dict):
        out["sp"] = color(ul.get("color"), pal)
        out[UNDERLINE.get(ul.get("style", "line"), "underline")] = True
    return {k: x for k, x in out.items() if x is not None}


def resolve(theme, candidates):
    for c in candidates:
        if c in theme:
            return style(theme, c)
    parts = candidates[0].split(".")
    for i in range(len(parts) - 1, 0, -1):
        s = ".".join(parts[:i])
        if s in theme:
            return style(theme, s)
    return None


def attr(theme, candidates, key):
    for c in candidates:
        s = resolve(theme, [c])
        if s and key in s:
            return s[key]
    return None


def blend(a, b, t):
    if not (a and b and a.startswith("#") and b.startswith("#")):
        return None
    x = [int(a[i:i + 2], 16) for i in (1, 3, 5)]
    y = [int(b[i:i + 2], 16) for i in (1, 3, 5)]
    return "#" + "".join(f"{round(p * t + q * (1 - t)):02x}" for p, q in zip(x, y))


def convert(name):
    theme = load(name)
    groups = {}
    for group, spec in {**UI, **SYNTAX}.items():
        if isinstance(spec, dict):
            s = {k: attr(theme, c, k) for k, c in spec.items()}
            s = {k: v for k, v in s.items() if v}
        else:
            s = resolve(theme, spec) or {}
        if s:
            groups[group] = s
    normal = groups.get("Normal", {})
    fg, bg = normal.get("fg"), normal.get("bg")
    # helix renders unmatched scopes with ui.text; do the same instead of nvim's defaults
    for group in SYNTAX:
        groups.setdefault(group, {"fg": fg} if fg else {})
    # diagnostics: helix `diagnostic.*` is the underline; color comes from error/warning/...
    for sev, scope in (("Error", "error"), ("Warn", "warning"), ("Info", "info"), ("Hint", "hint")):
        u = resolve(theme, [f"diagnostic.{ {'Warn': 'warning'}.get(sev, sev.lower()) }"]) or {}
        sp = u.get("sp") or attr(theme, [scope], "fg")
        groups[f"DiagnosticUnderline{sev}"] = {"sp": sp, "undercurl": True} if sp else {"undercurl": True}
    # diff mode needs backgrounds; helix only defines gutter fg, so tint it
    for group, scope in (("DiffAdd", "diff.plus"), ("DiffDelete", "diff.minus"),
                         ("DiffChange", "diff.delta"), ("DiffText", "diff.delta")):
        c = attr(theme, [scope], "fg")
        tinted = blend(c, bg, 0.35 if group == "DiffText" else 0.18)
        if tinted:
            groups[group] = {"bg": tinted}
    dark = True
    if bg and bg.startswith("#"):
        r, g, b = (int(bg[i:i + 2], 16) for i in (1, 3, 5))
        dark = (0.299 * r + 0.587 * g + 0.114 * b) < 128
    lines = [
        f"-- Generated from helix/themes/{name}.toml by nvim/scripts/helix2nvim.py. Do not edit.",
        'vim.cmd("hi clear")',
        f'vim.g.colors_name = "{name}"',
        f'vim.o.background = "{"dark" if dark else "light"}"',
        "local hl = vim.api.nvim_set_hl",
    ]
    for group in sorted(groups):
        s = groups[group]
        body = ", ".join(f'{k} = {"true" if v is True else repr(v).replace(chr(39), chr(34))}'
                         for k, v in sorted(s.items()))
        lines.append(f'hl(0, "{group}", {{ {body} }})')
    (OUT / f"{name}.lua").write_text("\n".join(lines) + "\n")


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    names = sorted(p.stem for p in SRC.glob("*.toml"))
    for n in names:
        convert(n)
    print(f"converted {len(names)} themes -> {OUT}")
