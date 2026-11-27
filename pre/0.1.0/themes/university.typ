// University theme (modernized editorial variant for @local/pre:0.1.0)
// Keeps the original deep ocean-teal hue family (#04364A / #176B87 / #448C95)
// with softer saturation & transparency, unified Inter + Noto Sans CJK SC typography,
// generous whitespace, adaptive cover rule, borderless overview, and left-of-page-number progress bar.

#import "@preview/touying:0.6.1": *

// Unified semantic palette (anchored on the #04364A / #176B87 ocean-teal family)
#let c-ink = rgb("#04364A")       // Primary headings & strong anchors
#let c-body = rgb("#1B3644")      // Primary readable body text
#let c-muted = rgb("#5B717E")     // Secondary text & annotations
#let c-dim = rgb("#93A5B0")       // De-emphasized background context
#let c-line = rgb("#D8E3E8")      // Hairline dividers & subtle borders
#let c-wash = rgb("#F4F7F9")      // Soft card surface
#let c-wash-alt = rgb("#EBF2F5")  // Tinted surface

#let c-teal = rgb("#176B87")      // Primary accent (same hue family as primary)
#let c-teal-bg = rgb("#E9F4F7")
#let c-violet = rgb("#5B4BB7")    // Secondary semantic accent (compute / compiler / matrix)
#let c-violet-bg = rgb("#F2EFFB")
#let c-amber = rgb("#C2611A")     // Warm semantic accent (alert / writeback / bottleneck)
#let c-amber-bg = rgb("#FDF4EC")

#let font-sans = ("Inter", "Noto Sans CJK SC")
#let font-mono = ("JetBrainsMono NF", "Noto Sans Mono CJK SC")

// Shared UI components for clean slides
#let eyebrow(body) = text(
  size: 10.5pt,
  weight: "semibold",
  fill: c-teal,
  tracking: 0.04em,
  body,
)

#let lead(body) = text(size: 15pt, fill: c-muted, body)

#let kicker(body) = text(size: 11.5pt, fill: c-muted, body)

#let pill(body, fill: c-wash, color: c-ink, size: 11.5pt, weight: "medium") = box(
  fill: fill,
  inset: (x: 8pt, y: 3.5pt),
  radius: 4pt,
  baseline: 15%,
  text(size: size, fill: color, weight: weight, body),
)

#let card(
  body,
  fill: c-wash,
  stroke: none,
  inset: (x: 16pt, y: 14pt),
  radius: 8pt,
  width: 100%,
) = block(
  width: width,
  fill: fill,
  stroke: stroke,
  inset: inset,
  radius: radius,
  breakable: false,
  body,
)

#let accent-card(
  body,
  accent: c-teal,
  fill: c-wash,
  inset: (x: 16pt, y: 12pt),
  width: 100%,
) = block(
  width: width,
  fill: fill,
  stroke: (left: 3pt + accent),
  inset: inset,
  radius: (right: 6pt),
  breakable: false,
  body,
)

#let pad-two(n) = if n < 10 { "0" + str(n) } else { str(n) }

// 1-based ordinal of current level-1 heading
#let current-section-index() = {
  let curr = utils.current-heading(level: 1)
  if curr == none { return none }
  let h1s = query(heading.where(level: 1))
  let idx = 0
  for h in h1s {
    idx += 1
    if h.location() == curr.location() {
      return idx
    }
  }
  return none
}

// Derived progress-bar tones: same hue family as primary, softened saturation & opacity
#let progress-colors(primary) = (
  fill: primary.lighten(14%).desaturate(16%).transparentize(46%),
  track: primary.lighten(10%).desaturate(22%).transparentize(90%),
)

// Content footer: preserves the progress bar on the left of the page number,
// with softened saturation & transparency in the same primary color family.
#let presentation-footer(self) = {
  set std.align(bottom)
  set text(size: 10pt, fill: self.colors.primary.desaturate(35%).transparentize(38%))
  let footer-height = 16pt
  let bar-height = 7pt
  let pc = progress-colors(self.colors.primary)
  if self.store.progress-bar {
    grid(
      columns: (1fr, 58pt),
      rows: footer-height,
      align: bottom,
      column-gutter: 4pt,
      utils.call-or-display(self, components.progress-bar(
        height: bar-height,
        pc.fill,
        pc.track,
      )),
      block(width: 100%, height: footer-height, fill: white)[
        #align(center + horizon, move(dy: -3.5pt,
          utils.call-or-display(self, self.store.footer-d)))
      ],
    )
  } else {
    align(right, pad(right: 1.9cm, bottom: 6pt, utils.call-or-display(self, self.store.footer-d)))
  }
}

