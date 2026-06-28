#yahooo


import pandas as pd
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
        
#9class ChromebrowserOption:
#9
#9    def __init__(self):
#9        pass
#9
#9    def initialize_chrom_options(self):
#9        print("kupa3")
#9        self.chrome_options = webdriver.ChromeOptions() #webdriver.Firefox()#webdriver
#9        return self.chrome_options 
#9    
#9    
#9    def get_options(self, list_of_options : list = ["--disable-extensions", "--incognito", "--disable-search-engine-choice-screen", "--no-sandbox", 
#9                                                    "--log-level=3", "--disable-gpu", "--disable-dev-shm-usage"]):
#9        
#9        print("kupa3")
#9
#9        for option in list_of_options:
#9            self.chrome_options.add_argument(option)
#9        print("kupa4")
#9        return self.chrome_options
#9    
#9class OpenChromeBrowser:
#9
#9    def __init__(self):
#9        pass
#9
#9
#9    def open_chrome(self, options, chrome_service ):
#9    
#9        self.driver = webdriver.Chrome(options=options,service = chrome_service)
#9
#9        return self.driver
#9    
#9    def get_web_page(self, url, delay_int = 1):
#9        
#9        time.sleep(delay_int)
#9        
#9        driver_launched = self.driver.get(url)
#9
#9        return driver_launched
#9
#9class StockResults:
#9   
#9    def __init__(self):
#9        pass
#9
#9    
#9    def specify_time(self):
#9        now = datetime.now()
#9        as_of_date = now.strftime("%Y%m%d_%H_%M")
#9        return as_of_date, now
#9    
#9    @staticmethod
#9    def specify_grid(from_param: int = 1, to_param: int = 9921, interval_param: int = 20):
#9
#9        return list(range(from_param,to_param,interval_param))
#9    
#9    @staticmethod
#9    def how_many_to_repeat(how_many: int = 10):
#9
#9        return how_many
#9    
#9    #def manage_chrome_driver_options(self):
#9    #    Chromebrowser = ChromebrowserOption()
#9    #    chrome_options = Chromebrowser.initialize_chrom_options()
#9    #    chrome_options = Chromebrowser.get_options()
#9    #    return chrome_options
#9    
#9    #def manage_chrome_driver(self, chrome_options):
#9    #    ChromeBrowser_page = OpenChromeBrowser()
#9    #    launched_driver = ChromeBrowser_page.open_chrome(chrome_options)
#9    #    #driver = ChromeBrowser_page.get_web_page(url)
#9    #    return ChromeBrowser_page, self.driver
#9    
#9    def save_excel_file(self, file_to_save, path: str, file_name:str, extention: str = 'csv'):
#9        
#9        file_to_save.to_csv(os.path.join(path, file_name+ extention))
#9        #with open(os.path.join(path, file_name+ extention), "w") as my_file:
#9        #    my_file.write(file_to_save)
#9
#9
#9    def run_process(self, how_many: int, grid: list, url : str, options):
#9        
#9        
#9        
#9        
#9        dt_string, now = self.specify_time()
#9        df_dict = {};
#9        main_df = pd.DataFrame()
#9
#9
#9        remote_webdriver = 'chrome'
#9        i = 0
#9        while i< how_many:
#9
#9            for i in grid:
#9
#9                
#9                with webdriver.Remote(f'http://{remote_webdriver}:4444/wd/hub', options=options) as launched_driver:
#9
#9                    print("kolejna kupa")
#9                    #print(i)
#9                    d0f_dict = {}
#9                    #driver.get(url+str(i))
#9                    try:
#9
#9                        launched_driver.get(url+str(i))
#9                        print(url+str(i))
#9                        time.sleep(2)
#9                        inputElement = launched_driver.find_element(By.XPATH, "//table[@class='styled-table-new is-rounded is-tabular-nums w-full screener_table']")
#9                    #
#9                    except Exception as ex:
#9                        print(12)
#9                        print(ex)
#9                        launched_driver.get(url+str(i))
#9                        print(url+str(i))
#9                        time.sleep(3)
#9                        inputElement = launched_driver.find_element(By.XPATH, "//table[@class='styled-table-new is-rounded is-tabular-nums w-full screener_table']")
#9                    #
#9                        
#9                    launched_driver.close()   
#9                    #print("zrzut")
#9                    #try:
#9                    #    
#9                    #    launched_driver.get(url+str(i))
#9                    #    print(url+str(i))
#9#
#9                    #    time.sleep(2)
#9#
#9                    #    inputElement = launched_driver.find_element(By.XPATH, "//table[@class='styled-table-new is-rounded is-tabular-nums w-full screener_table']")
#9                    #
#9                    #except Exception as ex:
#9#
#9                    #    try:
#9                    #        time.sleep(10)
#9#
#9                    #        launched_driver.get(url+str(i))
#9                    #        print(ex)
#9                    #        print("2nd attempt" )
#9                    #        print(url+str(i) )
#9#
#9                    #        time.sleep(2)
#9#
#9                    #        inputElement = launched_driver.find_element(By.XPATH, "//table[@class='styled-table-new is-rounded is-tabular-nums w-full screener_table']")
#9                    #    except Exception as ex:
#9                    #        print(ex)
#9                    #        pass
#9
#9                    
#9                    
#9                    
#9                    the_text = inputElement.text
#9                    #print("zrzut4")
#9                    launched_driver.close()
#9                    keysy =the_text.split("\n")[0].split(" ")
#9                    #print("zrzut5")
#9                    values  =the_text.split("\n")[1:]
#9                    #print("zrzut6")
#9                        #print(the_text)
#9                    values_loop = 0
#9                    #print("zrzut8")
#9                        #print(values_loop)
#9                        #print(values)
#9                    #print('ww' +str(55))
#9                    for value in values:
#9                        #print("zrzut8")
#9                        
#9                        if values_loop == len(keysy):
#9                            values_loop = 0
#9                            main_df= pd.concat([main_df, temp_df])    
#9                            #else:
#9                            #print("###")
#9                            #print(values_loop)
#9                        elif values_loop ==7:
#9                            values_loop +=1
#9
#9                        print(value)
#9
#9
#9                        #print("zrzut9")
#9                        try:
#9                            df_dict[keysy[values_loop]] = value
#9                            temp_df = pd.DataFrame(df_dict, index=[0])
#9                            temp_df['ticker'] = i
#9                            temp_df['time'] = dt_string
#9                            #print(temp_df)
#9
#9                        except Exception as ex:
#9                            print(ex)
#9                            
#9
#9
#9                        values_loop +=1
#9                        #print("zrzut9")
#9                            #df_dict['current_price'] = the_text_2
#9                        
#9                            #print(temp_df)
#9                #del temp_df
#9                                #print(main_df)
#9                    
#9                print(how_many)
#9                how_many = how_many+1   
#9            #self.save_excel_file(file_to_save = main_df, path= "/opt/airflow/dags/output_files", file_name= "finviz_" + str(dt_string[0:8]), extention= '.csv')
#9
#9            
#9                
#9
#9
#9        
#9    
#9    
#9
#9   
#9
#9
#9
#9
#9