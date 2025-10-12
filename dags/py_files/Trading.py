#%%writefile Trading.py

from selenium import webdriver
import chromedriver_autoinstaller
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
import re
import getpass
import datetime
from datetime import datetime
import numpy as np
import cv2
import os
import pyautogui
from PIL import Image

class Trading:
    
    def __init__(self, directory):
        
        self.directory= directory
        
    def open_browser(self):
        
        chrome_service = Service(executable_path=r"C:\Users\kzakr\gielda\chromedriver-win64\chromedriver.exe")

        self.driver = webdriver.Chrome(service = chrome_service, options=self.chrome_options)
        
        self.driver.maximize_window()
        self.driver.get("https://platform.cmcmarkets.com/#/login?b=CMC-CFD&r=PL&l=pl")
        
    def get_options(self):
        
        self.chrome_options = webdriver.ChromeOptions()
        self.chrome_options.add_argument('--disable-extensions')
        #self.chrome_options.add_argument("--headless")
        self.chrome_options.add_argument("--incognito")
        self.chrome_options.add_argument("--disable-search-engine-choice-screen");
        self.chrome_options.add_argument('--no-sandbox')
        
    def authorize(self, login:str, password:str):
        
        
        self.driver.find_element("id", "username").send_keys(login);
        self.driver.find_element("id", "password").send_keys(password);
        
        self.driver.find_element(By.XPATH, "//input[contains(@type,'submit')]").send_keys(Keys.RETURN)
        
        
    def reset_search(self):
        
        self.driver.find_element(By.XPATH, "//button[@title='Resetuj']").send_keys(Keys.RETURN)
    
    def type_search(self):
        
        self.driver.find_element(By.XPATH, "//input[@placeholder='Szukaj']").send_keys(self.instrument)
        
    def maximize(self):
        
        click_Max = self.driver.find_element(By.XPATH, "//div[@title='Maksymalizuj']")
        time.sleep(3)
        ActionChains(self.driver).move_to_element(click_Max).click(click_Max).perform()
        
    def minimize(self):
        
        click_Min = self.driver.find_element(By.XPATH, "//div[@title='Minimalizuj']")
        time.sleep(3)
        ActionChains(self.driver).move_to_element(click_Min).click(click_Min).perform()
        
    def open_chart(self):
        
        click_Menu = self.driver.find_element(By.XPATH, "//div[@title='{}']".format(self.title))
        time.sleep(3)
        ActionChains(self.driver).move_to_element(click_Menu).context_click(click_Menu).perform()
        
        WebElement = self.driver.find_element(By.XPATH, "//ul[@class='subnav']");
        WebElement;
        elements = WebElement.find_elements(By.TAG_NAME, 'li')
        
        ActionChains(self.driver).move_to_element(elements[5]).click(elements[5]).perform()

        
    def select_interval(self):
        
        
        click_Interwal = self.driver.find_element(By.XPATH, "//li[@title='Interwał']")
        ActionChains(self.driver).move_to_element(click_Interwal).click(click_Interwal).perform()
        time.sleep(5)
        click_interwal_value = self.driver.find_element(By.XPATH, "//li[@title='{}']".format(self.interval))
        ActionChains(self.driver).move_to_element(click_interwal_value).click(click_interwal_value).perform()
        
    def close_chart(self):
        
        click_Close = self.driver.find_element(By.XPATH, "//div[@title='Zamknij']")
        
        ActionChains(self.driver).move_to_element(click_Close).click(click_Close).perform()
        
    def get_specyfic_chart(self, instrument, interval, sleep_parameter:int):
        
        
        
       
        
        
        
       
        time.sleep(sleep_parameter)
        
        for  key, value in instruments.items():
           
                
            self.instrument_not_convert =key
            self.instrument = re.sub(r'_', r'/', key)
            self.title = re.sub(r'_', r'/', value)
        
                
        
                
            time.sleep(sleep_parameter)
            try:
                self.reset_search()
            except:
                pass
            time.sleep(sleep_parameter)
            self.type_search()
            time.sleep(sleep_parameter)
            self.open_chart()
            self.maximize()
            time.sleep(sleep_parameter)
            self.dt_string = self.get_time()
                
        
            for interval in intervals:
                self.interval = interval
                self.select_interval()
                time.sleep(sleep_parameter)
                
                self.get_snaphoot(self.instrument_not_convert,self.interval )
            self.minimize()
        

            time.sleep(sleep_parameter)
            
            time.sleep(sleep_parameter)
            self.close_chart()
            time.sleep(sleep_parameter)
        
    def get_snaphoot(self, instrument_to_save, interval_to_save):
        
        
        
        image = pyautogui.screenshot()
        image1 = pyautogui.screenshot(os.path.join(self.directory,instrument_to_save, self.dt_string+instrument_to_save +interval_to_save+'.png'))
        
    def get_time(self):
        
        now = datetime.now()

        dt_string = now.strftime("%Y%m%d_%H_%M")
        
        return dt_string
        
class Prepare_photo:
    
    def __init__(self):
        pass
        
    def load_picture(self, photo_path:str, photo_name:str):
        self.photo_path=photo_path; 
        
        self.photo_name = photo_name
        self.im = Image.open(os.path.join(self.photo_path, self.photo_name))
        
    def get_size(self):
        
        width, height = self.im.size
        
        return width, height
        
    def cut_phot(self, left, right,  top, bottom):
        
        
        
        self.im = self.im.crop((left, top, right, bottom))
        
    def show_picture(self):
        
        self.im.show()
        
    def save_picture(self, photo_path:str, photo_name:str):
        
        self.im.save(os.path.join(self.photo_path, r'cut_'+self.photo_name))
    
        
        
        