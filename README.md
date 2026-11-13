# template

一个 Git 仓库管理两个独立的 Typst 本地包：`note` 和 `pre`。本地仓库文件夹叫 `template`，远端继续使用 [Fragecity/note](https://github.com/Fragecity/note)。

## 目录

```text
template/
├── note/0.1.0/
│   ├── typst.toml          # 包名 note
│   ├── lib.typ
│   ├── assets/
│   └── template/main.typ
├── pre/0.1.0/
│   ├── typst.toml          # 包名 pre
│   ├── lib.typ
│   ├── themes/university.typ
│   ├── assets/
│   └── template/           # main.typ、contents/、figures/
├── scripts/install.py
└── Makefile
```

两个包各有自己的清单、入口和素材，可分别安装、导入和创建新项目。仓库根目录不是 Typst 包。

## 安装与更新

```sh
git clone git@github.com:Fragecity/note.git template
cd template
make install
```

安装脚本分别创建以下链接，指向仓库里的两个包：

```text
~/.local/share/typst/packages/local/note/0.1.0 → template/note/0.1.0
~/.local/share/typst/packages/local/pre/0.1.0  → template/pre/0.1.0
```

设置了 `XDG_DATA_HOME` 时使用该目录代替 `~/.local/share`。已有安装会先完整移入 `typst/package-backups/`，保留原文件和 Git 历史。重复安装会跳过正确的链接。更新仓库后链接立即生效；移动仓库目录后重新运行 `make install`。

```sh
git pull --ff-only
make check
```

要求 Python 3.11+（安装脚本）、Typst 0.14.0+、`Noto Sans` 和 `Noto Sans CJK SC` 字体。演示中的英文使用 `Libertinus Serif`。首次编译分别下载 quick-maths 0.2.1、Touying 0.6.1 及其依赖。

## note：笔记

```typ
#import "@local/note:0.1.0": template
#show: template.with(title: [笔记标题])

= 一级标题
中文正文。English text.

== 二级标题
正文。
```

`note` 是同一个函数的别名，也可以导入 `note` 后使用 `#show: note.with(...)`。原来的 `@local/note:0.1.0` 导入和 `template` 函数名继续有效。

保留中文字体、深蓝色一级标题、18mm 页边距、右下角页码、数学符号简写，以及只在首页显示的上海人工智能实验室图形标志。Logo 放在页边距，不挤压正文。`title` 可用字符串或内容块；无标题时使用 `#show: template`。

```sh
typst init @local/note:0.1.0 my-note
typst compile my-note/main.typ my-note/main.pdf
```

## pre：演示

```typ
#import "@local/pre:0.1.0": pre, title-slide, overview-slide
#show: pre.with(
  title: [演示标题],
  author: [Bian Kaiming],
  advisor: [Furong],
)

#title-slide()
#overview-slide()

= intro

== Motivation
正文。

== 页面标题
正文。
```

`pre` 的默认主讲人、导师为 Bian Kaiming、Furong；`slides` 是 `pre` 的别名。`advisor: none` 隐藏导师；`subtitle`、`date`、`institution` 可设置或留为 `none`，左右 Logo 可通过 `logo-left`、`logo-right` 替换或关闭。

- 默认 16:9，包含封面、自动 Overview、一级章节页和二级正文页。
- `= intro` 是一级 section；`== Motivation` 等为二级 section。Overview 默认仅显示一级标题，支持点击跳转。
- 一级章节页继承 university 设计：进度条位于标题下方，线宽 8pt，隐藏页眉和页脚。进度条下方自动列出当前章节的二级标题，与进度条左侧对齐，点击可跳转；不包含其他章节的标题。
- 正文进度条贴底、左侧顶格，高度 9.8pt；右侧为独立的 50pt 页码区域，页码上移 3pt，左下角无导航文字。
- 需要完整两级目录时，可显式使用 `overview-slide(depth: 2)`。
- `slide`、`title-slide`、`new-section-slide`、`focus-slide`、`matrix-slide` 可从包入口导入。

```sh
typst init @local/pre:0.1.0 my-pre
typst compile my-pre/main.typ my-pre/main.pdf
```

演示起始项目包含 `main.typ`、分章节的 `contents/` 和插图目录 `figures/`，仅保留空白占位。图形可在内容文件中导入 `@preview/cetz:0.5.2` 绘制。

## 验证与素材

`make check` 安装两个包并编译起始项目，结果为 `build/note.pdf`、`build/pre.pdf`，生成文件不提交到 Git。

演示主题来自 qc-pre/simu，基于 Touying university，保留原作者 Pol Dellaiera 的署名。各包的 Logo 来源见各自 `assets/README.md`。
