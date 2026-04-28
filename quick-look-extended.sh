#!/usr/bin/env bash
set -euo pipefail

APP="$HOME/Applications/QuickLookExtended.app"
EXECUTABLE="$APP/Contents/MacOS/QuickLookExtended"
PLIST="$APP/Contents/Info.plist"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"

usage() {
  cat <<'EOF'
Usage: quick-look-extended [install|uninstall|verify]

install    Register common text/code file extensions as plain text for Quick Look.
uninstall  Remove the local mapping app and unregister it.
verify     Print macOS content types for sample .md, .conf, and .yml files.

Note: this works by filename extension. It cannot force Apple-owned UTIs like
public.yaml to use the built-in text Quick Look generator on every macOS version.
EOF
}

reset_quicklook() {
  qlmanage -r >/dev/null
  qlmanage -r cache >/dev/null
}

install_app() {
  mkdir -p "$APP/Contents/MacOS"

  cat > "$EXECUTABLE" <<'EOF'
#!/bin/sh
exit 0
EOF
  chmod +x "$EXECUTABLE"

  cat > "$PLIST" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleIdentifier</key>
  <string>local.quicklook.extended</string>
  <key>CFBundleName</key>
  <string>Quick Look Extended</string>
  <key>CFBundleExecutable</key>
  <string>QuickLookExtended</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleVersion</key>
  <string>1.0</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>LSUIElement</key>
  <true/>

  <key>UTExportedTypeDeclarations</key>
  <array>
    <dict>
      <key>UTTypeIdentifier</key>
      <string>local.quicklook.text</string>
      <key>UTTypeDescription</key>
      <string>Text-like file</string>
      <key>UTTypeConformsTo</key>
      <array>
        <string>public.plain-text</string>
      </array>
      <key>UTTypeTagSpecification</key>
      <dict>
        <key>public.filename-extension</key>
        <array>
          <string>txt</string>
          <string>text</string>
          <string>log</string>
          <string>out</string>
          <string>err</string>
          <string>md</string>
          <string>markdown</string>
          <string>mdown</string>
          <string>mkd</string>
          <string>rst</string>
          <string>adoc</string>
          <string>asciidoc</string>
          <string>org</string>
          <string>tex</string>
          <string>bib</string>
          <string>jsonl</string>
          <string>ndjson</string>
          <string>toml</string>
          <string>ini</string>
          <string>cfg</string>
          <string>conf</string>
          <string>config</string>
          <string>properties</string>
          <string>env</string>
          <string>dotenv</string>
          <string>csv</string>
          <string>tsv</string>
          <string>psv</string>
          <string>sql</string>
          <string>strings</string>
          <string>sh</string>
          <string>bash</string>
          <string>zsh</string>
          <string>fish</string>
          <string>ksh</string>
          <string>csh</string>
          <string>ps1</string>
          <string>psm1</string>
          <string>psd1</string>
          <string>bat</string>
          <string>cmd</string>
          <string>py</string>
          <string>pyw</string>
          <string>rb</string>
          <string>pl</string>
          <string>pm</string>
          <string>php</string>
          <string>lua</string>
          <string>r</string>
          <string>R</string>
          <string>jl</string>
          <string>go</string>
          <string>rs</string>
          <string>swift</string>
          <string>java</string>
          <string>kt</string>
          <string>kts</string>
          <string>scala</string>
          <string>groovy</string>
          <string>js</string>
          <string>mjs</string>
          <string>cjs</string>
          <string>jsx</string>
          <string>ts</string>
          <string>tsx</string>
          <string>css</string>
          <string>scss</string>
          <string>sass</string>
          <string>less</string>
          <string>vue</string>
          <string>svelte</string>
          <string>astro</string>
          <string>c</string>
          <string>h</string>
          <string>cc</string>
          <string>cpp</string>
          <string>cxx</string>
          <string>hpp</string>
          <string>hxx</string>
          <string>m</string>
          <string>mm</string>
          <string>make</string>
          <string>mk</string>
          <string>mak</string>
          <string>cmake</string>
          <string>gradle</string>
          <string>gemspec</string>
          <string>podspec</string>
          <string>lock</string>
          <string>diff</string>
          <string>patch</string>
          <string>gitignore</string>
          <string>gitattributes</string>
          <string>gitmodules</string>
          <string>dockerignore</string>
          <string>editorconfig</string>
          <string>npmrc</string>
          <string>yarnrc</string>
          <string>prettierrc</string>
          <string>eslintrc</string>
        </array>
        <key>public.mime-type</key>
        <string>text/plain</string>
      </dict>
    </dict>
  </array>

  <key>UTImportedTypeDeclarations</key>
  <array>
    <dict>
      <key>UTTypeIdentifier</key>
      <string>public.yaml</string>
      <key>UTTypeDescription</key>
      <string>YAML text file</string>
      <key>UTTypeConformsTo</key>
      <array>
        <string>public.plain-text</string>
      </array>
      <key>UTTypeTagSpecification</key>
      <dict>
        <key>public.filename-extension</key>
        <array>
          <string>yaml</string>
          <string>yml</string>
        </array>
      </dict>
    </dict>
  </array>

  <key>CFBundleDocumentTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeName</key>
      <string>Text-like file</string>
      <key>LSItemContentTypes</key>
      <array>
        <string>local.quicklook.text</string>
      </array>
      <key>CFBundleTypeRole</key>
      <string>Viewer</string>
      <key>LSHandlerRank</key>
      <string>None</string>
    </dict>
  </array>
</dict>
</plist>
EOF

  plutil -lint "$PLIST" >/dev/null
  touch "$APP"
  "$LSREGISTER" -f "$APP"
  reset_quicklook

  echo "Installed: $APP"
  echo "Restart Finder or log out/in if Finder still shows old previews."
}

uninstall_app() {
  if [[ -d "$APP" ]]; then
    "$LSREGISTER" -u "$APP" || true
    rm -rf "$APP"
  fi

  reset_quicklook
  echo "Uninstalled: $APP"
}

verify_types() {
  local tmpdir
  tmpdir="$(mktemp -d)"

  printf '# hello\n' > "$tmpdir/test.md"
  printf 'hello=true\n' > "$tmpdir/test.conf"
  printf 'hello: world\n' > "$tmpdir/test.yml"

  mdls -name kMDItemContentType -name kMDItemContentTypeTree \
    "$tmpdir/test.md" \
    "$tmpdir/test.conf" \
    "$tmpdir/test.yml"

  rm -rf "$tmpdir"
}

case "${1:-install}" in
  install)
    install_app
    ;;
  uninstall)
    uninstall_app
    ;;
  verify)
    verify_types
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
