 #!/usr/bin/python
 #coding:utf-8
import urllib
# requests: it is a http library to get the url for the searching results
# re: used for regex
import requests, re
# Beautifulsoup: parse the html to get the ‘li’ for the checking results
from bs4 import BeautifulSoup

# search keyword in baidu 
# use reference[1] to get all the HTML from the result html
url = 'https://www.baidu.com/s'
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.87 Safari/537.36'}
# use regex to match the every html result showing on the search result html
r1 = re.compile('<h3[\s\S]*?<a[^>]*?href[^>]*?"(.*?)"[^>]*?>(.*?)</a>')


def search(input):
    params = {'wd': keyword, 'pn': 0, 'ie': 'utf-8'}
    try:
        while 1:
            for i in r1.findall(requests.get(url, params, headers = headers).content):
                yield (re.compile('<.*?>').sub('', i[1]).decode('utf8'),i[0])
    except GeneratorExit:
        pass
    except:
        while 1: yield ('', '')

keyword = raw_input("Enter what you want to search:")
for i, result in enumerate(search(keyword)):
    if 500 < i: break
    
    print('%s:%s'%result)
    url2 = 'http://validator.w3.org/nu/?doc='+urllib.pathname2url(result[1])
    html = urllib.urlopen(url2)
    content = html.read().decode('utf-8')
    html.close()
    # use reference[2] to parse the check html and get all the errors and warnings with tag'li'
    soup  = BeautifulSoup(content,"lxml")
    table = soup.find_all("li")
    for p in table:
        print(p.text)
# ------------------------reference-------------------------
# [1]LittleCoder.. 是否可以通过调用百度或者谷歌等搜索引擎的api，实现对某个关键字的搜索然后通过python抽取网址？
#  [online]Available at< https://www.zhihu.com/question/46345033 > (2016/05/15)

# [2]但盼风雨来_jc.. Python爬虫（5）自制简单的搜索引擎
#  [online]Available at< https://www.jianshu.com/p/4e3d7caf8203 > (2017/12/08)



