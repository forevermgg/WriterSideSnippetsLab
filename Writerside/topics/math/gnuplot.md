## 背景

>gnuplot是一套跨平台的数学绘图自由软件。使用命令列界面，可以绘制数学函数图形，也可以从纯文字档读入简单格式的座标资料，绘制统计图表等等。它可以提供多种输出格式，例如PNG，SVG，PS，HPGL，供文书处理、简报、试算表使用。它并不是统计软件或数学软件。 
gnuplot是有版权的，但自由分发；无须付费。

## 安装

### mac install

```shell
brew install gnuplot
```

## 使用

```shell
❯ gnuplot

	G N U P L O T
	Version 6.0 patchlevel 0    last modified 2023-12-09

	Copyright (C) 1986-1993, 1998, 2004, 2007-2023
	Thomas Williams, Colin Kelley and many others

	gnuplot home:     http://www.gnuplot.info
	faq, bugs, etc:   type "help FAQ"
	immediate help:   type "help"  (plot window: hit 'h')

	Terminal type is now qt
gnuplot> plot[-3.14:3.14]sin(x)
```