/// Default content slide.
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  align: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  let header(self) = {
    set std.align(top)
    block(
      width: 100%,
      inset: (left: 1.9cm, right: 1.9cm, top: 0.85cm, bottom: 0pt),
      components.left-and-right(
        text(
          fill: self.colors.primary,
          weight: "bold",
          size: 21pt,
          utils.call-or-display(self, self.store.header),
        ),
        text(
          fill: self.colors.primary.lighten(60%),
          size: 11pt,
          utils.call-or-display(self, self.store.header-right),
        ),
      ),
    )
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: presentation-footer,
    ),
  )
  let new-setting = body => {
    show: std.align.with(self.store.align)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

/// Editorial title slide with adaptive accent rule width matching title/subtitle.
#let title-slide(
  config: (:),
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
    config-page(
      margin: (x: 2.2cm, top: 1.5cm, bottom: 1.5cm),
      header: none,
      footer: none,
    ),
  )
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let accent-line = self.colors.secondary.desaturate(16%).transparentize(20%)
  let body = {
    // Subtle top accent strip
    place(top + left, dx: -2.2cm, dy: -1.5cm,
      rect(width: 29.7cm, height: 3.5pt, fill: accent-line))

    // Top logo bar
    let right-logo = if "logo-right" in info and info.logo-right != none {
      info.logo-right
    } else if "logo" in info and info.logo != none {
      info.logo
    } else { none }

    grid(
      columns: (1fr, 1fr),
      align: (left + horizon, right + horizon),
      if "logo-left" in info and info.logo-left != none { info.logo-left },
      right-logo,
    )

    v(1fr)
    block(width: 88%, {
      if "kicker" in info and info.kicker != none {
        text(size: 12pt, weight: "semibold", fill: self.colors.secondary, tracking: 0.08em, info.kicker)
        v(12pt)
      }
      layout(avail => {
        let title-el = text(size: 42pt, weight: "bold", fill: self.colors.primary, info.title)
        let sub-el = if info.subtitle != none {
          text(size: 17pt, fill: c-muted, weight: "regular", info.subtitle)
        } else { none }

        title-el
        if sub-el != none {
          v(10pt)
          sub-el
        }
        v(20pt)
        // Adaptive rule width matching the wider of title or subtitle (capped at container width)
        context {
          let tw = measure(title-el).width
          let sw = if sub-el != none { measure(sub-el).width } else { 0pt }
          let rw = calc.min(calc.max(tw, sw), avail.width)
          line(length: rw, stroke: 2.2pt + accent-line)
        }
      })
      v(18pt)
      text(size: 15pt, fill: c-body, info.authors.join(h(18pt)))
      if info.institution != none {
        v(6pt)
        text(size: 13pt, fill: c-muted, info.institution)
      }
      if info.date != none {
        v(6pt)
        text(size: 12.5pt, fill: c-dim, utils.display-info-date(self))
      }
      if extra != none {
        v(6pt)
        extra
      }
    })
    v(1.15fr)
  }
  touying-slide(self: self, body)
})

// Immediate child headings of the current section (clean 1- or 2-column list)
#let section-contents(level: 1, accent: c-teal) = context {
  let section = utils.current-heading(level: level)
  if section != none {
    let collecting = false
    let children = ()
    for entry in query(heading) {
      if entry.location() == section.location() {
        collecting = true
      } else if collecting {
        if entry.level <= level { break }
        if entry.level == level + 1 and entry.outlined {
          children.push(link(entry.location(), entry.body))
        }
      }
    }
    if children.len() > 0 {
      v(14pt)
      set text(size: 14pt, fill: c-muted, weight: "regular")
      let items = children.enumerate().map(((i, c)) => [
        #text(fill: accent, weight: "semibold", size: 12pt)[#pad-two(i + 1)]
        #h(10pt)
        #c
      ])
      if items.len() <= 4 {
        stack(dir: ttb, spacing: 11pt, ..items)
      } else {
        grid(
          columns: (1fr, 1fr),
          column-gutter: 28pt,
          row-gutter: 11pt,
          ..items,
        )
      }
    }
  }
}

