# template

个人 Typst 模板合集，提供 `note`（笔记）和 `pre`（演示）两个入口。包名为 `template`，GitHub 仓库继续使用 `Fragecity/note`。

## 本地安装

Linux 默认包目录：

```sh
git clone git@github.com:Fragecity/note.git ~/.local/share/typst/packages/local/template/0.1.0
```

如果设置了 `XDG_DATA_HOME`，将包安装到 `$XDG_DATA_HOME/typst/packages/local/template/0.1.0`。已经安装后，在包目录中运行 `git pull --ff-only` 更新。

要求 Typst 0.14.0 或更新版本，以及 `Noto Sans`、`Noto Sans CJK SC` 字体。演示中的英文使用 `Libertinus Serif`。首次编译会下载 Touying 0.6.1 和 quick-maths 0.2.1。

## 笔记 note

```typ
#import "@local/template:0.1.0": note
#show: note.with(title: [笔记标题])

= 一级标题
中文正文。English text.

== 二级标题
正文。
```

保留原 note 的中文字体、深蓝一级标题、18mm 页边距、右下角页码、数学符号简写，以及仅首页显示的上海人工智能实验室图形标志。Logo 位于页边距，不挤压正文。`title` 可用字符串或内容块；不需要标题时使用 `#show: note`。

笔记起始文件见 `templates/note/main.typ`。旧的本地 `@local/note:0.1.0` 包未修改，已有文件仍可继续使用。迁移时将包名换为 `@local/template:0.1.0`；原函数名 `template` 也保留为 `note` 的别名。

## 演示 pre

```typ
#import "@local/template:0.1.0": pre, title-slide, overview-slide
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

默认主讲人和导师为 Bian Kaiming、Furong；可在 `pre.with(...)` 中修改。`advisor: none` 隐藏导师，`subtitle`、`date`、`institution` 均可设为内容块或 `none`。左右 Logo 通过 `logo-left`、`logo-right` 替换或关闭。`slides` 是 `pre` 的别名。

演示延续 `qc-pre` 的 university 主题，并纳入 simu 中确认过的排版：

- 默认 16:9，封面、自动 Overview、一级章节页和二级正文页。
- `= intro` 是一级 section；`== Motivation` 等是其下的二级 section，目录保留层级并支持点击跳转。
- 一级章节页的进度条在标题下方，线宽 8pt，隐藏页眉和页脚。
- 正文进度条贴紧底部及左侧，高度 9.8pt；右侧为独立的 50pt 页码区域，页码上移 3pt，左下角无导航文字。
- Overview 默认显示两级，可用 `overview-slide(depth: 1)` 仅显示一级章节。
- `slide`、`title-slide`、`new-section-slide`、`focus-slide`、`matrix-slide` 均可从包入口导入；底层主题位于 `themes/university.typ`。

创建包含分章节文件和插图目录的空白演示项目：

```sh
typst init @local/template:0.1.0 my-pre
cd my-pre
typst compile main.typ main.pdf
```

图形可在内容文件中导入 `@preview/cetz:0.5.2` 绘制。模板只保留可复用布局与空白占位，不包含 simu 的具体报告内容。

## 文件结构与验证

```text
lib.typ                    # 统一导出 note、pre 及演示组件
note.typ                   # 笔记样式
pre.typ                    # 演示配置及封面参数
themes/university.typ      # 演示主题
assets/                    # 共用 Logo 素材及来源
templates/note/main.typ     # 笔记起始文件
templates/pre/              # 演示起始项目
```

在已安装的包目录运行 `make check`，会编译两个模板到 `build/note.pdf` 和 `build/pre.pdf`。生成文件不提交到 Git。

`themes/university.typ` 来自本地 qc-pre/simu，基于 Touying university 主题，保留原作者 Pol Dellaiera 的署名。Logo 来源见 `assets/README.md`。
