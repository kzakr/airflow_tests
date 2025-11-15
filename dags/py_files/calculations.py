import re
import pandas as pd
import numpy as np


def std(x): 
    return np.std(x)
def calc_z_score(x,mean, std_dev):
    try:
        result = (x-mean)/std_dev
    except:
        result = 0
    return result

def convert_big_numbers(x):
    try:
        
        letter = re.findall("[A-Za-z]", x)[0]
        number = float(re.sub(letter[0],'', x))
    
        if letter =='B':
            multipier = 1000000000
        elif letter =='M':
            multipier = 1000000
        elif letter =='K':
            multipier = 100000
        else:
            multipier = 1
        
        number = number*multipier
    except:
        #print(number)
        number = 0
    
    return number

def identify_outlier(z_score, volume, z_score_thr = 3, volume_thr = 2000000):
    
    if z_score>z_score_thr and volume > volume_thr:
        return 'Y'
    else:
        return 'N'
    


def get_average_volume(DataFrame: pd.DataFrame, parameter:float = 0.8) -> list:

     
    ticker_list = DataFrame['Ticker'][(DataFrame.iloc[:,7]<0.8*DataFrame.iloc[:,11])\
                                        &(DataFrame.iloc[:,8]<0.8*DataFrame.iloc[:,11])\
                          &(DataFrame.iloc[:,9]<0.8*DataFrame.iloc[:,11])\
                                        &(DataFrame.iloc[:,10]<0.8*DataFrame.iloc[:,11])]
    
    return ticker_list


def get_declining_volume_price(DataFrame: pd.DataFrame) -> list:

    ticker_list = DataFrame['Ticker'][(DataFrame.iloc[:,7]>DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]>DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]>DataFrame.iloc[:,10])&\
                             (DataFrame.iloc[:,2]>DataFrame.iloc[:,3])&(DataFrame.iloc[:,3]>DataFrame.iloc[:,4])\
                          &(DataFrame.iloc[:,4]>DataFrame.iloc[:,5])]
    
    return ticker_list

def get_raising_volume_price(DataFrame: pd.DataFrame) -> list:

    ticker_list = DataFrame['Ticker'][(DataFrame.iloc[:,7]<DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]<DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]<DataFrame.iloc[:,10])&\
                             (DataFrame.iloc[:,2]<DataFrame.iloc[:,3])&(DataFrame.iloc[:,3]<DataFrame.iloc[:,4])\
                          &(DataFrame.iloc[:,4]<DataFrame.iloc[:,5])]
    
    return ticker_list


def get_declining_volume(DataFrame: pd.DataFrame) -> list:  

    ticker_list = DataFrame['Ticker'][(DataFrame.iloc[:,7]>DataFrame.iloc[:,8])\
                          &(DataFrame.iloc[:,8]>DataFrame.iloc[:,9])\
                              &(DataFrame.iloc[:,9]>DataFrame.iloc[:,10])]
    
    return ticker_list