/// Clean section divider slide with softened progress bar matching the footer palette.
#let new-section-slide(
  config: (:),
  level: 1,
  numbered: false,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      margin: (x: 2.6cm, top: 1.8cm, bottom: 1.6cm),
      header: none,
      footer: none,
      fill: c-wash,
    ),
  )

  let pc = progress-colors(self.colors.primary)
  let slide-body = {
    place(left + top, dx: -2.6cm, dy: -1.8cm,
      rect(width: 5.5pt, height: 16.7cm, fill: pc.fill))

    v(1fr)
    context {
      let idx = current-section-index()
      if idx != none {
        text(
          size: 56pt,
          weight: "bold",
          fill: self.colors.primary.desaturate(30%).transparentize(82%),
          pad-two(idx),
        )
        v(-8pt)
      }
    }
    text(
      size: 32pt,
      weight: "bold",
      fill: self.colors.primary,
      utils.display-current-heading(level: level, numbered: numbered),
    )
    v(12pt)
    block(
      height: 5.5pt,
      width: 100%,
      spacing: 0pt,
      components.progress-bar(
        height: 5.5pt,
        pc.fill,
        pc.track,
      ),
    )
    section-contents(level: level, accent: self.colors.secondary)
    if body != none and body != [] {
      v(14pt)
      text(size: 12.5pt, fill: c-dim, body)
    }
    v(1.1fr)
  }
  touying-slide(self: self, config: config, slide-body)
})

/// Focus slide.
#let focus-slide(
  config: (:),
  background-color: none,
  background-img: none,
  body,
) = touying-slide-wrapper(self => {
  let background-color = if (
    background-img == none and background-color == none
  ) {
    rgb(self.colors.primary)
  } else {
    background-color
  }
  let args = (:)
  if background-color != none {
    args.fill = background-color
  }
  if background-img != none {
    args.background = {
      set image(fit: "stretch", width: 100%, height: 100%)
      background-img
    }
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 1em, ..args),
  )
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 2em)
  touying-slide(self: self, std.align(horizon, body))
})

/// Matrix slide.
#let matrix-slide(
  config: (:),
  columns: none,
  rows: none,
  ..bodies,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  touying-slide(
    self: self,
    config: config,
    composer: components.checkerboard.with(columns: columns, rows: rows),
    ..bodies,
  )
})

/// Touying university theme.
#let university-theme(
  aspect-ratio: "16-9",
  align: top,
  progress-bar: true,
  header: utils.display-current-heading(level: 2),
  header-right: self => (
    box(utils.display-current-heading(level: 1)) + h(.3em) + self.info.logo
  ),
  footer-columns: (42%, 42%, 1fr),
  footer-a: utils.display-current-heading(level: 1),
  footer-b: utils.display-current-heading(level: 2),
  footer-c: self => if self.info.short-title == auto {
    self.info.title
  } else {
    self.info.short-title
  },
  footer-d: context utils.slide-counter.display()
    + " / "
    + utils.last-slide-number,
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header-ascent: 0.35cm,
      footer-descent: 0pt,
      margin: (top: 2.5cm, bottom: 1.2cm, x: 1.9cm),
      fill: white,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: font-sans, size: 15pt, fill: c-body)
        set par(leading: 0.65em, spacing: 0.8em)
        show raw: set text(font: font-mono)
        show link: it => text(fill: self.colors.secondary, it)
        show heading.where(level: 3): set text(fill: self.colors.primary)
        show heading.where(level: 4): set text(fill: self.colors.primary)
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb("#04364A"),
      secondary: rgb("#176B87"),
      tertiary: rgb("#448C95"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#04364A"),
    ),
    config-store(
      align: align,
      progress-bar: progress-bar,
      header: header,
      header-right: header-right,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
      footer-d: footer-d,
    ),
    ..args,
  )

  body
}
