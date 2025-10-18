#yahooo


from selenium import webdriver
import pandas as pd
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
#import time
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
import re
import getpass
import datetime
from datetime import datetime
import numpy as np
#import cv2
import os
#import pyautogui
#from PIL import Image

from datetime import datetime
import time



#
#chromedriver_autoinstaller.install()  # Check if the current version of chromedriver exists
#                                      # and if it doesn't exist, download it automatically,
#                                      # then add chromedriver to path
#
        
class ChromebrowserOption:

    def __init__(self):
        pass

    def initialize_chrom_options(self):
        print("kupa3")
        self.chrome_options = webdriver.ChromeOptions()
        return self.chrome_options 
    
    
    def get_options(self, list_of_options : list = ["--disable-extensions", "--incognito", "--disable-search-engine-choice-screen", "--no-sandbox", "--log-level=3"]):
        
        print("kupa3")

        for option in list_of_options:
            self.chrome_options.add_argument(option)
        
        return self.chrome_options
    
class OpenChromeBrowser:

    def __init__(self):
        pass


    def open_chrome(self, options, chrome_service ):
    
        self.driver = webdriver.Chrome(options=options,service = chrome_service)

        return self.driver
    
    def get_web_page(self, url, delay_int = 1):
        
        time.sleep(delay_int)
        
        driver_launched = self.driver.get(url)

        return driver_launched

class StockResults:
   
    def __init__(self):
        pass

    
    def specify_time(self):
        now = datetime.now()
        as_of_date = now.strftime("%Y%m%d_%H_%M")
        return as_of_date, now
    
    @staticmethod
    def specify_grid(from_param: int = 1, to_param: int = 9921, interval_param: int = 20):

        return list(range(from_param,to_param,interval_param))
    
    @staticmethod
    def how_many_to_repeat(how_many: int = 10):

        return how_many
    
    #def manage_chrome_driver_options(self):
    #    Chromebrowser = ChromebrowserOption()
    #    chrome_options = Chromebrowser.initialize_chrom_options()
    #    chrome_options = Chromebrowser.get_options()
    #    return chrome_options
    
    #def manage_chrome_driver(self, chrome_options):
    #    ChromeBrowser_page = OpenChromeBrowser()
    #    launched_driver = ChromeBrowser_page.open_chrome(chrome_options)
    #    #driver = ChromeBrowser_page.get_web_page(url)
    #    return ChromeBrowser_page, self.driver
    
    def save_excel_file(self, file_to_save, path: str, file_name:str, extention: str = 'csv'):
        
        file_to_save.to_csv(os.path.join(path, file_name+ extention))
        #with open(os.path.join(path, file_name+ extention), "w") as my_file:
        #    my_file.write(file_to_save)


    def run_process(self, how_many: int, grid: list, url : str, options):
        
        
        
        
        dt_string, now = self.specify_time()
        df_dict = {};
        main_df = pd.DataFrame()


        remote_webdriver = 'chrome'
        i = 0
        while i< how_many:

            with webdriver.Remote(f'http://{remote_webdriver}:4444/wd/hub', options=options) as launched_driver:

                for i in grid:
            

                    print("kolejna kupa")
                    #print(i)
                    d0f_dict = {}
                    #driver.get(url+str(i))
                    print("zrzut")
                    launched_driver.get(url+str(i))
                    print("zrzut1")
                    time.sleep(4)
                    print("zrzut2")
                    inputElement = launched_driver.find_element(By.XPATH, "//table[@class='styled-table-new is-rounded is-tabular-nums w-full screener_table']")
                    #print(inputElement.text)
                    print("zrzut3")
                    the_text = inputElement.text
                    print("zrzut4")
                    keysy =the_text.split("\n")[0].split(" ")
                    print("zrzut5")
                    values  =the_text.split("\n")[1:]
                    print("zrzut6")
                        #print(the_text)
                    values_loop = 0
                    print("zrzut8")
                        #print(values_loop)
                        #print(values)
                    #print('ww' +str(55))
                    for value in values:
                        print("zrzut8")
                        print(value)
                        if values_loop == len(keysy):
                            values_loop = 0
                            main_df= pd.concat([main_df, temp_df])    
                            #else:
                        elif values_loop ==7:
                            values_loop +=1
                           # print(value)
                            #print(keysy)
                            #print(values_loop)
                            #print(keysy[values_loop])
                            print(value)
                        print("zrzut9")
                        df_dict[keysy[values_loop]] = value
                        values_loop +=1
                        print("zrzut9")
                            #df_dict['current_price'] = the_text_2
                        temp_df = pd.DataFrame(df_dict, index=[0])
                        temp_df['ticker'] = i
                        temp_df['time'] = dt_string
                        #print(temp_df)
                            #print(temp_df)
                    del temp_df
                                #print(main_df)
                    
                    
                self.save_excel_file(file_to_save = main_df, path= "/opt/airflow/dags/output_files", file_name= "finviz_" + str(dt_string[0:8]), extention= '.csv')

            
                print(how_many)
                how_many = how_many+1


        
    
    

   




