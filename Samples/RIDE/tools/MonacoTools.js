(function(){
  // Toggleable debug
  function log(){ if (MonacoInput.DEBUG) console.log.apply(console, arguments); }
  function warn(){ if (MonacoInput.DEBUG) console.warn.apply(console, arguments); }
  function err(){ if (MonacoInput.DEBUG) console.error.apply(console, arguments); }

  function MonacoInput(selector, a, b) {
    log("[MonacoInput] start selector=", selector, "a=", a, "b=", b);

    function fail(msg){ warn("[MonacoInput] FAIL:", msg); return { ok:false, mode:"", details:String(msg) }; }
    function preview(s){ try { return String(s).slice(0,200); } catch { return ""; } }
    // Normalize: strip CR, zero-widths, normalize NBSP
    function norm(t){
      return String(t ?? "")
        .replace(/\r/g, "")
        .replace(/[\u200B-\u200D\uFEFF]/g, "")
        .replace(/\u00A0/g, " ");
    }

    const doc = window.document;
    const container = doc.querySelector(selector);
    if (!container) return fail("Container not found for selector: " + selector);
    log("[MonacoInput] container found:", container);

    const mon = (window.monaco && window.monaco.editor) || null;
    log("[MonacoInput] monaco.editor present:", !!mon);

    // helpers
    function pickEditorElement(root){
      let el = root.matches && root.matches(".monaco-editor") ? root : root.querySelector(".monaco-editor");
      const diffMod = root.querySelector(".monaco-diff-editor .modified .monaco-editor");
      if (diffMod) el = diffMod;
      return el;
    }
    const PRIVATE_HOOKS = ["__monaco","__editor","_editor","__monaco_editor__","__instance","__ed"];
    function tryPrivateHook(el){
      let cur = el, depth = 0;
      while (cur && depth < 5) {
        for (const k of PRIVATE_HOOKS) {
          if (Object.prototype.hasOwnProperty.call(cur, k) && cur[k]) {
            const v = cur[k];
            if (typeof v === "object" && (typeof v.getModel === "function" || typeof v.executeEdits === "function" || typeof v.trigger === "function")) {
              log("[MonacoInput] private hook found:", k, "->", v);
              return v;
            }
          }
        }
        cur = cur.parentElement; depth++;
      }
      return null;
    }
    function getModelFromEditorElement(editorEl){
      if (!mon) return null;
      try {
        const uriAttr = editorEl.getAttribute("data-uri");
        if (uriAttr && window.monaco && window.monaco.Uri && typeof mon.getModel === "function") {
          const uri = window.monaco.Uri.parse(uriAttr);
          const m = mon.getModel(uri);
          if (m) { log("[MonacoInput] model via getModel(uri)"); return m; }
        }
        if (typeof mon.getModels === "function") {
          const models = mon.getModels();
          const found = models.find(m => (m && m.uri && String(m.uri) === (editorEl.getAttribute("data-uri") || "")));
          if (found) { log("[MonacoInput] model via getModels() scan"); return found; }
        }
      } catch(e){ warn("[MonacoInput] getModelFromEditorElement error:", e); }
      return null;
    }
    function getCursorRect(editorEl){
      const cursors = Array.from(editorEl.querySelectorAll(".cursor"));
      for (const c of cursors) {
        const r = c.getBoundingClientRect();
        if (r.width >= 0 && r.height >= 0) return r;
      }
      const cl = editorEl.querySelector(".current-line");
      return cl ? cl.getBoundingClientRect() : null;
    }
    function extractViewLines(editorEl){
      const root = editorEl.querySelector(".view-lines");
      if (!root) return [];
      const arr = Array.from(root.querySelectorAll(".view-line"))
        .map(el => ({ el, text: norm(el.textContent || ""), rect: el.getBoundingClientRect() }))
        .filter(x => x.rect && x.rect.height > 0);
      arr.sort((a,b) => a.rect.top - b.rect.top);
      return arr;
    }
    function pickNearestViewLine(editorEl){
      const vlines = extractViewLines(editorEl);
      log("[MonacoInput] visible view-lines:", vlines.length);
      if (!vlines.length) return null;
      const caret = getCursorRect(editorEl);
      if (!caret) return { vline: vlines[0], idx: 0 };
      const cy = caret.top + caret.height / 2;
      let best = 0, bestDelta = Infinity;
      for (let i = 0; i < vlines.length; i++) {
        const mid = vlines[i].rect.top + vlines[i].rect.height / 2;
        const d = Math.abs(mid - cy);
        if (d < bestDelta) { bestDelta = d; best = i; }
      }
      return { vline: vlines[best], idx: best, delta: Math.round(bestDelta) };
    }
    function chooseToken(text){
      // prefer longest non-space token; aim for >=3 chars, else >=2, else trimmed line
      const tokens = (text.match(/[^\s]+/g) || []).map(norm);
      const long3 = tokens.filter(t => t.length >= 3).sort((a,b)=>b.length-a.length)[0];
      if (long3) return long3.slice(0,64);
      const long2 = tokens.filter(t => t.length >= 2).sort((a,b)=>b.length-a.length)[0];
      if (long2) return long2.slice(0,64);
      const t = text.trim();
      return t ? t.slice(0,64) : null;
    }

    // find a real editor instance first (if registry is exposed)
    let editor = null;
    if (mon && typeof mon.getEditors === "function") {
      const all = mon.getEditors();
      log("[MonacoInput] getEditors() length:", all.length);
      const under = all.filter(e => {
        const n = e && e.getDomNode && e.getDomNode();
        return n ? container.contains(n) || n === container : false;
      });
      log("[MonacoInput] editors under container:", under.length);
      if (under.length) editor = under.find(e => e.hasTextFocus && e.hasTextFocus()) || under[0];
    }
    if (!editor) {
      const editorEl0 = pickEditorElement(container);
      log("[MonacoInput] editor DOM element:", editorEl0);
      if (editorEl0) {
        const hooked = tryPrivateHook(editorEl0);
        if (hooked) editor = hooked;
      }
    }

    // Best path: Monaco API available
    if (editor) {
      try {
        const model = editor.getModel && editor.getModel();
        if (!model) return fail("Editor has no model");
        let pos = editor.getPosition && editor.getPosition();
        if (!pos) { editor.focus && editor.focus(); pos = editor.getPosition && editor.getPosition(); }
        if (!pos) return fail("No cursor position");

        log("[MonacoInput] cursor:", pos, "lines:", model.getLineCount());

        if (typeof b === "undefined") {
          // INSERT
          const text = (a ?? "");
          log("[MonacoInput] INSERT:", preview(text));
          const range = new monaco.Range(pos.lineNumber, pos.column, pos.lineNumber, pos.column);
          editor.executeEdits("MonacoInput/insert", [{ range, text, forceMoveMarkers: true }]);
          editor.pushUndoStop && editor.pushUndoStop();
          editor.setPosition({ lineNumber: pos.lineNumber, column: pos.column + text.length });
          editor.revealPositionInCenterIfOutsideViewport(editor.getPosition());
          log("[MonacoInput] insert done");
          return { ok:true, mode:"insert", details:`line=${pos.lineNumber}, col=${pos.column}, inserted='${preview(text)}'` };
        } else {
          // WRAP
          const line = pos.lineNumber;
          const original = model.getLineContent(line);
          const prefix = (a ?? ""), suffix = (b ?? "");
          const newText = prefix + original + suffix;
          log("[MonacoInput] WRAP line", line, "orig:", preview(original), "new:", preview(newText));
          const range = new monaco.Range(line, 1, line, model.getLineMaxColumn(line));
          editor.executeEdits("MonacoInput/wrap", [{ range, text: newText, forceMoveMarkers: true }]);
          editor.pushUndoStop && editor.pushUndoStop();
          editor.setPosition({ lineNumber: line, column: newText.length + 1 });
          editor.revealLineInCenterIfOutsideViewport(line);
          log("[MonacoInput] wrap done");
          return { ok:true, mode:"wrap", details:`line=${line}, newLine='${preview(newText)}'` };
        }
      } catch (e) {
        err("[MonacoInput] API exception:", e);
        // fall through to fallbacks
      }
    }

    // Fallbacks (no editor instance)
    const editorEl = pickEditorElement(container);
    log("[MonacoInput] fallback editor element:", editorEl);
    if (!editorEl) return fail("No .monaco-editor element found under selector");

    if (typeof b === "undefined") {
      // INSERT via hidden textarea
      const ta = editorEl.querySelector("textarea,input,[contenteditable='true']");
      log("[MonacoInput] fallback target input:", ta);
      if (!ta) return fail("No editable input area found for insert fallback");
      try {
        editorEl.focus && editorEl.focus();
        ta.focus();
        editorEl.dispatchEvent(new Event("focus", { bubbles: true }));
        ta.dispatchEvent(new Event("focus", { bubbles: true }));
      } catch(_) {}
      const text = (a ?? "");
      log("[MonacoInput] fallback INSERT:", preview(text));
      try {
        let ok = false;
        if (typeof ta.setRangeText === "function" && ("selectionStart" in ta)) {
          const start = ta.selectionStart ?? 0;
          const end   = ta.selectionEnd ?? start;
          ta.setRangeText(text, start, end, "end");
          ta.dispatchEvent(new InputEvent("beforeinput", { bubbles: true, inputType: "insertText", data: text }));
          ta.dispatchEvent(new InputEvent("input", { bubbles: true, composed: true, data: text, inputType: "insertText" }));
          ok = true;
        }
        if (!ok && doc.execCommand) {
          ok = doc.execCommand("insertText", false, text);
          log("[MonacoInput] execCommand('insertText'):", ok);
        }
        if (!ok) {
          const old = ta.value || "";
          ta.value = old + text;
          ta.dispatchEvent(new InputEvent("input", { bubbles: true, composed: true, data: text, inputType: "insertText" }));
        }
        return { ok:true, mode:"insert-fallback", details:`inserted='${preview(text)}' (no Monaco API)` };
      } catch (e) {
        err("[MonacoInput] fallback insert failed:", e);
        return fail("Fallback insert failed: " + (e && e.message ? e.message : e));
      }
    } else {
      // WRAP mapping via nearest .view-line → token → model.findMatches
      if (!mon) return fail("Wrap requires monaco.editor model API (monaco not present)");
      const model = getModelFromEditorElement(editorEl);
      if (!model) return fail("Could not resolve model from editor element (missing data-uri / getModels())");

      const picked = (function(){
        const vlines = extractViewLines(editorEl);
        log("[MonacoInput] visible view-lines:", vlines.length);
        if (!vlines.length) return null;
        const caret = getCursorRect(editorEl);
        if (!caret) return { vline: vlines[0], idx: 0 };
        const cy = caret.top + caret.height / 2;
        let best = 0, bestDelta = Infinity;
        for (let i = 0; i < vlines.length; i++) {
          const mid = vlines[i].rect.top + vlines[i].rect.height / 2;
          const d = Math.abs(mid - cy);
          if (d < bestDelta) { bestDelta = d; best = i; }
        }
        return { vline: vlines[best], idx: best, delta: Math.round(bestDelta) };
      })();
      if (!picked) return fail("No visible view-lines found");
      const vtext = picked.vline.text;
      if (!vtext) return fail("Nearest view-line text is empty (cannot map)");

      const token = (function(t){
        const tokens = (t.match(/[^\s]+/g) || []).map(s=>s.replace(/\r/g,"").replace(/[\u200B-\u200D\uFEFF]/g,"").replace(/\u00A0/g," "));
        const long3 = tokens.filter(x=>x.length>=3).sort((a,b)=>b.length-a.length)[0];
        if (long3) return long3.slice(0,64);
        const long2 = tokens.filter(x=>x.length>=2).sort((a,b)=>b.length-a.length)[0];
        if (long2) return long2.slice(0,64);
        const tt = t.trim(); return tt ? tt.slice(0,64) : null;
      })(vtext);
      if (!token) return fail("Could not derive a search token from view-line");
      log("[MonacoInput] wrap-fallback token:", token);

      let matches = [];
      try {
        if (typeof model.findMatches === "function") {
          matches = model.findMatches(token, false, false, false, null, false) || [];
        }
      } catch(e) { warn("[MonacoInput] model.findMatches error:", e); }
      if (!matches.length) {
        const lineCount = model.getLineCount();
        for (let L = 1; L <= lineCount; L++) {
          const mt = (model.getLineContent(L)||"").replace(/\r/g,"").replace(/[\u200B-\u200D\uFEFF]/g,"").replace(/\u00A0/g," ");
          if (mt.includes(token)) { matches.push({ range: new monaco.Range(L, 1, L, 1) }); break; }
        }
      }
      if (!matches.length) return fail("No model match for token: " + token);

      let line = null;
      for (const m of matches) {
        const L = m.range && m.range.startLineNumber;
        if (!L) continue;
        const mt = (model.getLineContent(L)||"").replace(/\r/g,"").replace(/[\u200B-\u200D\uFEFF]/g,"").replace(/\u00A0/g," ");
        if (mt === vtext) { line = L; break; }
      }
      if (!line) line = matches[0].range.startLineNumber;

      const prefix = (a ?? ""), suffix = (b ?? "");
      const original = model.getLineContent(line);
      const newText = prefix + original + suffix;
      log("[MonacoInput] WRAP via model.applyEdits line", line, "orig:", preview(original), "new:", preview(newText));

      try {
        const range = new monaco.Range(line, 1, line, model.getLineMaxColumn(line));
        model.applyEdits([{ range, text: newText, forceMoveMarkers: true }]);
        log("[MonacoInput] wrap (model) done");
        return { ok:true, mode:"wrap-model-fallback", details:`line=${line}, newLine='${preview(newText)}'` };
      } catch (e) {
        err("[MonacoInput] model.applyEdits failed:", e);
        return fail("Model wrap failed: " + (e && e.message ? e.message : e));
      }
    }
  }

  // ===================== EnterKey (improved mapping + cache) =====================

  // cache last mapped line per model-uri to keep mappings stable across calls
  const __MonacoEnterCache = new Map(); // key: modelUri(string), value: { lastLine: number, lastTs: number }
  function __getModelUriString(model){ try { return String(model.uri); } catch(_) { return ""; } }

  // Extract visible .view-line nodes (sorted) for EnterKey mapping
  function __extractViewLines(editorEl){
    const root = editorEl.querySelector(".view-lines");
    if (!root) return [];
    const arr = Array.from(root.querySelectorAll(".view-line"))
      .map(el => ({
        el,
        text: (el.textContent || "").replace(/\r/g,"").replace(/[\u200B-\u200D\uFEFF]/g,"").replace(/\u00A0/g," "),
        rect: el.getBoundingClientRect()
      }))
      .filter(x => x.rect && x.rect.height > 0);
    arr.sort((a,b) => a.rect.top - b.rect.top);
    return arr;
  }

  // Multi-line mapping: match a short run (k lines) of visible lines exactly in the model; prefer vicinity
  function __mapViewToModelByRun(model, vlines, preferAround /* number | null */){
    if (!vlines.length) return null;
    const lineCount = model.getLineCount();
    const maxK = Math.min(5, vlines.length);
    for (let k = maxK; k >= 1; k--) {
      const runs = [];
      for (let i = 0; i <= vlines.length - k; i++) {
        const seg = vlines.slice(i, i+k);
        if (seg.some(x => x.text.length > 0)) runs.push({ i, seg });
      }
      if (!runs.length) continue;

      let best = null, bestScore = Infinity;
      for (const run of runs) {
        for (let L = 1; L <= lineCount - k + 1; L++) {
          // quick check first line
          if ((model.getLineContent(L) || "") !== run.seg[0].text) continue;
          // verify whole run
          let ok = true;
          for (let j = 1; j < k; j++) {
            if ((model.getLineContent(L + j) || "") !== run.seg[j].text) { ok = false; break; }
          }
          if (!ok) continue;
          const score = (preferAround ? Math.abs(L - preferAround) : 0) * 10 + run.i;
          if (score < bestScore) { bestScore = score; best = { firstModelLine: L, viewOffset: run.i, k }; }
        }
      }
      if (best) return best;
    }
    return null;
  }


// Minimal EnterKey: fire real Enter (optionally with Shift/Ctrl) for APL session.
function EnterKey(selector, combo) {
  // combo: "plain" | "shift" | "ctrl" | "ctrl-shift"
  const useCombo = (combo || "plain").toLowerCase();
  const mods = {
    ctrlKey:  useCombo === "ctrl" || useCombo === "ctrl-shift",
    shiftKey: useCombo === "shift" || useCombo === "ctrl-shift",
    altKey:   false,
    metaKey:  false
  };

  function log(){ if (MonacoInput && MonacoInput.DEBUG) console.log.apply(console, arguments); }
  function warn(){ if (MonacoInput && MonacoInput.DEBUG) console.warn.apply(console, arguments); }

  log("[EnterKey] start selector=", selector, "combo=", useCombo);

  const root = document.querySelector(selector);
  if (!root) { warn("[EnterKey] FAIL: container not found"); return { ok:false, details:"container not found" }; }

  // Prefer the Monaco textarea (that's where Monaco listens for keyboard input).
  // Fallback to any focusable element inside the editor.
  const editorEl =
    (root.matches(".monaco-editor") ? root : root.querySelector(".monaco-editor")) ||
    root;
  const ta = editorEl.querySelector("textarea.inputarea, textarea, input, [contenteditable='true']");

  if (!ta) { warn("[EnterKey] FAIL: no editable target"); return { ok:false, details:"no editable target" }; }

  // Ensure focus is on the textarea to receive events.
  try {
    editorEl.focus && editorEl.focus();
    ta.focus && ta.focus();
    editorEl.dispatchEvent(new Event("focus", { bubbles:true }));
    ta.dispatchEvent(new Event("focus", { bubbles:true }));
  } catch(_) {}

  // Optionally close suggest widgets to avoid the editor turning Enter into "accept suggestion".
  // If you want Enter to accept suggestions, remove this block.
  try {
    ta.dispatchEvent(new KeyboardEvent("keydown", { key:"Escape", code:"Escape", bubbles:true, cancelable:true }));
    ta.dispatchEvent(new KeyboardEvent("keyup",   { key:"Escape", code:"Escape", bubbles:true, cancelable:true }));
  } catch(_) {}

  // Dispatch the Enter key events. We don't emit beforeinput/input here,
  // because in APL session Enter should trigger the host app handler, not insert a newline.
  function fire(type){
    const ev = new KeyboardEvent(type, Object.assign({
      key: "Enter",
      code: "Enter",
      bubbles: true,
      cancelable: true
    }, mods));
    // Some engines still look at legacy properties:
    try { Object.defineProperty(ev, "keyCode", { get: () => 13 }); } catch(_) {}
    try { Object.defineProperty(ev, "which",   { get: () => 13 }); } catch(_) {}
    ta.dispatchEvent(ev);
  }

  fire("keydown");
  fire("keypress");
  fire("keyup");

  log("[EnterKey] dispatched Enter events with mods:", mods);
  return { ok:true, mode:"events", details:`Enter(${useCombo}) dispatched` };
}


  // expose (single, clean)
  window.EnterKey = EnterKey;
  MonacoInput.EnterKey = EnterKey;

  MonacoInput.DEBUG = true;
  // expose globally
  window.MonacoInput = MonacoInput;
})();
