import pandas as pd
import numpy as np
import platform
import matplotlib.pyplot as plt
from rich.console import Console
from rich.progress import track
from bs4 import BeautifulSoup
from urllib.request import urlopen, Request
import requests
import urllib
import time
from PIL import Image
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import nltk
from konlpy.tag import Okt; t = Okt()
from matplotlib import font_manager
f_path = "C:\Windows\Fonts\malgun.ttf"
font_manager.FontProperties(fname=f_path).get_name()
from matplotlib import rc
rc('font', family='Malgun Gothic')


class SearchNaverKIN:
    def __init__(self, keyword, page_num):
        self.html = 'http://kin.naver.com/search/list.nhn?query={key_word}&page={num}'
        self.keyword = keyword
        self.page_num = page_num + 1
        self.total_link = []
        self.present_candi_text = []
        self.present_text = ''
        self.stop_words = []
    
    def get_links_onpage(self, num):
        req = Request(self.html.format(num=num, key_word=urllib.parse.quote(self.keyword)))
        req.add_header('Referer', 'http://www.naver.com/')
        response = urlopen(req)
        soup = BeautifulSoup(response, "html.parser")
        return soup.find_all('dt')
 
    def get_total_link(self):
        for num in track(range(1, self.page_num)):
            self.total_link.extend(self.get_links_onpage(num))
            print(time.time(), ' : get link information from naver.')
        print('Complete! Link counts : ', len(self.total_link))
 
    def get_tag_text_from_links(self):
        for each_link in track(self.total_link):
            r = requests.get(each_link.a['href'])
            soup_tmp = BeautifulSoup(r.text, 'html.parser')
            search_result = soup_tmp.find_all('div', '_endContentsText')
            print(time.time(), ' : get text information from link.')
            time.sleep(0.5)
            for each in search_result:
                self.present_candi_text.append(each.get_text())
        tmp_text = ''
        for each_line in self.present_candi_text:
            tmp_text = tmp_text + each_line + '\n'
        self.present_text = tmp_text
        print('Complete! Text counts : ', len(self.present_candi_text))

    def convert_nltk(self):
        tokens_ko = t.nouns(self.present_text)
        tokens_ko = [each_word for each_word in tokens_ko if each_word not in self.stop_words]
        return nltk.Text(tokens_ko)

    def most_common(self, n):
        ko = self.convert_nltk()
        return ko.vocab().most_common(n)

    def save_most_common_words(self, n):
        ko = self.convert_nltk()
        plt.figure(figsize=(15,6))
        ko.plot(n)
        plt.savefig('most_common_words.png', dpi=300)
    
    def save_word_cloud(self, n):
        data = self.most_common(n)
        mask = np.array(Image.open('./datas/heart.jpg'))
        image_colors = ImageColorGenerator(mask)
        wordcloud = WordCloud(font_path=f_path, relative_scaling = 0.1, mask=mask, background_color = 'white', min_font_size=1, max_font_size=100).generate_from_frequencies(dict(data))
        default_colors = wordcloud.to_array()
        
        plt.figure(figsize=(12,12))
        plt.imshow(wordcloud.recolor(color_func=image_colors), interpolation='bilinear')
        plt.axis('off')
        plt.savefig('word_cloud.png', dpi=300)

if __name__ == "__main__":
    tmp = SearchNaverKIN('크리스마스 선물', 1)
    tmp.get_total_link()
    tmp.get_tag_text_from_links()
    print(tmp.present_text)
    tmp.stop_words = ['한', '수', '은' '들', '!', '도', '이', '\u200b',
 '을', '에', ',', '.', '[', ']', '~', '는', '것',
 '요', '제', '수', '것', '뼘', '제', '요', '해',
 '분', '때문', '더', '줄', '저', '줄', '스',
 '를', '때', '전']
    print(tmp.most_common(10))
    tmp.save_most_common_words(50)
    tmp.save_word_cloud(100)
