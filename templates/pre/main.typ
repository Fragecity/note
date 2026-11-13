#import "@local/template:0.1.0": pre, title-slide, overview-slide
#show: pre.with(title: [演示标题])

#title-slide()
#overview-slide()

// 一级 section；添加新章节时使用一个等号。
= intro

// 二级 section 写在内容文件中，添加正文页时使用两个等号。
#include "contents/01-intro.typ"
