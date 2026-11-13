#import "themes/university.typ": *

// Personal defaults; each item can be overridden with pre.with(...).
#let pre(
  title: [演示标题],
  subtitle: none,
  author: [Bian Kaiming],
  advisor: [Furong],
  date: none,
  institution: none,
  logo-left: image("assets/SUSTech LOGO CN.svg", height: 2cm),
  logo-right: box(width: 8.5cm, height: 2cm)[
    #align(right + horizon, image("assets/shanghai-ai-lab.webp", width: 120%))
  ],
  aspect-ratio: "16-9",
  progress-bar: true,
  outline-depth: 2,
  body,
) = {
  show: university-theme.with(
    aspect-ratio: aspect-ratio,
    progress-bar: progress-bar,
    config-info(
      title: [#text(size: 45pt, title)],
      subtitle: subtitle,
      author: [
        #author
        #if advisor != none {
          linebreak()
          v(0.5em)
          [导师：#advisor]
        }
      ],
      date: date,
      institution: institution,
      logo-left: logo-left,
      logo-right: logo-right,
    ),
    header-right: self => none,
  )
  show footnote.entry: set text(size: 12pt)
  set outline(depth: outline-depth)
  set text(font: ("Libertinus Serif", "Noto Sans CJK SC"))
  body
}

#let slides = pre

#let overview-slide(title: [Overview], depth: 2) = {
  heading(depth: 2, outlined: false, title)
  outline(title: none, depth: depth)
}
