https://github.com/ys1231/sosearch

```Python
ef searchso(sopath, s):
    """
    搜索so文件字符串
    :param s: 需要搜索的字符串
    """
    if 'nt' == os.name:
        commad = os.path.join(os.path.split(sys.argv[0])[0], "commad/strings64.exe")
    else:
        commad = 'strings'
    process = subprocess.Popen([commad, '-a', sopath], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = process.communicate(timeout=5)
    arrayStr = []
    result = None
    if out is not None:
        print("> {}:开始分析!".format(os.path.split(sopath)[1]))
        print("> commad: strings -a {} | grep {}".format(sopath, s))
        result = out.decode('utf-8')
        if args.saveall is not None and result is not None:
            with open(args.saveall, 'a') as f:
                f.write('<====' + os.path.split(sopath)[1] + "====\n")
                f.write(result)
                f.write("====" + os.path.split(sopath)[1] + "====>\n")
                f.close()
        try:
            if args.ignorecase == 1:
                print("> -i 1 默认忽略大小写")
                items = re.finditer(s, result, re.IGNORECASE)
            else:
                items = re.finditer(s, result)
                print("> -i 0 区分大小写")
            for i in items:
                arg = result[i.start():-1]
                print(arg[:arg.find('\n')])
                if args.output:
                    arrayStr.append(arg[:arg.find('\n')])
        except Exception as e:
            print(e)
        print("> {}:分析完成!".format(os.path.split(sopath)[1]))
        if args.output is not None and len(arrayStr):
            with open(args.output, 'a') as f:
                f.write('<====' + os.path.split(sopath)[1] + "====\n")
                for i in arrayStr:
                    f.write(i + '\n')
                f.write("====" + os.path.split(sopath)[1] + "====>\n")
                f.close()
                print("> 分析结果:", args.output)
    else:
        print("> {}:分析超时 ".format(os.path.split(sopath)[1]), err)

```